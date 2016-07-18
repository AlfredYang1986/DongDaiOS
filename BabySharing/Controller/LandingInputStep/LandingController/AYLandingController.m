//
//  AYLandingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingController.h"
#import "AYFacade.h"
#import <objc/runtime.h>
#import "AYViewBase.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "Tools.h"
#import "AYRemoteCallDefines.h"

typedef NS_ENUM(NSInteger, RegisterResult) {
    RegisterResultSuccess,
    RegisterResultError,
    RegisterResultOthersLogin,
};

static NSString* const kAYLandingControllerRegisterResultKey = @"RegisterResult";

#define LOGO_TOP_MARGIN 144
#define KSCREENW                    [UIScreen mainScreen].bounds.size.width
#define KSCREENH                    [UIScreen mainScreen].bounds.size.height
#define INPUT_VIEW_TOP_MARGIN       ([UIScreen mainScreen].bounds.size.height / 6.0)
#define INPUT_VIEW_START_POINT      (title.frame.origin.y + title.frame.size.height + INPUT_VIEW_TOP_MARGIN)

@interface AYLandingController ()
@property (nonatomic, setter=setCurrentStatus:) RemoteControllerStatus landing_status;
@end

@implementation AYLandingController {
    CGRect keyBoardFrame;
    CGFloat modify;
    CGFloat diff;
    BOOL isUpAnimation;
    UIButton* pri_btn;
    UIView *phoneNoLogin;
    
    dispatch_semaphore_t wait_for_qq_api;
    dispatch_semaphore_t wait_for_weibo_api;
    dispatch_semaphore_t wait_for_wechat_api;
    dispatch_semaphore_t wait_for_login_model;
}

@synthesize landing_status = _landing_status;

- (id)init {
    self = [super init];
    if (self) {
        
        wait_for_qq_api = dispatch_semaphore_create(0);
        wait_for_weibo_api = dispatch_semaphore_create(0);
        wait_for_wechat_api = dispatch_semaphore_create(0);
        wait_for_login_model = dispatch_semaphore_create(0);
        
        dispatch_queue_t q = dispatch_queue_create("wait fow app ready", nil);
        dispatch_async(q, ^{
            dispatch_semaphore_wait(wait_for_qq_api, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(wait_for_weibo_api, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(wait_for_wechat_api, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(wait_for_login_model, DISPATCH_TIME_FOREVER);
            
            AYFacade* f = LOGINMODEL;
            id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
            id obj = nil;
            [cmd performWithResult:&obj];
            NSLog(@"current login user is %@", obj);

            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"app is ready");
                if (obj != nil && ((NSDictionary*)obj).count != 0) {
                    [self LoginSuccess];
                } else {
                    self.landing_status = RemoteControllerStatusReady;
                }
            });
        });
    }
    return self;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *bar= [UINavigationBar appearance];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [bar setShadowImage:[Tools imageWithColor:[UIColor colorWithWhite:0.5922 alpha:0.25] size:CGSizeMake(width, 1)]];
    [bar setBackgroundImage:[Tools imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    bar.barStyle = UIStatusBarStyleDefault;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"launchscreen"]];
//    UIImage *image = [UIImage fullscreenImageWithName:@"home_bg.png"];
    self.view.layer.contents = (id)IMGRESOURCE(@"launchscreen").CGImage;
   
    isUpAnimation = NO;
    
    UIImageView *title = [[UIImageView alloc]init];
    title.image = PNGRESOURCE(@"login_logo");
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(144);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(163, 73));
    }];
    title.hidden = YES;
    
    phoneNoLogin = [[UIView alloc]init];
    [self.view addSubview:phoneNoLogin];
//    [phoneNoLogin setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    phoneNoLogin.backgroundColor = [Tools colorWithRED:238.f GREEN:251.f BLUE:250.f ALPHA:1.f];
    phoneNoLogin.layer.cornerRadius = 2.f;
    phoneNoLogin.clipsToBounds = YES;
    
    [phoneNoLogin mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(KSCREENH * 398/667);
        make.bottom.equalTo(self.view).offset(-226);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(37.5);
        make.right.equalTo(self.view).offset(-37.5);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *p_login_img = [[UIImageView alloc]init];
    p_login_img.image = PNGRESOURCE(@"phone_icon");
    [phoneNoLogin addSubview:p_login_img];
    [p_login_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNoLogin.mas_centerX).offset(-50);
        make.centerY.equalTo(phoneNoLogin);
        make.size.mas_equalTo(CGSizeMake(10, 20));
    }];
    UILabel *p_login_text = [[UILabel alloc]init];
    p_login_text.text = @"手机号登录";
    p_login_text.font = [UIFont systemFontOfSize:14.f];
    p_login_text.textColor = [Tools themeColor];
    [phoneNoLogin addSubview:p_login_text];
    [p_login_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneNoLogin.mas_centerX).offset(50);
        make.centerY.equalTo(phoneNoLogin);
    }];
    
    phoneNoLogin.userInteractionEnabled = YES;
    [phoneNoLogin addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushInputPhoneNo)]];
    
    
    /****** *****/
    pri_btn = [[UIButton alloc]init];
    [self.view addSubview:pri_btn];
    pri_btn.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [pri_btn setTitle:@"进入即同意用户协议及隐私条款" forState:UIControlStateNormal];
    [pri_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pri_btn.clipsToBounds = YES;
    [pri_btn addTarget:self action:@selector(pri_btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [pri_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-22);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(15);
    }];
}

