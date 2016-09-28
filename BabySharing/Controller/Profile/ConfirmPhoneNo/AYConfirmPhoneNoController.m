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

@interface AYConfirmPhoneNoController () <UITextFieldDelegate>

@end

@implementation AYConfirmPhoneNoController {
    
    UITextField *phoneTextField;
    UITextField *coderTextField;
    
    NSString* reg_token;
    
    NSTimer* timer;
    NSInteger seconds;
    
    UITextField *coder_area;
    UITextField *inputPhoneNo;
    UILabel *count_timer;
    
    UIButton *getCodeBtn;
    UIButton *enterBtn;
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
    
    /* 电话号码 */
    UIView *confirmPhoneView = [UIView new];
    [self.view addSubview:confirmPhoneView];
    confirmPhoneView.backgroundColor = [UIColor clearColor];
    [confirmPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(90);
    }];
    
    inputPhoneNo = [[UITextField alloc]init];
    inputPhoneNo.delegate = self;
    inputPhoneNo.backgroundColor = [UIColor whiteColor];
    inputPhoneNo.font = [UIFont systemFontOfSize:14.f];
    inputPhoneNo.textColor = [Tools blackColor];
    inputPhoneNo.keyboardType = UIKeyboardTypeNumberPad;
    inputPhoneNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputPhoneNo.placeholder = @"输入手机号码";
    UIView *padingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 1)];
    inputPhoneNo.leftView = padingView;
    inputPhoneNo.leftViewMode = UITextFieldViewModeAlways;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:inputPhoneNo];
    [confirmPhoneView addSubview:inputPhoneNo];
    [inputPhoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPhoneView);
        make.left.equalTo(confirmPhoneView);
        make.right.equalTo(confirmPhoneView);
        make.height.mas_equalTo(40);
    }];
    
    /* 验证码 */
    UIView *inputCodeView = [[UIView alloc]init];
    [confirmPhoneView addSubview:inputCodeView];
    [inputCodeView setBackgroundColor:[UIColor whiteColor]];
    [inputCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(confirmPhoneView);
        make.left.equalTo(confirmPhoneView);
        make.right.equalTo(confirmPhoneView);
        make.height.mas_equalTo(40);
    }];

    coder_area = [[UITextField alloc]init];
    coder_area.backgroundColor = [UIColor clearColor];
    coder_area.font = [UIFont systemFontOfSize:14.f];
    coder_area.textColor = [Tools blackColor];
    //    coder_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    coder_area.keyboardType = UIKeyboardTypeNumberPad;
    coder_area.placeholder = @"输入动态密码";
    [inputCodeView addSubview:coder_area];
    [coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView);
        make.left.equalTo(inputCodeView).offset(15);
        make.right.equalTo(inputCodeView).offset(-150);
        make.height.equalTo(inputCodeView);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:coder_area];
    
    /* 重新获取coder */
    getCodeBtn = [[UIButton alloc]init];
    [getCodeBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[Tools garyColor] forState:UIControlStateDisabled];
    getCodeBtn.enabled = NO;
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [getCodeBtn addTarget:self action:@selector(getcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [inputCodeView addSubview:getCodeBtn];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputCodeView);
        make.centerY.equalTo(inputCodeView);
        make.size.mas_equalTo(CGSizeMake(110, 42));
    }];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(timerRun:)
                                           userInfo: nil
                                            repeats: YES];
    [timer setFireDate:[NSDate distantFuture]];
    
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

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    
    if ([inputPhoneNo isFirstResponder]) {
        [inputPhoneNo resignFirstResponder];
    }
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
}

- (void)didReqConfirmBtnClick:(UIButton*)btn {
    
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



#pragma mark -- ################

- (void)phoneTextFieldChanged:(NSNotification *)tf {
    
    if (tf.object == inputPhoneNo && inputPhoneNo.text.length == kPhoneNoLimit && ![inputPhoneNo.text isEqualToString:@""] && (seconds == TimeZore || seconds == 0)) {
        getCodeBtn.enabled = YES;
    }
    if (tf.object == inputPhoneNo && [inputPhoneNo.text isEqualToString:@""]) {
        getCodeBtn.enabled = NO;
    }
}

- (void)textFieldTextDidChange:(NSNotification*)tf {
    if (tf.object == coder_area ) {
        if ( coder_area.text.length == 4) {
            
        } else {
            [self hideEnterBtn];
            //            enterBtn.enabled = NO;
        }
    } else if (tf.object == inputPhoneNo) {
        
        if (inputPhoneNo.text.length >= kPhoneNoLimit) {
            if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
                id<AYViewBase> view_tip = VIEW(@"AlertTip", @"AlertTip");
                id<AYCommand> cmd_add = [view_tip.commands objectForKey:@"setAlertTipInfo:"];
                NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
                [args setValue:self forKey:@"super_view"];
                [args setValue:@"手机号码输入错误" forKey:@"title"];
                [args setValue:[NSNumber numberWithFloat:216.f] forKey:@"set_y"];
                [cmd_add performWithResult:&args];
                return;
            }
            if (![inputPhoneNo.text isEqualToString:@""] && (seconds == TimeZore || seconds == 0)) {
                getCodeBtn.enabled = YES;
            }
        } else getCodeBtn.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == inputPhoneNo && inputPhoneNo.text.length >= kPhoneNoLimit && ![string isEqualToString:@""]){
        return NO;
    } else {
        NSString *tmp = inputPhoneNo.text;
        if ((tmp.length == 3 || tmp.length == 8) && ![string isEqualToString:@""]) {
            tmp = [tmp stringByAppendingString:@" "];
            inputPhoneNo.text = tmp;
        }
        return YES;
    }
}

- (void)getcodeBtnClick {
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入了错误的电话号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    coder_area.text = @"";
    [self hideEnterBtn];
    
}

#pragma mark -- handle
- (id)startConfirmCodeTimer {
    getCodeBtn.enabled = NO;
    seconds = TimeZore;
    [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
    [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    [timer setFireDate:[NSDate distantPast]];
    
    id<AYViewBase> view_tip = VIEW(@"AlertTip", @"AlertTip");
    id<AYCommand> cmd_add = [view_tip.commands objectForKey:@"setAlertTipInfo:"];
    NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
    [args setValue:self.view forKey:@"super_view"];
    [args setValue:@"动态密码已发送" forKey:@"title"];
    [args setValue:[NSNumber numberWithFloat:SCREEN_HEIGHT * 0.5] forKey:@"set_y"];
    [cmd_add performWithResult:&args];
    
    return nil;
}

- (void)timerRun:(NSTimer*)sender {
    seconds--;
    if (seconds > 0) {
        [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
        
    } else {
        [timer setFireDate:[NSDate distantFuture]];
        [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [getCodeBtn setTitle:@"重获动态密码" forState:UIControlStateNormal];
        if (inputPhoneNo.text.length >= 10) {
            getCodeBtn.enabled = YES;
        }
    }
}

#pragma mark -- actions
-(void)hideEnterBtn{
    if (!enterBtn.hidden) {
        [UIView animateWithDuration:0 animations:^{
            enterBtn.alpha = 0;
        } completion:^(BOOL finished) {
            enterBtn.hidden = YES;
        }];
    }
}

@end
