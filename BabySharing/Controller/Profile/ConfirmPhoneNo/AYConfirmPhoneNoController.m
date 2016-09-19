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


@interface AYConfirmPhoneNoController ()

@end

@implementation AYConfirmPhoneNoController {
    NSMutableArray *loading_status;
    
    UITextField *phoneTextField;
    UITextField *coderTextField;
    
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *title = [[UILabel alloc]init];
    title = [Tools setLabelWith:title andText:@"确认电话号码" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(160);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel = [Tools setLabelWith:descLabel andText:@"请输入您的电话号码\n进行二次安全认证" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
    descLabel.numberOfLines = 2;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(20);
        make.centerX.equalTo(title);
    }];
    
    UIView *phoneView = [[UIView alloc]init];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    UILabel *realName = [[UILabel alloc]init];
    realName = [Tools setLabelWith:realName andText:@"手机号码" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [phoneView addSubview:realName];
    [realName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView);
        make.left.equalTo(phoneView).offset(10);
    }];
    UIButton *reqConfirmBtn = [[UIButton alloc]init];
    [reqConfirmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [reqConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reqConfirmBtn setBackgroundColor:[Tools themeColor]];
    reqConfirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [reqConfirmBtn addTarget:self action:@selector(didReqConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:reqConfirmBtn];
    [reqConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView);
        make.right.equalTo(phoneView);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];
    
    phoneTextField = [[UITextField alloc]init];
    phoneTextField.placeholder = @"请输入手机号码";
    phoneTextField.font = [UIFont systemFontOfSize:14.f];
    phoneTextField.textColor = [Tools blackColor];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneView addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView);
        make.left.equalTo(phoneView).offset(100);
        make.right.equalTo(reqConfirmBtn.mas_left).offset(-5);
    }];
    
    
    UIView *coderView = [[UIView alloc]init];
    coderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:coderView];
    [coderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(20);
        make.centerX.equalTo(phoneView);
        make.size.equalTo(phoneView);
    }];
    UILabel *coder = [[UILabel alloc]init];
    coder = [Tools setLabelWith:coder andText:@"验证码" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [coderView addSubview:coder];
    [coder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(coderView);
        make.left.equalTo(coderView).offset(10);
    }];
    coderTextField = [[UITextField alloc]init];
    coderTextField.placeholder = @"请输入验证码";
    coderTextField.font = [UIFont systemFontOfSize:14.f];
    coderTextField.textColor = [Tools blackColor];
    coderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [coderView addSubview:coderTextField];
    [coderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(coderView);
        make.left.equalTo(coderView).offset(100);
        make.right.equalTo(coderView).offset(-5);
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
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"完成" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 44 - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"验证您的身份";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
    if ([phoneTextField isFirstResponder]) {
        [phoneTextField resignFirstResponder];
    }
    if ([coderTextField isFirstResponder]) {
        [coderTextField resignFirstResponder];
    }
}

-(void)didReqConfirmBtnClick:(UIButton*)btn{
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{9}$"] evaluateWithObject:phoneTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入了错误的电话号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary* dic_coder = [[NSMutableDictionary alloc]init];
    [dic_coder setValue:phoneTextField.text forKey:@"phoneNo"];
    AYFacade* f = [self.facades objectForKey:@"LandingRemote"];
    AYRemoteCallCommand* cmd_coder = [f.commands objectForKey:@"LandingReqConfirmCode"];
    [cmd_coder performWithResult:dic_coder andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            AYModel* m = MODEL;
            AYFacade* f = [m.facades objectForKey:@"LoginModel"];
            id<AYCommand> cmd = [f.commands objectForKey:@"ChangeTmpUser"];
            [cmd performWithResult:&result];
            reg_token = [result objectForKey:@"reg_token"];
            
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码已发送，请稍等$.$" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"网络错误，请重新获取" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
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
    if (![phoneTextField.text isEqualToString:@""] && ![coderTextField.text isEqualToString:@""]) {
        NSMutableDictionary* dic_auth = [[NSMutableDictionary alloc]init];
        [dic_auth setValue:phoneTextField.text forKey:@"phoneNo"];
        [dic_auth setValue:reg_token forKey:@"reg_token"];
        [dic_auth setValue:[Tools getDeviceUUID] forKey:@"uuid"];
        [dic_auth setValue:coderTextField.text forKey:@"code"];
        
        AYFacade* f_auth = [self.facades objectForKey:@"LandingRemote"];
        AYRemoteCallCommand* cmd_auth = [f_auth.commands objectForKey:@"LandingAuthConfirm"];
        [cmd_auth performWithResult:[dic_auth copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的手机号码已成功验证 Y＊_＊Y" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            } else
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码错误！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }];
        
    } else [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号码或验证码！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    return nil;
}

@end
