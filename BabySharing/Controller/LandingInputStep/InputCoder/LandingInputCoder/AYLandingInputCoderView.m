//
//  AYLandingInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingInputCoderView.h"
#import "AYCommandDefines.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYControllerBase.h"
#import "AYFacadeBase.h"
#import "Tools.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYFactoryManager.h"
#import "AYAlertView.h"

#define TEXT_FIELD_LEFT_PADDING             10
#define TimeZore                            5
#define kPhoneNoLimit                       13

@implementation AYLandingInputCoderView {
    
    NSTimer* timer;
    NSInteger seconds;
    UIButton* clear_btn;
    
    /**/
    UILabel *inputArea;
    

    UIView *inputCodeView;
    
    UITextField *coder_area;
    UITextField *inputPhoneNo;
    UILabel *count_timer;
    
    UIButton *getCodeBtn;
    UIButton *enterBtn;
    
//    AYAlertView *alertView;
    BOOL isNewUser;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    UILabel *tips = [[UILabel alloc]init];
    tips = [Tools setLabelWith:tips andText:@"您的手机号码？" andTextColor:[UIColor colorWithWhite:1.f alpha:0.95f] andFontSize:24.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
//    UIView *countryAreaView = [[UIView alloc]init];
//    [self addSubview:countryAreaView];
//    [countryAreaView setBackgroundColor:[Tools colorWithRED:238.f GREEN:251.f BLUE:250.f ALPHA:1.f]];
//    countryAreaView.layer.cornerRadius = 2.f;
//    countryAreaView.clipsToBounds = YES;
//    [countryAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(input_tips.mas_bottom).offset(15);
//        make.left.equalTo(self);
//        make.width.equalTo(self);
//        make.height.mas_equalTo(40);
//    }];
//
//    UILabel *area = [[UILabel alloc]init];
//    area.backgroundColor = [Tools colorWithRED:220.f GREEN:247.f BLUE:244.f ALPHA:1.f];
//    area.text = @"国家/地区";
//    area.font = [UIFont systemFontOfSize:14.f];
//    area.textColor = [Tools themeColor];
//    area.textAlignment = NSTextAlignmentCenter;
//    [countryAreaView addSubview:area];
//    [area mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(countryAreaView);
//        make.left.equalTo(countryAreaView);
//        make.size.mas_equalTo(CGSizeMake(96, 40));
//    }];
//
//    inputArea = [[UILabel alloc]init];
//    inputArea.text = @"中国";
//    inputArea.font = [UIFont systemFontOfSize:14.f];
//    inputArea.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
//    [countryAreaView addSubview:inputArea];
//    [inputArea mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(countryAreaView);
//        make.left.equalTo(area.mas_right).offset(10);
//        make.height.equalTo(countryAreaView);
//    }];
//    
//    UIButton *areaBtn = [[UIButton alloc]init];
//    [areaBtn setImage:[UIImage imageNamed:@"landing_input_triangle"] forState:UIControlStateNormal];
//    [areaBtn addTarget:self action:@selector(areaBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [countryAreaView addSubview:areaBtn];
//    [areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(countryAreaView.mas_right).offset(-5);
//        make.centerY.equalTo(countryAreaView);
//        make.size.mas_equalTo(CGSizeMake(38, 38));
//    }];
    
    /* 电话号码 */
    UIView *inputPhoneNoView = [[UIView alloc]init];
    [self addSubview:inputPhoneNoView];
    [inputPhoneNoView setBackgroundColor:[UIColor whiteColor]];
//    inputPhoneNoView.layer.cornerRadius = 2.f;
//    inputPhoneNoView.clipsToBounds = YES;
    [inputPhoneNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).offset(32);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(42);
    }];
    
    CALayer *rule_layer = [CALayer layer];
    rule_layer.frame = CGRectMake(61, 13, 1, 14);
    rule_layer.backgroundColor = [Tools garyLineColor].CGColor;
    [inputPhoneNoView.layer addSublayer:rule_layer];
    
    UILabel *phoneNo = [[UILabel alloc]init];
    phoneNo = [Tools setLabelWith:phoneNo andText:@"+ 86" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [inputPhoneNoView addSubview:phoneNo];
    [phoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPhoneNoView);
        make.left.equalTo(inputPhoneNoView);
        make.size.mas_equalTo(CGSizeMake(60, 42));
    }];

    inputPhoneNo = [[UITextField alloc]init];
    inputPhoneNo.delegate = self;
    inputPhoneNo.backgroundColor = [UIColor clearColor];
    inputPhoneNo.font = [UIFont systemFontOfSize:14.f];
    inputPhoneNo.textColor = [Tools blackColor];
    inputPhoneNo.keyboardType = UIKeyboardTypeNumberPad;
    inputPhoneNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputPhoneNo.placeholder = @"输入手机号码";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:inputPhoneNo];
    [inputPhoneNoView addSubview:inputPhoneNo];
    [inputPhoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputPhoneNoView);
        make.top.equalTo(inputPhoneNoView);
        make.left.equalTo(phoneNo.mas_right).offset(16);
        make.height.equalTo(inputPhoneNoView);
    }];
    
    /* 验证码 */
    inputCodeView = [[UIView alloc]init];
    [self addSubview:inputCodeView];
    [inputCodeView setBackgroundColor:[UIColor whiteColor]];
    [inputCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPhoneNoView.mas_bottom).offset(16);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(42);
    }];
    
    coder_area = [[UITextField alloc]init];
    coder_area.backgroundColor = [UIColor clearColor];
    coder_area.font = [UIFont systemFontOfSize:14.f];
    coder_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
