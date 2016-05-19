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
    UIView  *inputView;
    UITextField *coder_area;
    UILabel *count_timer;
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
    
    coder_area = [[UITextField alloc]init];
    [self addSubview:coder_area];
    coder_area.backgroundColor = [UIColor clearColor];
    coder_area.font = [UIFont systemFontOfSize:14.f];
    coder_area.placeholder = @"输入动态密码";
    [coder_area setValue:[Tools themeColor] forKeyPath:@"_placeholderLabel.textColor"];
    coder_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    coder_area.keyboardType = UIKeyboardTypeNumberPad;
    coder_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rules2.mas_right).offset(5);
        make.centerY.equalTo(inputView);
        make.right.equalTo(inputView);
        make.height.mas_equalTo(40);
    }];
    
    CGRect frame = coder_area.frame;
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    coder_area.leftViewMode = UITextFieldViewModeAlways;
    coder_area.leftView = leftview;
    
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
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, coder_area.frame.size.height)];
    clear_btn.center = CGPointMake(coder_area.frame.size.width - 25 / 2, coder_area.frame.size.height / 2);
    [coder_area addSubview:clear_btn];
    
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

-(void)requestCoder:(UIButton*)sender{
    seconds = 30;
    re_get_coder.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        re_get_coder.alpha = 0;
    }];
    count_timer.hidden = NO;
    [timer setFireDate:[NSDate distantPast]];

    id<AYCommand> cmd = [self.notifies objectForKey:@"reReqConfirmCode"];
    [cmd performWithResult:nil];
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


#pragma mark -- view commands
- (id)hideKeyboard {
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
    return nil;
}

- (id)startConfirmCodeTimer {
    seconds = 30;
    [timer setFireDate:[NSDate distantPast]];
    return nil;
}

-(id)queryCurCoder:(NSString*)args{
    return coder_area.text;
}

@end