- (void)postPerform {
    [super postPerform];
    self.landing_status = RemoteControllerStatusPrepare;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    UIView* sns_view = [self.views objectForKey:@"LandingSNS"];
//    if (sns_view.hidden) {
//        
//        sns_view.hidden = NO;
//        phoneNoLogin.hidden = NO;
//        pri_btn.hidden = NO;
//    }
}

#pragma mark -- views layouts
- (id)LandingSNSLayout:(UIView*)view {
    NSLog(@"Landing SNS View view layout");
    view.frame = CGRectMake(0, KSCREENH - 108 - 36 - 46, KSCREENW, view.frame.size.height);
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    NSLog(@"Landing Loading View view layout");
    view.frame = CGRectMake(0, 0, KSCREENW, KSCREENH);
    return nil;
}

#pragma mark -- move views
- (void)keyBoardWillShow:(NSNotification *)notification {
    if (isUpAnimation) {
        return;
    }
    
    UIView* inputView = [self.views objectForKey:@"LandingInput"];
    UIView* title = [self.views objectForKey:@"LandingTitle"];
    
    isUpAnimation = !isUpAnimation;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    CGFloat maxY = CGRectGetMaxY(inputView.frame);
    diff = self.view.frame.size.height - maxY - keyBoardFrame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        inputView.center = CGPointMake(inputView.center.x, inputView.center.y + diff);
        title.alpha = 0.f;
//        title.center = CGPointMake(title.center.x, title.center.y + diff);
//        slg.center = CGPointMake(slg.center.x, slg.center.y + diff);
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    if (!isUpAnimation) {
        return;
    }
    UIView* inputView = [self.views objectForKey:@"LandingInput"];
    UIView* title = [self.views objectForKey:@"LandingTitle"];

    isUpAnimation = !isUpAnimation;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    [UIView animateWithDuration:0.3 animations:^{
        inputView.center = CGPointMake(inputView.center.x, inputView.center.y - diff);
        title.alpha = 1.f;
//        title.center = CGPointMake(title.center.x, title.center.y - diff);
//        slg.center = CGPointMake(slg.center.x, slg.center.y - diff);
    }];
}

#pragma mark -- actions
-(void)pri_btnDidClick{
    NSLog(@"push to suer privacy");
    id<AYCommand> UserAgree = DEFAULTCONTROLLER(@"UserAgree");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:UserAgree forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic];
}

-(void)pushInputPhoneNo{
    id<AYCommand> des = DEFAULTCONTROLLER(@"InputCoder");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic];
}

#pragma mark -- status
- (void)setCurrentStatus:(RemoteControllerStatus)new_status {
    _landing_status = new_status;
    
    UIView* sns_view = [self.views objectForKey:@"LandingSNS"];
    UIView* loading_view = [self.views objectForKey:@"Loading"];
    
    switch (_landing_status) {
        case RemoteControllerStatusReady: {
            phoneNoLogin.hidden = NO;
            pri_btn.hidden = NO;
            sns_view.hidden = NO;
            loading_view.hidden = YES;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"stopGif"] performWithResult:nil];
            [loading_view removeFromSuperview];
            }
            break;
        case RemoteControllerStatusPrepare:
        case RemoteControllerStatusLoading: {
            phoneNoLogin.hidden = YES;
            pri_btn.hidden = YES;
            sns_view.hidden = YES;
            loading_view.hidden = NO;
            [self.view addSubview:loading_view];
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"startGif"] performWithResult:nil];
            }
            break;
        default:
            @throw [[NSException alloc]initWithName:@"提示" reason:@"登陆状态设置错误" userInfo:nil];
            break;
    }
}

#pragma mark -- notifycation
- (id)SNSQQRegister:(id)args {
    dispatch_semaphore_signal(wait_for_qq_api);
    return nil;
}

- (id)SNSWechatRegister:(id)args {
    dispatch_semaphore_signal(wait_for_wechat_api);
    return nil;
}

- (id)SNSWeiboRegister:(id)args {
    dispatch_semaphore_signal(wait_for_weibo_api);
    return nil;
}

