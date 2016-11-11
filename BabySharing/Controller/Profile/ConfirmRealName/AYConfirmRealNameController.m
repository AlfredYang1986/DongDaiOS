//
//  AYConfirmRealNameController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmRealNameController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"


@interface AYConfirmRealNameController ()

@end

@implementation AYConfirmRealNameController{
    UITextField *nameTextField;
    UITextField *coderTextField;
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
    
    UILabel *title = [[UILabel alloc]init];
    title = [Tools setLabelWith:title andText:@"还差一步，实名认证" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel = [Tools setLabelWith:descLabel andText:@"实名信息认证,为您的服务提高可信度" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    descLabel.numberOfLines = 2;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(20);
        make.centerX.equalTo(title);
    }];
    
    nameTextField = [[UITextField alloc]init];
    nameTextField.placeholder = @"真实姓名";
    nameTextField.font = [UIFont systemFontOfSize:14.f];
    nameTextField.textColor = [Tools blackColor];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.backgroundColor = [Tools whiteColor];
    UIView *paddingView = [[UIView alloc]init];
    paddingView.bounds = CGRectMake(0, 0, 10, 1);
    nameTextField.leftView = paddingView;
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
    }];
    
    coderTextField = [[UITextField alloc]init];
    coderTextField.placeholder = @"身份证号";
    coderTextField.font = [UIFont systemFontOfSize:14.f];
    coderTextField.textColor = [Tools blackColor];
    coderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    coderTextField.backgroundColor = [Tools whiteColor];
    UIView *paddingView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 1)];
    coderTextField.leftView = paddingView2;
    coderTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:coderTextField];
    [coderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(10);
        make.centerX.equalTo(nameTextField);
        make.size.equalTo(nameTextField);
    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
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
    
    UIButton *bar_right_btn = [Tools creatUIButtonWithTitle:@"提交" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
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
    
    if ([nameTextField.text isEqualToString:@""] || [coderTextField.text isEqualToString:@""]) {
        NSString *title = @"请完善个人信息！";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"PushRealName"];
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_push setValue:nameTextField.text forKey:@"real_name"];
    [dic_push setValue:coderTextField.text forKey:@"social_id"];
    
    [cmd performWithResult:dic_push andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            /**
             *  save to coredata
             */
            id<AYFacadeBase> facade = LOGINMODEL;
            id<AYCommand> cmd_profle = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:tmp forKey:@"contact_no"];
            [dic setValue:[NSNumber numberWithInt:1] forKey:@"is_real_name_cert"];
            
            [cmd_profle performWithResult:&dic];
            
            /**
             *  go on
             */
            AYViewController* des = DEFAULTCONTROLLER(@"ConfirmFinish");
            NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
            [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
            
            NSString *tip = @"您的信息已成功提交";
            [dic_push setValue:tip forKey:kAYControllerChangeArgsKey];
            
            id<AYCommand> cmd = PUSH;
            [cmd performWithResult:&dic_push];
        }
        
    }];
    
    return nil;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    
    if ([nameTextField isFirstResponder]) {
        [nameTextField resignFirstResponder];
    }
    if ([coderTextField isFirstResponder]) {
        [coderTextField resignFirstResponder];
    }
}

@end
