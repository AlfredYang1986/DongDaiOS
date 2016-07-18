//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInputCoderController.h"
#import "AYViewBase.h"
#import "Tools.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "OBShapedButton.h"


#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height


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
    self.view.backgroundColor = [Tools themeColor];
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
//    id<AYViewBase> view = [self.views objectForKey:@"LandingInputCoder"];
//    id<AYCommand> cmd_view = [view.commands objectForKey:@"startConfirmCodeTimer"];
//    [cmd_view performWithResult:nil];
    
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
    view.backgroundColor = [Tools themeColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = PNGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"" forState:UIControlStateNormal];
    bar_right_btn.userInteractionEnabled = NO;
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 10.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;

    titleView.text = @"  ";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 64 / 2);
    return nil;
}

- (id)LandingInputCoderLayout:(UIView*)view {
    NSLog(@"Landing Input View view layout");
    CGFloat margin = 15.f;
    view.frame = CGRectMake(margin, 102, SCREEN_WIDTH - margin*2, 240);
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
    NSLog(@"setting view controller");
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
    
//    [self performForView:nil andFacade:@"LandingRemote" andMessage:@"LandingAuthConfirm" andArgs:[dic_auth copy]];
    AYFacade* f_auth = [self.facades objectForKey:@"LandingRemote"];
    AYRemoteCallCommand* cmd_auth = [f_auth.commands objectForKey:@"LandingAuthConfirm"];
    [cmd_auth performWithResult:[dic_auth copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        NSMutableDictionary* args = [result mutableCopy];
        NSString* msg = [result objectForKey:@"message"];
        
        id<AYCommand> inputName = DEFAULTCONTROLLER(@"InputName");
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:3];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic setValue:inputName forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:args forKey:kAYControllerChangeArgsKey];
        
        AYModel* m = MODEL;
        AYFacade* f = [m.facades objectForKey:@"LoginModel"];
        id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];
        [cmd performWithResult:&result];
        
        if (success || [msg isEqualToString:@"new user"]) {
            
            id<AYCommand> cmd_push = PUSH;
            [cmd_push performWithResult:&dic];
        }else if([msg isEqualToString:@"already login"]){
            
//            id<AYCommand> Welcome = DEFAULTCONTROLLER(@"Welcome");
//            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
//            [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//            [dic setValue:Welcome forKey:kAYControllerActionDestinationControllerKey];
//            [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//            [dic setValue:args forKey:kAYControllerChangeArgsKey];
//            
//            id<AYCommand> cmd_push = PUSH;
//            [cmd_push performWithResult:&dic];
            
            id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
            AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
            [cmd_profile performWithResult:[args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                NSLog(@"Update user detail remote result: %@", result);
                if (success) {
                    AYModel* m = MODEL;
                    AYFacade* f = [m.facades objectForKey:@"LoginModel"];
                    id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
                    [cmd performWithResult:&result];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，请检查网络是否正常连接" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
    }];
    
    return nil;
}

-(id)reReqConfirmCode:(id)args{
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
                id<AYViewBase> nav_bar = [self.views objectForKey:@"FakeNavBar"];
                id<AYCommand> fake_cmd = [nav_bar.commands objectForKey:@"setRightBtnWithBtn:"];
                UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
                [bar_right_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [bar_right_btn setTitle:@"下一步" forState:UIControlStateNormal];
                [bar_right_btn sizeToFit];
                bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
                [fake_cmd performWithResult:&bar_right_btn];
                
                id<AYCommand> hide_cmd = [input.commands objectForKey:@"hideEnterBtnForOldUser"];
                [hide_cmd performWithResult:nil];
            } else if (is_reg.intValue == 1) {
                id<AYViewBase> nav_bar = [self.views objectForKey:@"FakeNavBar"];
                id<AYCommand> fake_cmd = [nav_bar.commands objectForKey:@"setRightBtnWithBtn:"];
                UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 25, 25)];
                [bar_right_btn setTitle:@" " forState:UIControlStateNormal];
                bar_right_btn.userInteractionEnabled = NO;
                [fake_cmd performWithResult:&bar_right_btn];
                
                id<AYCommand> show_cmd = [input.commands objectForKey:@"showEnterBtnForOldUser"];
                [show_cmd performWithResult:nil];
            }
            
            
        }
    }];
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}

- (id)endRemoteCall:(id)obj {
    return nil;
}

-(id)queryCurPhoneNo:(NSString*)args{
    return _phoneNo;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (id)CurrentLoginUserChanged:(id)args {
    NSLog(@"Notify args: %@", args);
    //    NSLog(@"TODO: 进入咚哒");
   
//    [Tools activityViewController];
//    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
//    [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
//    [dic_pop setValue:[Tools activityViewController] forKey:kAYControllerActionSourceControllerKey];
//    
//    NSString* message_name = @"LoginSuccess";
//    [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd = POPTOROOT;
//    [cmd performWithResult:&dic_pop];
    
    return nil;
}

@end