- (id)LoginModelRegister:(id)args {
    dispatch_semaphore_signal(wait_for_login_model);
    return nil;
}

- (id)SNSStartLogin:(id)args {
//    self.landing_status = RemoteControllerStatusLoading;
    return nil;
}

- (id)SNSEndLogin:(id)args {
//    self.landing_status = RemoteControllerStatusReady;
    return nil;
}

- (id)SNSLoginSuccess:(id)args {
    NSLog(@"SNS Login success with %@", args);
    self.landing_status = RemoteControllerStatusLoading;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:[NSNumber numberWithInt:RegisterResultSuccess] forKey:kAYLandingControllerRegisterResultKey];
    [dic setValue:args forKey:kAYControllerChangeArgsKey];
    [self performWithResult:&dic];
    
    return nil;
}

/**
 * 跟换 环信
 */
- (id)LoginEMSuccess:(id)args {
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
    UIViewController* controller = [Tools activityViewController];
    if (controller == self) {
        if ([[((NSDictionary*)args) objectForKey:@"user_id"] isEqualToString:[((NSDictionary*)obj) objectForKey:@"user_id"]]) {
            NSLog(@"finally login over success");
            
            AYViewController* des = DEFAULTCONTROLLER(@"TabBar");
            
            NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
            [dic_show_module setValue:kAYControllerActionShowModuleValue forKey:kAYControllerActionKey];
            [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
            
            id<AYCommand> cmd_show_module = SHOWMODULE;
            [cmd_show_module performWithResult:&dic_show_module];
            
        } else {
            NSLog(@"something wrong with login process");
            @throw [[NSException alloc]initWithName:@"error" reason:@"something wrong with login process" userInfo:nil];
        }
    }
    
    return nil;
}

- (id)LoginXMPPSuccess:(id)args {
    NSLog(@"Login XMPP success");
    
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
    UIViewController* controller = [Tools activityViewController];
    if (controller == self) {
        if ([[((NSDictionary*)args) objectForKey:@"user_id"] isEqualToString:[((NSDictionary*)obj) objectForKey:@"user_id"]]) {
            NSLog(@"finally login over success");
           
            AYViewController* des = DEFAULTCONTROLLER(@"TabBar");
//            AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
            
            NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
            [dic_show_module setValue:kAYControllerActionShowModuleValue forKey:kAYControllerActionKey];
            [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
       
            id<AYCommand> cmd_show_module = SHOWMODULE;
            [cmd_show_module performWithResult:&dic_show_module];
        
        } else {
            NSLog(@"something wrong with login process");
            @throw [[NSException alloc]initWithName:@"error" reason:@"something wrong with login process" userInfo:nil];
        }
    }
    
    return nil;
}

- (id)LoginSuccess {
    NSLog(@"Login Success");
//    NSLog(@"to do login with XMPP server");
    NSLog(@"to do login with EM server");
    
    self.landing_status = RemoteControllerStatusLoading;
    
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
    NSLog(@"current login user is %@", obj);
    
    AYFacade* xmpp = [self.facades objectForKey:@"EM"];
    id<AYCommand> cmd_login_xmpp = [xmpp.commands objectForKey:@"LoginEM"];
    NSDictionary* dic = (NSDictionary*)obj;
    NSString* current_user_id = [dic objectForKey:@"user_id"];
    [cmd_login_xmpp performWithResult:&current_user_id];
    
    return nil;
}

- (id)LogoutCurrentUser {
    NSLog(@"current user logout");
//    [_lm signOutCurrentUser];
   
    NSDictionary* current_login_user = nil;
    CURRENUSER(current_login_user);
   
    id<AYFacadeBase> f_login_remote = [self.facades objectForKey:@"LandingRemote"];
    AYRemoteCallCommand* cmd_sign_out = [f_login_remote.commands objectForKey:@"AuthSignOut"];
    [cmd_sign_out performWithResult:current_login_user andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"login out %@", result);
        NSLog(@"current login user %@", current_login_user);
        
        {
            AYFacade* f = [self.facades objectForKey:@"EM"];
            id<AYCommand> cmd_xmpp_logout = [f.commands objectForKey:@"LogoutEM"];
            [cmd_xmpp_logout performWithResult:nil];
        }
        
        {
            AYFacade* f = LOGINMODEL;
            id<AYCommand> cmd_sign_out_local = [f.commands objectForKey:@"SignOutLocal"];
            [cmd_sign_out_local performWithResult:nil];
        }
        
        [[Tools activityViewController] dismissViewControllerAnimated:YES completion:nil];
        self.landing_status = RemoteControllerStatusReady;
    }];
    
    return nil;
}

