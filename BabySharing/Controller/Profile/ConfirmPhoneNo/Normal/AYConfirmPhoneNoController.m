//
//  AYConfirmPhoneNoController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmPhoneNoController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYModel.h"

#define TEXT_FIELD_LEFT_PADDING             10
#define TimeZore                            5
#define kPhoneNoLimit                       13

@interface AYConfirmPhoneNoController () //<UITextFieldDelegate>

@end

@implementation AYConfirmPhoneNoController {
    NSString* reg_token;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *title = [[UILabel alloc]init];
    title = [Tools setLabelWith:title andText:@"首先,我们需要通过手机验证" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel = [Tools setLabelWith:descLabel andText:@"手机验证让您可以及时和每一位妈妈沟通" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
    descLabel.numberOfLines = 2;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(15);
        make.centerX.equalTo(title);
    }];
   
    UIView* view = [self.views objectForKey:@"PhoneCheckInput"];
    view.backgroundColor = [UIColor clearColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(90);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor clearColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"下一步" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)PhoneCheckInputLayout:(UIView*)view {
    return nil;
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
    id<AYCommand> cmd = [view.commands objectForKey:@"resignFocus"];
    [cmd performWithResult:nil];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {

    NSString* tmp = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryPhoneInput:"];
        [cmd performWithResult:&tmp];
    }
    
    NSString* code = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryPhoneInput:"];
        [cmd performWithResult:&code];
    }
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"CheckCode"];
    
    NSMutableDictionary *dic_check = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic_check setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_check setValue:reg_token forKey:@"reg_token"];
    [dic_check setValue:code forKey:@"code"];
    [dic_check setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic_check setValue:tmp forKey:@"phoneNo"];
    
    [cmd performWithResult:[dic_check copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            AYViewController* des = DEFAULTCONTROLLER(@"ConfirmRealName");
            NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
            [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
            [dic_push setValue:[NSNumber numberWithInt:0] forKey:kAYControllerChangeArgsKey];
            
            id<AYCommand> cmd = PUSH;
            [cmd performWithResult:&dic_push];
            
        } else {
            kAYUIAlertView(@"错误", @"请检查验证码并重试");
        }
    }];
    return nil;
}

#pragma mark -- actions
- (id)requeryForCode {
    
    NSString* tmp = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryPhoneInput:"];
        [cmd performWithResult:&tmp];
    }
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"RequireCode"];
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic_push setValue:tmp forKey:@"phoneNo"];
    
    [cmd performWithResult:[dic_push copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            reg_token = [result objectForKey:@"reg_token"];

            id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
            
            {
                id<AYCommand> cmd = [view.commands objectForKey:@"startTimer"];
                [cmd performWithResult:nil];
            }
            
            {
                id<AYCommand> cmd = [view.commands objectForKey:@"setCodeBtnTitle"];
                [cmd performWithResult:nil];
            }
            
            id<AYViewBase> view_tip = VIEW(@"AlertTip", @"AlertTip");
            id<AYCommand> cmd_add = [view_tip.commands objectForKey:@"setAlertTipInfo:"];
            NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
            [args setValue:self.view forKey:@"super_view"];
            [args setValue:@"动态密码已发送" forKey:@"title"];
            [args setValue:[NSNumber numberWithFloat:SCREEN_HEIGHT * 0.5] forKey:@"set_y"];
            [cmd_add performWithResult:&args];
            
        } else {
            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"网络错误，请重新获取" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
    
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"resetCodeInput"];
        [cmd performWithResult:nil];
    }

    return nil;
}
@end