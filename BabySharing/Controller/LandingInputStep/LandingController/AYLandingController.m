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
#import "AYRemoteCallDefines.h"
#import "AYAlertView.h"

#import "RemoteInstance.h"

typedef NS_ENUM(NSInteger, RegisterResult) {
    RegisterResultSuccess,
    RegisterResultError,
    RegisterResultOthersLogin,
};

static NSString* const kAYLandingControllerRegisterResultKey = @"RegisterResult";

@interface AYLandingController ()
@property (nonatomic, setter=setCurrentStatus:) RemoteControllerStatus landing_status;
@end

@implementation AYLandingController {
    CGRect keyBoardFrame;
    CGFloat modify;
    CGFloat diff;
	
    UIButton* pri_btn;
    UIButton *phoneNoLogin;
    UIButton *weChatLogin;
    BOOL isWXInstall;
	
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
					
					NSDictionary *user;
					CURRENUSER(user);
					
					id<AYFacadeBase> auth_facade = DEFAULTFACADE(@"AuthRemote");
					AYRemoteCallCommand* auth_cmd = [auth_facade.commands objectForKey:@"IsTokenExpired"];
					[auth_cmd performWithResult:[user copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
						if (success) {
							NSNumber* isExpired = [result objectForKey:@"isExpired"];
							if (isExpired && isExpired.boolValue) {
								AYFacade* f_login = LOGINMODEL;
								id<AYCommand> cmd_sign_out_local = [f_login.commands objectForKey:@"SignOutLocal"];
								[cmd_sign_out_local performWithResult:nil];
								
							} else if(isExpired && !isExpired.boolValue) {
								[self LoginSuccess];
							}
						} else {
							[self LoginSuccess];
						}
					}];
					
                } else {
                    self.landing_status = RemoteControllerStatusReady;
                }
            });
        });
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.layer.contents = (id)IMGRESOURCE(@"launchscreen").CGImage;
    self.view.backgroundColor = [Tools themeColor];
	
	
	// 状态栏(statusbar)
	CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
	//标题栏
	CGRect NavRect = self.navigationController.navigationBar.frame;
	NSLog(@"status.h-%f/nav.h-%f", StatusRect.size.height, NavRect.size.height);
	
    UIImageView *logo = [[UIImageView alloc]init];
    logo.image = IMGRESOURCE(@"login_logo");
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 68/667);
        make.left.equalTo(self.view).offset(43);
        make.size.mas_equalTo(CGSizeMake(52, 52)); //46
    }];
    