#pragma mark -- remote notification
- (id)LandingReqConfirmCodeRemoteResult:(BOOL)success RemoteArgs:(NSDictionary*)result {
    /**
     * update local database
     */
    NSLog(@"remote req confirm code notify");
    AYModel* m = MODEL;
    AYFacade* f = [m.facades objectForKey:@"LoginModel"];
    id<AYCommand> cmd = [f.commands objectForKey:@"ChangeTmpUser"];
    [cmd performWithResult:&result];
    /**
     * refresh timer
     */   
    id<AYViewBase> view = [self.views objectForKey:@"LandingInput"];
    id<AYCommand> cmd_view = [view.commands objectForKey:@"startConfirmCodeTimer"];
    [cmd_view performWithResult:nil];
   
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户验证码已发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    return nil;
}

- (id)LandingAuthConfirmRemoteResult:(BOOL)success RemoteArgs:(NSDictionary*)result {
    NSLog(@"remote auth confirm notify");
    NSString* msg = [result objectForKey:@"message"];
    if (success) {
        if ([msg isEqualToString:@"already login"]) {
            [self performForView:nil andFacade:@"LoginModel" andMessage:@"ChangeRegUser" andArgs:result];
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
            [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic setValue:[NSNumber numberWithInt:RegisterResultOthersLogin] forKey:kAYLandingControllerRegisterResultKey];
            [dic setValue:result forKey:kAYControllerChangeArgsKey];
            [self performWithResult:&dic];
        }
        else if ([msg isEqualToString:@"new user"]) {
            [self performForView:nil andFacade:@"LoginModel" andMessage:@"ChangeRegUser" andArgs:result];
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
            [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic setValue:[NSNumber numberWithInt:RegisterResultSuccess] forKey:kAYLandingControllerRegisterResultKey];
            [dic setValue:result forKey:kAYControllerChangeArgsKey];
            [self performWithResult:&dic];
        }
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
    }
        
    
    return nil;
}

#pragma mark -- perform to other controller
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        RegisterResult r = ((NSNumber*)[dic objectForKey:kAYLandingControllerRegisterResultKey]).integerValue;
        switch (r) {
            case RegisterResultSuccess: {
                
                NSMutableDictionary *dic_info = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
                NSString* role_name = [dic_info objectForKey:@"role_tag"];
                if ([role_name isEqualToString:@""] || !role_name) {
                    
                    [dic_info setValue:@" " forKey:@"role_tag"];
                    AYViewController* des = DEFAULTCONTROLLER(@"Welcome");
                    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
                    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
                    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
                    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
                    [dic_push setValue:[dic_info copy] forKey:kAYControllerChangeArgsKey];
                    id<AYCommand> cmd = PUSH;
                    [cmd performWithResult:&dic_push];
                } else {
//                    NSDictionary *args = [dic objectForKey:kAYControllerChangeArgsKey];
                    id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
                    AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
                    [cmd_profile performWithResult:[dic_info copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                        NSLog(@"Update user detail remote result: %@", result);
                        if (success) {
                            AYModel* m = MODEL;
                            AYFacade* f = [m.facades objectForKey:@"LoginModel"];
                            id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
                            [cmd performWithResult:&result];
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法登录，参数设置错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                            [alert show];
                        }
                    }];
                }
//                if (![[[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"role_tag"] isEqualToString:@""]) {
//                }
//                if (![[[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"role_tag"] isEqualToString:@""]) {
//                    AYViewController* des = DEFAULTCONTROLLER(@"Welcome");
//                    
//                    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
//                    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//                    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
//                    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//                    [dic_push setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
//                    id<AYCommand> cmd = PUSH;
//                    [cmd performWithResult:&dic_push];
//                }
            }
                break;
            case RegisterResultOthersLogin: {
                AYViewController* des = DEFAULTCONTROLLER(@"InputName");
                
                NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
                [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
                [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
                [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
                [dic_push setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
                
                id<AYCommand> cmd = PUSH;
                [cmd performWithResult:&dic_push];
            }
                break;
            case RegisterResultError:
                break;
            default:
                break;
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSString* method_name = [dic objectForKey:kAYControllerChangeArgsKey];
        
        SEL sel = NSSelectorFromString(method_name);
        Method m = class_getInstanceMethod([self class], sel);
        if (m) {
            IMP imp = method_getImplementation(m);
            id (*func)(id, SEL, ...) = imp;
            func(self, sel);
        }
    }
}

- (id)CurrentLoginUserChanged:(id)args {
    
    [self LoginSuccess];
    return nil;
}


- (id)startRemoteCall:(id)obj {
    self.landing_status = RemoteControllerStatusLoading;
    return nil;
}

- (id)endRemoteCall:(id)obj {
    self.landing_status = RemoteControllerStatusReady;
    return nil;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
