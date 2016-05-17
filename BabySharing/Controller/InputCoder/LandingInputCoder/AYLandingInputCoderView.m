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

#define BASICMARGIN                         8

#define SNS_TOP_MARGIN                      130

#define AREA_CODE_WIDTH                     66
#define INPUT_TEXT_FIELD_HEIGHT             45.5
#define INPUT_MARGIN                        10.5 //32.5

#define TEXT_FIELD_LEFT_PADDING             10
#define LINE_MARGIN                         5
#define CODE_BTN_WIDTH                      80

#define LOGIN_BTN_TOP_MARGIN                60
#define LOGIN_BTN_HEIGHT                    37
#define LOGIN_BTN_BOTTOM_MARGIN             40

@implementation AYLandingInputCoderView {
    UIButton * area_code_btn;
//    UITextField * coder_area;
    UITextField * confirm_area;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    NSTimer* timer;
    NSInteger seconds;
    UIButton* clear_btn;
    
    /**/
    UILabel *input_tips;
    UIView  *inputView;
//    UITextField *coder_area;
    UILabel *count_timer;
    UIButton *re_get_coder;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize coder_area = _coder_area;

- (void)postPerform {
    
    input_tips = [[UILabel alloc]init];
    input_tips.font = [UIFont systemFontOfSize:14.f];
    input_tips.textColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.f];
    input_tips.textAlignment = NSTextAlignmentLeft;
    [self addSubview:input_tips];
    [input_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    
    /* 验证输入 */
    inputView = [[UIView alloc]init];
    [self addSubview:inputView];
    [inputView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    inputView.layer.cornerRadius = 6.f;
    inputView.clipsToBounds = YES;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input_tips.mas_bottom).offset(15);
        make.left.equalTo(input_tips);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView* phone_icon = [[UIImageView alloc]init];
    [inputView addSubview:phone_icon];
    phone_icon.image = PNGRESOURCE(@"coder_icon");
    [phone_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView);
        make.left.equalTo(inputView).offset(19);
        make.size.mas_equalTo(CGSizeMake(18, 20));
    }];
    
    UIImageView* rules2 = [[UIImageView alloc]init];
    [inputView addSubview:rules2];
    rules2.image = PNGRESOURCE(@"rules_themecolor");
    [rules2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phone_icon.mas_right).offset(19);
        make.centerY.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(2, 25));
    }];
    
    _coder_area = [[UITextField alloc]init];
    [self addSubview:_coder_area];
    _coder_area.backgroundColor = [UIColor clearColor];
    _coder_area.font = [UIFont systemFontOfSize:14.f];
    _coder_area.placeholder = @"输入动态密码";
    [_coder_area setValue:[Tools themeColor] forKeyPath:@"_placeholderLabel.textColor"];
    _coder_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    _coder_area.keyboardType = UIKeyboardTypeNumberPad;
    _coder_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [_coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rules2.mas_right).offset(5);
        make.centerY.equalTo(inputView);
        make.right.equalTo(inputView);
        make.height.mas_equalTo(40);
    }];
    
    CGRect frame = _coder_area.frame;
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    _coder_area.leftViewMode = UITextFieldViewModeAlways;
    _coder_area.leftView = leftview;
    
    count_timer = [[UILabel alloc]init];
    count_timer.font = [UIFont systemFontOfSize:12.f];
    count_timer.textColor = [Tools themeColor];
    count_timer.textAlignment = NSTextAlignmentLeft;
    [inputView addSubview:count_timer];
    [inputView bringSubviewToFront:count_timer];
    [count_timer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputView).offset(-12);
        make.centerY.equalTo(inputView);
    }];
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, _coder_area.frame.size.height)];
    clear_btn.center = CGPointMake(_coder_area.frame.size.width - 25 / 2, _coder_area.frame.size.height / 2);
    [_coder_area addSubview:clear_btn];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];
    [timer setFireDate:[NSDate distantFuture]];
    
    /* 重新获取coder */
    re_get_coder = [[UIButton alloc]init];
    [re_get_coder setTitle:@"重新获取动态密码" forState:UIControlStateNormal];
    [re_get_coder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [re_get_coder setBackgroundColor:[UIColor clearColor]];
    re_get_coder.titleLabel.font = [UIFont systemFontOfSize:12.f];
    re_get_coder.layer.cornerRadius = 4.f;
    re_get_coder.layer.borderColor = [UIColor whiteColor].CGColor;
    re_get_coder.layer.borderWidth = 1.f;
    re_get_coder.hidden = YES;
    [re_get_coder addTarget:self action:@selector(requestCoder:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:re_get_coder];
    [re_get_coder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(18);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 26));
    }];
    
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
    id<AYCommand> cmd = [self.notifies objectForKey:@"queryCurPhoneNo:"];
    NSString* numb = nil;
    [cmd performWithResult:&numb];
    input_tips.text = [NSString stringWithFormat:@"当前手机号码：%@",numb];
}

