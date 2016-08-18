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

#define TEXT_FIELD_LEFT_PADDING             10
#define TimeZore                            30

@implementation AYLandingInputCoderView {
    
    NSTimer* timer;
    NSInteger seconds;
    UIButton* clear_btn;
    
    /**/
    UILabel *input_tips;
    UILabel *inputArea;
    
    UIView *inputPhoneNoView;
    UIView *inputCodeView;
    
    UITextField *coder_area;
    UITextField *inputPhoneNo;
    UILabel *count_timer;
    
    UIButton *getCodeBtn;
    UIButton *enterBtn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
//    seconds = TimeZore;
    input_tips = [[UILabel alloc]init];
    input_tips.font = [UIFont systemFontOfSize:15.f];
    input_tips.textColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.f];
    input_tips.text = @"输入你的手机号码";
    input_tips.textAlignment = NSTextAlignmentLeft;
    [self addSubview:input_tips];
    [input_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    
    UIView *countryAreaView = [[UIView alloc]init];
    [self addSubview:countryAreaView];
    [countryAreaView setBackgroundColor:[Tools colorWithRED:238.f GREEN:251.f BLUE:250.f ALPHA:1.f]];
    countryAreaView.layer.cornerRadius = 2.f;
    countryAreaView.clipsToBounds = YES;
    [countryAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input_tips.mas_bottom).offset(15);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];

    UILabel *area = [[UILabel alloc]init];
    area.backgroundColor = [Tools colorWithRED:220.f GREEN:247.f BLUE:244.f ALPHA:1.f];
    area.text = @"国家/地区";
    area.font = [UIFont systemFontOfSize:14.f];
    area.textColor = [Tools themeColor];
    area.textAlignment = NSTextAlignmentCenter;
    [countryAreaView addSubview:area];
    [area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countryAreaView);
        make.left.equalTo(countryAreaView);
        make.size.mas_equalTo(CGSizeMake(96, 40));
    }];

    inputArea = [[UILabel alloc]init];
    inputArea.text = @"中国";
    inputArea.font = [UIFont systemFontOfSize:14.f];
    inputArea.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    [countryAreaView addSubview:inputArea];
    [inputArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countryAreaView);
        make.left.equalTo(area.mas_right).offset(10);
        make.height.equalTo(countryAreaView);
    }];
    
    UIButton *areaBtn = [[UIButton alloc]init];
    [areaBtn setImage:[UIImage imageNamed:@"landing_input_triangle"] forState:UIControlStateNormal];
    [areaBtn addTarget:self action:@selector(areaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [countryAreaView addSubview:areaBtn];
    [areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countryAreaView.mas_right).offset(-5);
        make.centerY.equalTo(countryAreaView);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    /* 电话号码 */
    inputPhoneNoView = [[UIView alloc]init];
    [self addSubview:inputPhoneNoView];
    [inputPhoneNoView setBackgroundColor:[Tools colorWithRED:238.f GREEN:251.f BLUE:250.f ALPHA:1.f]];
    inputPhoneNoView.layer.cornerRadius = 2.f;
    inputPhoneNoView.clipsToBounds = YES;
    [inputPhoneNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countryAreaView.mas_bottom).offset(12);
        make.left.equalTo(input_tips);
        make.right.equalTo(self).offset(-110);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *phoneNo = [[UILabel alloc]init];
    phoneNo.backgroundColor = [Tools colorWithRED:220.f GREEN:247.f BLUE:244.f ALPHA:1.f];
    phoneNo.text = @"电话号码";
    phoneNo.font = [UIFont systemFontOfSize:14.f];
    phoneNo.textColor = [Tools themeColor];
    phoneNo.textAlignment = NSTextAlignmentCenter;
    [inputPhoneNoView addSubview:phoneNo];
    [phoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPhoneNoView);
        make.left.equalTo(inputPhoneNoView);
        make.size.mas_equalTo(CGSizeMake(96, 40));
    }];

    inputPhoneNo = [[UITextField alloc]init];
    inputPhoneNo.delegate = self;
    inputPhoneNo.backgroundColor = [UIColor clearColor];
    inputPhoneNo.font = [UIFont systemFontOfSize:14.f];
    inputPhoneNo.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];

    inputPhoneNo.keyboardType = UIKeyboardTypeNumberPad;
    inputPhoneNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:inputPhoneNo];

    [inputPhoneNoView addSubview:inputPhoneNo];
    [inputPhoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputPhoneNoView);
        make.top.equalTo(inputPhoneNoView);
        make.left.equalTo(phoneNo.mas_right).offset(10);
        make.height.equalTo(inputPhoneNoView);
    }];
    
    getCodeBtn = [[UIButton alloc]init];
    [getCodeBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
    
    [getCodeBtn setTitleColor:[Tools colorWithRED:155.f GREEN:155.f BLUE:155.f ALPHA:1.f] forState:UIControlStateDisabled];
    [getCodeBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    getCodeBtn.enabled = NO;
    
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    getCodeBtn.backgroundColor = [Tools colorWithRED:220.f GREEN:247.f BLUE:244.f ALPHA:1.f];
    getCodeBtn.layer.cornerRadius = 2.f;
    getCodeBtn.clipsToBounds = YES;
    [getCodeBtn addTarget:self action:@selector(getcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:getCodeBtn];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(inputPhoneNoView);
        make.size.mas_equalTo(CGSizeMake(95, 40));
    }];
    
    
    /* 验证码 */
    inputCodeView = [[UIView alloc]init];
    [self addSubview:inputCodeView];
    [inputCodeView setBackgroundColor:[Tools colorWithRED:238.f GREEN:251.f BLUE:250.f ALPHA:1.f]];
    inputCodeView.layer.cornerRadius = 2.f;
    inputCodeView.clipsToBounds = YES;
    [inputCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPhoneNoView.mas_bottom).offset(12);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *confirmCode = [[UILabel alloc]init];
    confirmCode.backgroundColor = [Tools colorWithRED:220.f GREEN:247.f BLUE:244.f ALPHA:1.f];
    confirmCode.text = @"动态密码";
    confirmCode.font = [UIFont systemFontOfSize:14.f];
    confirmCode.textColor = [Tools themeColor];
    confirmCode.textAlignment = NSTextAlignmentCenter;
    [inputCodeView addSubview:confirmCode];
    [confirmCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView);
        make.left.equalTo(inputCodeView);
        make.size.mas_equalTo(CGSizeMake(96, 40));
    }];
    
    coder_area = [[UITextField alloc]init];
    coder_area.backgroundColor = [UIColor clearColor];
    coder_area.font = [UIFont systemFontOfSize:14.f];
    coder_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    coder_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    coder_area.keyboardType = UIKeyboardTypeNumberPad;

    [inputCodeView addSubview:coder_area];
    [coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputCodeView);
        make.top.equalTo(inputCodeView);
        make.left.equalTo(confirmCode.mas_right).offset(10);
        make.height.equalTo(inputCodeView);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coderTextFieldChange:) name:UITextFieldTextDidChangeNotification object:coder_area];