//    UIDevice *device = [UIDevice currentDevice];
//    NSLog(@"name  %@",device.name);
//    NSLog(@"model  %@",device.model);
//    NSLog(@"localizedModel  %@",device.localizedModel);
//    NSLog(@"systemName  %@",device.systemName);
//    NSLog(@"systemVersion  %@",device.systemVersion);
    
    UILabel *welcome = [Tools creatUILabelWithText:@"欢迎来到 咚哒" andTextColor:[UIColor whiteColor] andFontSize:624.f andBackgroundColor:nil andTextAlignment:0];
    [self.view addSubview:welcome];
    [welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo);
        make.top.equalTo(logo.mas_bottom).offset(20);
    }];
    
    UILabel *welTips = [Tools creatUILabelWithText:@"为孩子预订贴心服务，\n体验与众不同的轻松时刻。" andTextColor:[UIColor whiteColor] andFontSize:24.f andBackgroundColor:nil andTextAlignment:0];
    welTips.numberOfLines = 0;
    [self.view addSubview:welTips];
    [welTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(welcome.mas_bottom).offset(17);
        make.left.equalTo(logo);
    }];
    
    if (SCREEN_WIDTH < 375) {
        welcome.font = [UIFont boldSystemFontOfSize:20.5f];
        welTips.font = kAYFontLight(20.5f);
    }
    
    phoneNoLogin = [[UIButton alloc]init];
    phoneNoLogin.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [phoneNoLogin setTitle:@"手机号登录" forState:UIControlStateNormal];
    [phoneNoLogin setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [phoneNoLogin setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [phoneNoLogin setImage:IMGRESOURCE(@"phone_icon") forState:UIControlStateNormal];
    [phoneNoLogin setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    [phoneNoLogin setBackgroundColor:[UIColor colorWithWhite:1.f alpha:1.f]];
    phoneNoLogin.layer.cornerRadius = 45.f * 0.5;
    phoneNoLogin.clipsToBounds = YES;
    [self.view addSubview:phoneNoLogin];
    [phoneNoLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 0.6);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(43);
        make.right.equalTo(self.view).offset(-43);
        make.height.mas_equalTo(45);
    }];
    [phoneNoLogin addTarget:self action:@selector(pushInputPhoneNo) forControlEvents:UIControlEventTouchUpInside];
    
    weChatLogin = [[UIButton alloc]init];
    weChatLogin.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [weChatLogin setTitle:@"微信帐号登录" forState:UIControlStateNormal];
    [weChatLogin setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [weChatLogin setImage:IMGRESOURCE(@"login_wechat") forState:UIControlStateNormal];
    [weChatLogin setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [weChatLogin setBackgroundColor:[Tools themeColor]];
    weChatLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    weChatLogin.layer.borderWidth = 2.f;
    weChatLogin.layer.cornerRadius = 45.f * 0.5;
    weChatLogin.clipsToBounds = YES;
    [self.view addSubview:weChatLogin];
    [weChatLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNoLogin.mas_bottom).offset(22.5);
        make.centerX.equalTo(phoneNoLogin);
        make.size.equalTo(phoneNoLogin);
    }];
    [weChatLogin addTarget:self action:@selector(didWeChatLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
    id<AYCommand> cmd_login = [f.commands objectForKey:@"IsInstalledWechat"];
    NSNumber *IsInstalledWechat = [NSNumber numberWithBool:NO];
    [cmd_login performWithResult:&IsInstalledWechat];
    isWXInstall = IsInstalledWechat.boolValue;
    weChatLogin.hidden = !isWXInstall;
    
    /****** *****/
    pri_btn = [[UIButton alloc]init];
    [self.view addSubview:pri_btn];
    pri_btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [pri_btn setTitle:@"登录即代表我同意用户 服务条款 及 隐私协议" forState:UIControlStateNormal];
    [pri_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pri_btn.clipsToBounds = YES;
    [pri_btn addTarget:self action:@selector(pri_btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [pri_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-24.5);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.height.mas_equalTo(15);
    }];
}

- (void)postPerform {
    [super postPerform];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Layouts
- (id)LandingSNSLayout:(UIView*)view {
    NSLog(@"Landing SNS View view layout");
    view.frame = CGRectMake(0, SCREEN_HEIGHT - 108 - 36 - 46, SCREEN_WIDTH, view.frame.size.height);
    return nil;
}

#pragma mark - actions
-(void)pri_btnDidClick {
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

- (void)didWeChatLoginBtnClick{
    id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
    id<AYCommand> cmd_login = [f.commands objectForKey:@"LoginSNSWithWechat"];
    [cmd_login performWithResult:nil];
}

#pragma mark -- status
- (void)setCurrentStatus:(RemoteControllerStatus)new_status {
    _landing_status = new_status;
    
    switch (_landing_status) {
        case RemoteControllerStatusReady: {
            phoneNoLogin.hidden = NO;
            weChatLogin.hidden = !isWXInstall;
            pri_btn.hidden = NO;
            [super endRemoteCall:nil];
            }
            break;
        case RemoteControllerStatusPrepare:
        case RemoteControllerStatusLoading: {
            phoneNoLogin.hidden = YES;
            weChatLogin.hidden = YES;
            pri_btn.hidden = YES;
            [super startRemoteCall:nil];
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
    self.landing_status = RemoteControllerStatusReady;
    int code = ((NSNumber*)args).intValue;
    if (code == -2) {
        
        NSString *title = @"授权失败";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
    } else {
        
        NSString *title = @"授权失败";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
    }
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

#pragma mark - 环信
- (id)WillStartLoginEM:(id)args {
	
	self.landing_status = RemoteControllerStatusLoading;
	return nil;
}

- (id)LoginEMSuccess:(id)args {
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
    self.landing_status = RemoteControllerStatusReady;
    
    UIViewController* controller = [Tools activityViewController];
    if (controller == self) {
        if ([[((NSDictionary*)args) objectForKey:@"user_id"] isEqualToString:[((NSDictionary*)obj) objectForKey:@"user_id"]]) {
            NSLog(@"finally login over success");
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *model = [defaults objectForKey:@"dongda_app_mode"];
            AYViewController* des;
            switch (model.intValue) {
                case DongDaAppModeUnLogin:
                case DongDaAppModeCommon:
                {
                    des = DEFAULTCONTROLLER(@"TabBar");
                }
                    break;
                case DongDaAppModeServant:
                {
                    des = DEFAULTCONTROLLER(@"TabBarService");
                }
                    break;
                default:
                    break;
            }
            
            NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
            [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
            [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
//            [dic_show_module setValue:[NSNumber numberWithInt:ModeExchangeTypeUnloginToAllModel] forKey:kAYControllerChangeArgsKey];
            
            NSMutableDictionary *dic_exchange = [[NSMutableDictionary alloc]init];
            [dic_exchange setValue:[NSNumber numberWithInteger:0] forKey:@"index"];
            [dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeUnloginToAllModel] forKey:@"type"];
            [dic_show_module setValue:dic_exchange forKey:kAYControllerChangeArgsKey];
            
            id<AYCommand> cmd_exchange = EXCHANGEWINDOWS;
            [cmd_exchange performWithResult:&dic_show_module];
            
        } else {
            NSLog(@"something wrong with login process");
            @throw [[NSException alloc]initWithName:@"error" reason:@"something wrong with login process" userInfo:nil];
        }
    }
    
    return nil;
}

- (id)LoginEMFaild:(id)args {
	self.landing_status = RemoteControllerStatusReady;
	
	AYFacade* f_login = LOGINMODEL;
	id<AYCommand> cmd_sign_out_local = [f_login.commands objectForKey:@"SignOutLocal"];
	[cmd_sign_out_local performWithResult:nil];
	
	return nil;
}

- (id)LoginSuccess {
    NSLog(@"Login Success  ->  to do login with EM server");
	
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
	
    AYFacade* xmpp = [self.facades objectForKey:@"EM"];
    id<AYCommand> cmd_login_xmpp = [xmpp.commands objectForKey:@"LoginEM"];
    NSDictionary* dic = (NSDictionary*)obj;
    NSString* current_user_id = [dic objectForKey:@"user_id"];
    [cmd_login_xmpp performWithResult:&current_user_id];
    
    return nil;
}

- (id)LogoutCurrentUser {
    NSLog(@"current user logout");
   
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
				BOOL is_reg = ((NSNumber*)[dic_info objectForKey:@"is_registered"]).boolValue;
                if (is_reg) {
					AYModel* m = MODEL;
					AYFacade* f = [m.facades objectForKey:@"LoginModel"];
					id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
					[cmd performWithResult:&dic_info];
                }
				else {
					AYViewController* des = DEFAULTCONTROLLER(@"Welcome");
					NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
					[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
					[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
					[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
					[dic_push setValue:[dic_info copy] forKey:kAYControllerChangeArgsKey];
					id<AYCommand> cmd = PUSH;
					[cmd performWithResult:&dic_push];
                }
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
	UIViewController* cv = [Tools activityViewController];
	if (cv == self) {
		[self LoginSuccess];
	}
    return nil;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
