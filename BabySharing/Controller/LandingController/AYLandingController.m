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
#import "Tools.h"

typedef enum : NSUInteger {
    LandingStatusPrepare,
    LandingStatusReady,
    LandingStatusLoading,
} LandingStatus;

typedef NS_ENUM(NSInteger, RegisterResult) {
    RegisterResultSuccess,
    RegisterResultError,
    RegisterResultOthersLogin,
};

static NSString* const kAYLandingControllerRegisterResultKey = @"RegisterResult";

#define LOGO_TOP_MARGIN 97

#define INPUT_VIEW_TOP_MARGIN       ([UIScreen mainScreen].bounds.size.height / 6.0)
#define INPUT_VIEW_START_POINT      (title.frame.origin.y + title.frame.size.height + INPUT_VIEW_TOP_MARGIN)

@interface AYLandingController ()
@property (nonatomic, setter=setCurrentStatus:) LandingStatus landing_status;
@end

@implementation AYLandingController {
    CGRect keyBoardFrame;
    CGFloat modify;
    CGFloat diff;
    BOOL isUpAnimation;
    
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
                if (obj != nil) {
                    [self LoginSuccess];
                } else {
                    self.landing_status = LandingStatusReady;
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
   
    isUpAnimation = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)postPerform {
    [super postPerform];
    self.landing_status = LandingStatusPrepare;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- views layouts
- (id)LandingTitleLayout:(UIView*)view {
    NSLog(@"Landing Title view layout");
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.center = CGPointMake(width / 2, LOGO_TOP_MARGIN + view.bounds.size.height / 2);
    return nil;
}

- (id)LandingInputLayout:(UIView*)view {
    NSLog(@"Landing Input View view layout");
    CGFloat last_height = view.bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView* title = [self.views objectForKey:@"LandingTitle"];
    view.frame = CGRectMake(0, INPUT_VIEW_START_POINT, width, last_height);
    return nil;
}

- (id)LandingSNSLayout:(UIView*)view {
    NSLog(@"Landing SNS View view layout");
//    view.delegate = self;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat sns_height = view.bounds.size.height;
    view.frame = CGRectMake(0, height - sns_height, width, sns_height);
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    NSLog(@"Landing Loading View view layout");

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, height);
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
- (void)handleTap:(UITapGestureRecognizer*)gueture {
    id<AYViewBase> view = [self.views objectForKey:@"LandingInput"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
}

#pragma mark -- status
- (void)setCurrentStatus:(LandingStatus)new_status {
    _landing_status = new_status;
    
    UIView* inputView = [self.views objectForKey:@"LandingInput"];
    UIView* sns_view = [self.views objectForKey:@"LandingSNS"];
    UIView* loading_view = [self.views objectForKey:@"Loading"];
    
    switch (_landing_status) {
        case LandingStatusReady: {
            inputView.hidden = NO;
            sns_view.hidden = NO;
            loading_view.hidden = YES;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"stopGif"] performWithResult:nil];
            }
            break;
        case LandingStatusPrepare:
        case LandingStatusLoading: {
            inputView.hidden = YES;
            sns_view.hidden = YES;
            loading_view.hidden = NO;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"startGif"] performWithResult:nil];
            }
            break;
        default:
            @throw [[NSException alloc]initWithName:@"Error" reason:@"登陆状态设置错误" userInfo:nil];
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

- (id)SNSLoginSuccess:(id)args {
    NSLog(@"SNS Login success with %@", args);
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:[NSNumber numberWithInt:RegisterResultSuccess] forKey:kAYLandingControllerRegisterResultKey];
    [dic setValue:args forKey:kAYControllerChangeArgsKey];
    [self performWithResult:&dic];
    
    return nil;
}

- (id)LoginXMPPSuccess:(id)args {
    NSLog(@"Login XMPP success");
    
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
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
    
    return nil;
}

- (id)LoginSuccess {
    NSLog(@"Login Success");
    NSLog(@"to do login with XMPP server");
    
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
    NSLog(@"current login user is %@", obj);
    
    AYFacade* xmpp = [self.facades objectForKey:@"XMPP"];
    id<AYCommand> cmd_login_xmpp = [xmpp.commands objectForKey:@"LoginXMPP"];
    NSDictionary* dic = (NSDictionary*)obj;
    NSString* current_user_id = [dic objectForKey:@"user_id"];
    [cmd_login_xmpp performWithResult:&current_user_id];
    
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
    if (success) {
        [self performForView:nil andFacade:@"LoginModel" andMessage:@"ChangeRegUser" andArgs:result];
//        return LoginModelResultSuccess;
       
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic setValue:[NSNumber numberWithInt:RegisterResultSuccess] forKey:kAYLandingControllerRegisterResultKey];
        [dic setValue:result forKey:kAYControllerChangeArgsKey];
        [self performWithResult:&dic];
        
    } else {
        NSString* msg = [result objectForKey:@"message"];
        if ([msg isEqualToString:@"already login"]) {
            [self performForView:nil andFacade:@"LoginModel" andMessage:@"ChangeRegUser" andArgs:result];
 
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
            [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic setValue:[NSNumber numberWithInt:RegisterResultOthersLogin] forKey:kAYLandingControllerRegisterResultKey];
            [dic setValue:result forKey:kAYControllerChangeArgsKey];
            [self performWithResult:&dic];

        } else if ([msg isEqualToString:@"new user"]) {
            
            [self performForView:nil andFacade:@"LoginModel" andMessage:@"ChangeRegUser" andArgs:result];
 
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
            [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic setValue:[NSNumber numberWithInt:RegisterResultSuccess] forKey:kAYLandingControllerRegisterResultKey];
            [dic setValue:result forKey:kAYControllerChangeArgsKey];
            [self performWithResult:&dic];
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
//            return LoginModelResultError;
        }
        
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
                AYViewController* des = DEFAULTCONTROLLER(@"UserInfoInput");
                
                NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
                [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
                [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
                [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
                [dic_push setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
                
                id<AYCommand> cmd = PUSH;
                [cmd performWithResult:&dic_push];
            }
                break;
            case RegisterResultOthersLogin: {
                AYViewController* des = DEFAULTCONTROLLER(@"OthersLogin");
                
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
@end