//    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, coder_area.frame.size.height)];
//    clear_btn.center = CGPointMake(coder_area.frame.size.width - 25 / 2, coder_area.frame.size.height / 2);
//    [coder_area addSubview:clear_btn];
    
    /* 重新获取coder */
    enterBtn = [[UIButton alloc]init];
    [enterBtn setBackgroundColor:[UIColor clearColor]];
    [enterBtn setImage:[UIImage imageNamed:@"enter_selected"] forState:UIControlStateNormal];
    [enterBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateDisabled];
    enterBtn.enabled = NO;
    enterBtn.hidden = YES;
    enterBtn.alpha = 0;
//    enterBtn.backgroundColor = [UIColor blackColor];
    [enterBtn addTarget:self action:@selector(requestCoder:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView.mas_bottom).offset(18);
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
//    seconds = TimeZore;
//    [timer setFireDate:[NSDate distantPast]];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:inputPhoneNo.text forKey:@"phoneNo"];
//    
//    id<AYCommand> cmd = [self.notifies objectForKey:@"reReqConfirmCode:"];
//    [cmd performWithResult:&dic];
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"rightBtnSelected"];
    [cmd performWithResult:nil];
}

- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:nil andMessage:@"LandingAreaCode" andArgs:nil];
}

- (void)phoneTextFieldChanged:(NSNotification *)tf {

    if (tf.object == inputPhoneNo && inputPhoneNo.text.length == 11 && ![inputPhoneNo.text isEqualToString:@""] && (seconds == TimeZore || seconds == 0)) {
        getCodeBtn.enabled = YES;
    }
    if (tf.object == inputPhoneNo && [inputPhoneNo.text isEqualToString:@""]) {
        getCodeBtn.enabled = NO;
    }
}

- (void)coderTextFieldChange:(NSNotification*)tf{
    if (tf.object == coder_area && coder_area.text.length >= 3) {
        enterBtn.enabled = YES;
    }
    if (tf.object == coder_area && coder_area.text.length < 4) {
        enterBtn.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == inputPhoneNo && inputPhoneNo.text.length >= 11 && ![string isEqualToString:@""]){
        return NO;
    }
    else{
        
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    clear_btn.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (seconds > 0) {
        
    }
//    clear_btn.hidden = YES;
}

-(void)areaBtnClick{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"目前只支持中国地区电话号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

-(void)getcodeBtnClick{
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{9}$"] evaluateWithObject:inputPhoneNo.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入了错误的电话号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:inputPhoneNo.text forKey:@"phoneNo"];
    id<AYCommand> cmd = [self.notifies objectForKey:@"reReqConfirmCode:"];
    [cmd performWithResult:&dic];
}

#pragma mark -- handle
- (void)timerRun:(NSTimer*)sender {
    seconds--;
    if (seconds > 0) {
        [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
    } else {
        
        [timer setFireDate:[NSDate distantFuture]];
        
        [getCodeBtn setTitle:@"重获动态密码" forState:UIControlStateNormal];
        if (inputPhoneNo.text.length >= 10) {
            getCodeBtn.enabled = YES;
        }
//        getCodeBtn.userInteractionEnabled = YES;
        
    }
    
}
#pragma mark -- view commands
- (id)hideKeyboard {
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
    if ([inputPhoneNo isFirstResponder]) {
        [inputPhoneNo resignFirstResponder];
    }
    return nil;
}

- (id)startConfirmCodeTimer {
    getCodeBtn.enabled = NO;
    seconds = TimeZore;
    
    [timer setFireDate:[NSDate distantPast]];
    return nil;
}

-(id)showEnterBtnForOldUser{
    if (enterBtn.hidden) {
        
        enterBtn.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            enterBtn.alpha = 1;
        }];
    }
    return nil;
}

-(id)hideEnterBtnForOldUser{
    if (!enterBtn.hidden) {
        
        [UIView animateWithDuration:0.5 animations:^{
            enterBtn.alpha = 0;
        } completion:^(BOOL finished) {
            enterBtn.hidden = YES;
        }];
    }
    return nil;
}

-(id)queryCurCoder:(NSString*)args{
    return coder_area.text;
}

@end
