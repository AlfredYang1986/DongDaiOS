//
//  AYInputInvateCodeController.m
//  BabySharing
//
//  Created by Alfred Yang on 30/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYInputInvateCodeController.h"
#import "AYViewBase.h"
#import "Tools.h"
#import "AYFacade.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "OBShapedButton.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@interface AYInputInvateCodeController () <UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary* login_attr;

@end

@implementation AYInputInvateCodeController
@synthesize login_attr = _login_attr;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        NSLog(@"init args are : %@", _login_attr);
    }
}

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools themeColor];
    self.navigationController.navigationBar.tintColor = [Tools themeColor];
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
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
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 64);
    view.backgroundColor = [Tools themeColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = PNGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"下一步" forState:UIControlStateNormal];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 10.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"1/3";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 64 / 2);
    return nil;
}

- (id)InputInvateCodeLayout:(UIView*)view {
    NSLog(@"Landing Input View view layout");
    CGFloat margin = 22.f;
    view.frame = CGRectMake(margin, 102, SCREEN_WIDTH - margin*2, 130);
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputNo"];
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
    id<AYViewBase> view = [self.views objectForKey:@"InputInvateCode"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
    
    id<AYCommand> cmd_query_no = [view.commands objectForKey:@"queryInvateCode:"];
    NSString* code = nil;
    [cmd_query_no performWithResult:&code];
    
    if (![code isEqualToString:@"1111"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的邀请码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputCoder");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
    
//    NSMutableDictionary* dic_coder = [[NSMutableDictionary alloc]init];
//    
//    AYFacade* f = [self.facades objectForKey:@"LandingRemote"];
//    AYRemoteCallCommand* cmd_coder = [f.commands objectForKey:@"LandingReqConfirmCode"];
//    [cmd_coder performWithResult:[dic_coder copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//        if (success) {
//            NSLog(@"验证码已发送");
//            NSLog(@"%@",result);
//            AYModel* m = MODEL;
//            AYFacade* f = [m.facades objectForKey:@"LoginModel"];
//            id<AYCommand> cmd = [f.commands objectForKey:@"ChangeTmpUser"];
//            [cmd performWithResult:&result];
//            
//            id<AYCommand> setting = DEFAULTCONTROLLER(@"InputCoder");
//            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
//            [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//            [dic setValue:setting forKey:kAYControllerActionDestinationControllerKey];
//            [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//            [dic setValue:result forKey:kAYControllerChangeArgsKey];
//            
//            id<AYCommand> cmd_push = PUSH;
//            [cmd_push performWithResult:&dic];
//        }
//    }];
    
    return nil;
}

-(id)invateCode{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"GetInvateCode");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
    return nil;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
