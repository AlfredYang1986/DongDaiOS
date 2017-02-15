//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInputCoderController.h"
#import "AYViewBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "OBShapedButton.h"


@interface AYInputCoderController () <UINavigationControllerDelegate>
@property (nonatomic, strong) NSString* phoneNo;
@property (nonatomic, strong) NSString* reg_token;
@end

@implementation AYInputCoderController {
    BOOL isChangeImg;
    CGRect keyBoardFrame;
}

@synthesize phoneNo = _phoneNo;
@synthesize reg_token = _reg_token;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;

    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* argsValue = (NSDictionary*)[dic objectForKey:kAYControllerChangeArgsKey];
        _phoneNo = [argsValue objectForKey:@"phoneNo"];
        _reg_token = [argsValue objectForKey:@"reg_token"];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools whiteColor];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- views layouts
- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
//    view.backgroundColor = [Tools themeColor];
//	NSString *title = @"确认信息";
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)LandingInputCoderLayout:(UIView*)view {
    CGFloat margin = 25.f;
    view.frame = CGRectMake(margin, 83, SCREEN_WIDTH - margin*2, 320);
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputCoder"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
}

- (id)beginEditTextFiled {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [self performWithResult:&dic];
    return nil;
}

- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputCoder"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
    
    id<AYViewBase> coder_view = [self.views objectForKey:@"LandingInputCoder"];
    id<AYCommand> cmd_coder = [coder_view.commands objectForKey:@"queryCurCoder:"];
    NSString* input_coder = nil;
    [cmd_coder performWithResult:&input_coder];
    
    NSMutableDictionary* dic_auth = [[NSMutableDictionary alloc]init];
    [dic_auth setValue:self.phoneNo forKey:@"phoneNo"];
    [dic_auth setValue:self.reg_token forKey:@"reg_token"];
    [dic_auth setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic_auth setValue:input_coder forKey:@"code"];
   
    
    AYFacade* f_auth = [self.facades objectForKey:@"LandingRemote"];
    AYRemoteCallCommand* cmd_auth = [f_auth.commands objectForKey:@"AuthPhoneCode"];
    [cmd_auth performWithResult:[dic_auth copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
           
            NSDictionary* args = [result copy];
            
            AYModel* m = MODEL;
            AYFacade* f = [m.facades objectForKey:@"LoginModel"];
            id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];
            [cmd performWithResult:&result];
           
            NSString* screen_name = [args objectForKey:@"screen_name"];
            if ([screen_name isEqualToString:@""]) {
                id<AYCommand> inputName = DEFAULTCONTROLLER(@"InputName");
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:3];
                [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
                [dic setValue:inputName forKey:kAYControllerActionDestinationControllerKey];
                [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
                [dic setValue:args forKey:kAYControllerChangeArgsKey];
                id<AYCommand> cmd_push = PUSH;
                [cmd_push performWithResult:&dic];

            } else {
                AYModel* m = MODEL;
                AYFacade* f = [m.facades objectForKey:@"LoginModel"];
                id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
                [cmd performWithResult:&args];
            }
            
        } else {
            NSString* msg = [result objectForKey:@"message"];
            if([msg isEqualToString:@"inputing validation code is not valid or not match to this phone number"]) {
                NSString *title = @"动态密码错误,请重试";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            } else {
                NSString *title = @"验证动态密码失败，请检查网络是否正常连接";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }
    }];
    return nil;
}

-(id)reReqConfirmCode:(id)args {
    NSDictionary *args_dic = (NSDictionary*)args;
    _phoneNo = [args_dic objectForKey:@"phoneNo"];
    
    NSMutableDictionary* dic_coder = [[NSMutableDictionary alloc]init];
    [dic_coder setValue:[args_dic objectForKey:@"phoneNo"] forKey:@"phoneNo"];
    
    AYFacade* f = [self.facades objectForKey:@"LandingRemote"];
    AYRemoteCallCommand* cmd_coder = [f.commands objectForKey:@"LandingReqConfirmCode"];
    [cmd_coder performWithResult:[dic_coder copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            NSLog(@"验证码已发送");//is_reg
            AYModel* m = MODEL;
            AYFacade* f = [m.facades objectForKey:@"LoginModel"];
            id<AYCommand> cmd = [f.commands objectForKey:@"ChangeTmpUser"];
            [cmd performWithResult:&result];
            _reg_token = [result objectForKey:@"reg_token"];
            
            id<AYViewBase> coder_view = [self.views objectForKey:@"LandingInputCoder"];
            id<AYCommand> cmd_coder = [coder_view.commands objectForKey:@"startConfirmCodeTimer"];
            [cmd_coder performWithResult:nil];
            
            id<AYViewBase> input = [self.views objectForKey:@"LandingInputCoder"];
            NSNumber *is_reg = [result objectForKey:@"is_reg"];
            if (is_reg.intValue == 0) {
				
                id<AYCommand> hide_cmd = [input.commands objectForKey:@"showNextBtnForNewUser"];
                [hide_cmd performWithResult:nil];
                
            } else if (is_reg.intValue == 1) {
				
                id<AYCommand> show_cmd = [input.commands objectForKey:@"showEnterBtnForOldUser"];
                [show_cmd performWithResult:nil];
            }
        }
    }];
    return nil;
}

-(id)queryCurPhoneNo:(NSString*)args {
    return _phoneNo;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (id)CurrentLoginUserChanged:(id)args {
    NSLog(@"Notify args: %@", args);
    //    NSLog(@"TODO: 进入咚哒");
   
    UIViewController* cv = [Tools activityViewController];
    if (cv == self) {
        NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
        [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
        [dic_pop setValue:[Tools activityViewController] forKey:kAYControllerActionSourceControllerKey];
        
        NSString* message_name = @"LoginSuccess";
        [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POPTOROOT;
        [cmd performWithResult:&dic_pop];
    }
    
    return nil;
}

@end
