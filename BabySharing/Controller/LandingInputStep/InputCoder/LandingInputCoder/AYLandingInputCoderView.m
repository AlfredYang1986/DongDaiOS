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
    UIButton *re_get_coder;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    input_tips = [[UILabel alloc]init];
    input_tips.font = [UIFont systemFontOfSize:14.f];
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
    [countryAreaView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    countryAreaView.layer.cornerRadius = 6.f;
    countryAreaView.clipsToBounds = YES;
    [countryAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input_tips.mas_bottom).offset(15);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];

    UILabel *area = [[UILabel alloc]init];
    area.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.f];
    area.text = @"国家/地区";
    area.font = [UIFont systemFontOfSize:14.f];
    area.textColor = [UIColor colorWithWhite:0.15f alpha:1.f];
    area.textAlignment = NSTextAlignmentCenter;
    [countryAreaView addSubview:area];
    [area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countryAreaView);
        make.left.equalTo(countryAreaView);
        make.size.mas_equalTo(CGSizeMake(90, 40));
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
    [areaBtn setBackgroundImage:[UIImage imageNamed:@"landing_input_triangle"] forState:UIControlStateNormal];
    [areaBtn addTarget:self action:@selector(areaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [countryAreaView addSubview:areaBtn];
    [areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countryAreaView.mas_right).offset(-8);
        make.centerY.equalTo(countryAreaView);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    /* 电话号码 */
    inputPhoneNoView = [[UIView alloc]init];
    [self addSubview:inputPhoneNoView];
    [inputPhoneNoView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    inputPhoneNoView.layer.cornerRadius = 6.f;
    inputPhoneNoView.clipsToBounds = YES;
    [inputPhoneNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countryAreaView.mas_bottom).offset(12);
        make.left.equalTo(input_tips);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *phoneNo = [[UILabel alloc]init];
    phoneNo.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.f];
    phoneNo.text = @"电话号码";
    phoneNo.font = [UIFont systemFontOfSize:14.f];
    phoneNo.textColor = [UIColor colorWithWhite:0.15f alpha:1.f];
    phoneNo.textAlignment = NSTextAlignmentCenter;
    [inputPhoneNoView addSubview:phoneNo];
    [phoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPhoneNoView);
        make.left.equalTo(inputPhoneNoView);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];

    inputPhoneNo = [[UITextField alloc]init];
    inputPhoneNo.backgroundColor = [UIColor clearColor];
    inputPhoneNo.font = [UIFont systemFontOfSize:14.f];
    inputPhoneNo.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
//    inputPhoneNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [inputPhoneNoView addSubview:inputPhoneNo];
    [inputPhoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputPhoneNoView);
        make.top.equalTo(inputPhoneNoView);
        make.left.equalTo(phoneNo.mas_right).offset(10);
        make.height.equalTo(inputPhoneNoView);
    }];
    
    getCodeBtn = [[UIButton alloc]init];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [getCodeBtn addTarget:self action:@selector(getcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [inputPhoneNoView addSubview:getCodeBtn];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputPhoneNoView.mas_right).offset(-8);
        make.centerY.equalTo(inputPhoneNoView);
        make.size.mas_equalTo(CGSizeMake(68, 40));
    }];
    
    
    /* 验证码 */
    inputCodeView = [[UIView alloc]init];
    [self addSubview:inputCodeView];
    [inputCodeView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    inputCodeView.layer.cornerRadius = 6.f;
    inputCodeView.clipsToBounds = YES;
    [inputCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPhoneNoView.mas_bottom).offset(12);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *confirmCode = [[UILabel alloc]init];
    confirmCode.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.f];
    confirmCode.text = @"动态密码";
    confirmCode.font = [UIFont systemFontOfSize:14.f];
    confirmCode.textColor = [UIColor colorWithWhite:0.15f alpha:1.f];
    confirmCode.textAlignment = NSTextAlignmentCenter;
    [inputCodeView addSubview:confirmCode];
    [confirmCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView);
        make.left.equalTo(inputCodeView);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];
    
    coder_area = [[UITextField alloc]init];
    coder_area.backgroundColor = [UIColor clearColor];
    coder_area.font = [UIFont systemFontOfSize:14.f];
    coder_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    coder_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [inputCodeView addSubview:coder_area];
    [coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputCodeView);
        make.top.equalTo(inputCodeView);
        make.left.equalTo(confirmCode.mas_right).offset(10);
        make.height.equalTo(inputCodeView);
    }];
    
    count_timer = [[UILabel alloc]init];
    count_timer.font = [UIFont systemFontOfSize:12.f];
    count_timer.textColor = [Tools themeColor];
    count_timer.textAlignment = NSTextAlignmentLeft;
    count_timer.hidden = YES;
    [inputCodeView addSubview:count_timer];
    [inputCodeView bringSubviewToFront:count_timer];
    [count_timer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputCodeView).offset(-12);
        make.centerY.equalTo(inputCodeView);
    }];
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, coder_area.frame.size.height)];
    clear_btn.center = CGPointMake(coder_area.frame.size.width - 25 / 2, coder_area.frame.size.height / 2);
    [coder_area addSubview:clear_btn];
    
    /* 重新获取coder */
    re_get_coder = [[UIButton alloc]init];
    [re_get_coder setTitle:@"重新获取动态密码" forState:UIControlStateNormal];
    [re_get_coder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    re_get_coder.alpha = 0;
    [re_get_coder setBackgroundColor:[UIColor clearColor]];
    re_get_coder.titleLabel.font = [UIFont systemFontOfSize:12.f];
    re_get_coder.layer.cornerRadius = 4.f;
    re_get_coder.layer.borderColor = [UIColor whiteColor].CGColor;
    re_get_coder.layer.borderWidth = 1.f;
    re_get_coder.hidden = YES;
    [re_get_coder addTarget:self action:@selector(requestCoder:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:re_get_coder];
    [re_get_coder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView.mas_bottom).offset(18);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 26));
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
    seconds = 30;
    re_get_coder.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        re_get_coder.alpha = 0;
    }];
    count_timer.hidden = NO;
    [timer setFireDate:[NSDate distantPast]];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:inputPhoneNo.text forKey:@"phoneNo"];
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"reReqConfirmCode:"];
    [cmd performWithResult:&dic];
}

- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:nil andMessage:@"LandingAreaCode" andArgs:nil];
}

- (void)phoneTextFieldChanged:(UITextField*)tf {

    if (![coder_area.text isEqualToString:@""]) {
        clear_btn.hidden = NO;
        count_timer.hidden = YES;
    } else if( seconds > 0){
        clear_btn.hidden = YES;
        count_timer.hidden = NO;
    }else{
        clear_btn.hidden = YES;
        count_timer.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == coder_area && coder_area.text.length >= 4 && ![string isEqualToString:@""]) return NO;
    else return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    count_timer.hidden = YES;
    clear_btn.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (seconds > 0) {
        count_timer.hidden = NO;
    }
    clear_btn.hidden = YES;
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
        count_timer.text = [NSString stringWithFormat:@"%lds",(long)seconds];
    } else {
        
        [timer setFireDate:[NSDate distantFuture]];
        count_timer.hidden = YES;
        re_get_coder.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            re_get_coder.alpha = 1;
        }];
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
    
    //    getCodeBtn.userInteractionEnabled = NO;
    getCodeBtn.hidden = YES;
    count_timer.hidden = NO;
    seconds = 30;
    [timer setFireDate:[NSDate distantPast]];
    return nil;
}

-(id)queryCurCoder:(NSString*)args{
    return coder_area.text;
}

@end