#pragma mark -- handle
- (void)handleTimer:(NSTimer*)sender {
    if (-- seconds > 0) {
        count_timer.text = [NSString stringWithFormat:@"%lds",(long)seconds];
    } else {
        seconds = 30;
        [timer setFireDate:[NSDate distantFuture]];
        count_timer.hidden = YES;
        re_get_coder.hidden = NO;
    }
    
}

-(void)requestCoder:(UIButton*)sender{

    id<AYCommand> cmd = [self.notifies objectForKey:@"reReqConfirmCode"];
    [cmd performWithResult:nil];
}

- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:nil andMessage:@"LandingAreaCode" andArgs:nil];
}

- (void)phoneTextFieldChanged:(UITextField*)tf {
    
//    if (![coder_area.text isEqualToString:@""] && confirm_area.text.length >= 4) {
//        next_btn.enabled = YES;
//    } else {
//        next_btn.enabled = NO;
//    }
    
    if (![_coder_area.text isEqualToString:@""]) {
        clear_btn.hidden = NO;
        count_timer.hidden = YES;
    } else {
        clear_btn.hidden = YES;
        count_timer.hidden = NO;
    }
}

- (void)confirmCodeTextFieldChanged:(UITextField*)tf {
    //    if (!([coder_area.text isEqualToString:@""] || [confirm_area.text isEqualToString:@""])) {
    if (![_coder_area.text isEqualToString:@""] && confirm_area.text.length >= 4) {
        next_btn.enabled = YES;
    } else {
        next_btn.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == confirm_area && confirm_area.text.length >= 4 && ![string isEqualToString:@""]) return NO;
    else return YES;
}

- (void)confirmBtnSelected:(UIButton*)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_coder_area.text forKey:@"phoneNo"];
    [_controller performForView:self andFacade:@"LandingRemote" andMessage:@"LandingReqConfirmCode" andArgs:[dic copy]];
}

- (void)nextBtnSelected:(UIButton*)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_coder_area.text forKey:@"phoneNo"];
    NSString* reg_token = [_controller performForView:self andFacade:@"LoginModel" andMessage:@"QueryTmpUser" andArgs:[dic copy]];
    NSLog(@"query reg token is %@", reg_token);
    
    NSMutableDictionary* dic_auth = [[NSMutableDictionary alloc]init];
    [dic_auth setValue:_coder_area.text forKey:@"phoneNo"];
    [dic_auth setValue:reg_token forKey:@"reg_token"];
    [dic_auth setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic_auth setValue:confirm_area.text forKey:@"code"];
 
    [_controller performForView:self andFacade:@"LandingRemote" andMessage:@"LandingAuthConfirm" andArgs:[dic_auth copy]];
}

#pragma mark -- view commands
- (id)hideKeyboard {
    if ([_coder_area isFirstResponder]) {
        [_coder_area resignFirstResponder];
    }
    return nil;
}

- (id)startConfirmCodeTimer {
    seconds = 30;
    confirm_btn.enabled = NO;
    [timer setFireDate:[NSDate distantPast]];
    return nil;
}

- (id)stopConfirmCodeTimer {
    seconds = 0;
    confirm_btn.enabled = YES;
    [timer setFireDate:[NSDate distantFuture]];
    [confirm_btn setTitle:@"获取\n动态密码" forState:UIControlStateNormal];
    return nil;
}

-(id)queryCurCoder:(NSString*)args{
    return _coder_area.text;
}

@end