//    coder_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    coder_area.keyboardType = UIKeyboardTypeNumberPad;
    coder_area.placeholder = @"输入动态密码";
    [inputCodeView addSubview:coder_area];
    [coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputCodeView).offset(-150);
        make.top.equalTo(inputCodeView);
        make.left.equalTo(inputCodeView).offset(15);
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
    getCodeBtn.layer.cornerRadius = 2.f;
    getCodeBtn.clipsToBounds = YES;
    [getCodeBtn addTarget:self action:@selector(getcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [inputCodeView addSubview:getCodeBtn];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(inputCodeView);
        make.size.mas_equalTo(CGSizeMake(110, 42));
    }];
    
    
    enterBtn = [[UIButton alloc]init];
    [enterBtn setBackgroundColor:[UIColor clearColor]];
    [enterBtn setImage:[UIImage imageNamed:@"enter_selected"] forState:UIControlStateNormal];
    [enterBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateDisabled];
//    enterBtn.enabled = NO;
    enterBtn.hidden = YES;
    enterBtn.alpha = 0;
    [enterBtn addTarget:self action:@selector(requestCoder:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView.mas_bottom).offset(100);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(115, 40));
    }];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(timerRun:)
                                           userInfo: nil
                                            repeats: YES];
    [timer setFireDate:[NSDate distantFuture]];
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)requestCoder:(UIButton*)sender{
    id<AYCommand> cmd = [self.notifies objectForKey:@"rightBtnSelected"];
    [cmd performWithResult:nil];
}

- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:nil andMessage:@"LandingAreaCode" andArgs:nil];
}

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
            [self showEnterBtn];
//            enterBtn.enabled = YES;
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

-(void)areaBtnClick{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"目前只支持中国地区电话号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (void)getcodeBtnClick {
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入了错误的电话号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    coder_area.text = @"";
    [self hideEnterBtn];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *tmp = inputPhoneNo.text;
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic setValue:tmp forKey:@"phoneNo"];
    id<AYCommand> cmd = [self.notifies objectForKey:@"reReqConfirmCode:"];
    [cmd performWithResult:&dic];
}

#pragma mark -- handle
- (id)startConfirmCodeTimer {
    getCodeBtn.enabled = NO;
    seconds = TimeZore;
    [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
    [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    [timer setFireDate:[NSDate distantPast]];
    
    [self showAYAlertViewWithTitle:@"动态密码已发送"];
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
- (void)showAYAlertViewWithTitle:(NSString*)title {
    AYAlertView *alertView = [[AYAlertView alloc]initWithTitle:title andTitleColor:nil];
    [self addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView.mas_bottom).offset(60);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(alertView.titleSize.width+60, 40));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.f animations:^{
            alertView.alpha = 0;
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    });
}

-(void)hideEnterBtn{
    if (!enterBtn.hidden) {
        [UIView animateWithDuration:0 animations:^{
            enterBtn.alpha = 0;
        } completion:^(BOOL finished) {
            enterBtn.hidden = YES;
        }];
    }
}
-(void)showEnterBtn{
    if (enterBtn.hidden && !isNewUser) {
        enterBtn.hidden = NO;
        [UIView animateWithDuration:0 animations:^{
            enterBtn.alpha = 1;
        }];
    }
}
#pragma mark -- view commands
- (id)showAYAlertVeiw:(NSString*)args {
    [self showAYAlertViewWithTitle:args];
    return nil;
}

- (id)hideKeyboard {
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
    if ([inputPhoneNo isFirstResponder]) {
        [inputPhoneNo resignFirstResponder];
    }
    return nil;
}

-(id)showEnterBtnForOldUser{
    isNewUser = NO;
    return nil;
}

-(id)hideEnterBtnForNewUser{
    isNewUser = YES;
    return nil;
}

-(id)queryCurCoder:(NSString*)args{
    return coder_area.text;
}

@end
