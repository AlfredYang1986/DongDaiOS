//
//  AYLandingInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingInputNameView.h"
#import "AYCommandDefines.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYControllerBase.h"
#import "AYFacadeBase.h"
#import "Tools.h"

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

@implementation AYLandingInputNameView {
    UIButton * area_code_btn;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    NSTimer* timer;
    NSInteger seconds;
    UIButton* clear_btn;
    
    /**/
    UILabel *input_tips;
    UIView  *inputView;
    UITextField *coder_area;
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
    
    UILabel* name_icon = [[UILabel alloc]init];
    [inputView addSubview:name_icon];
    name_icon.text = @"姓名";
    [name_icon sizeToFit];
    name_icon.font = [UIFont systemFontOfSize:14.f];
    name_icon.textColor = [Tools themeColor];
    [name_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView);
        make.left.equalTo(inputView).offset(19);
        make.width.mas_equalTo(name_icon.bounds.size.width);
    }];
    
    UIImageView* rules2 = [[UIImageView alloc]init];
    [inputView addSubview:rules2];
    rules2.image = PNGRESOURCE(@"rules_themecolor");
    [rules2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name_icon.mas_right).offset(19);
        make.centerY.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(2, 25));
    }];
    
    coder_area = [[UITextField alloc]init];
    [self addSubview:coder_area];
    coder_area.backgroundColor = [UIColor clearColor];
    coder_area.font = [UIFont systemFontOfSize:14.f];
    coder_area.placeholder = @"输入姓名";
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
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, coder_area.frame.size.height)];
    clear_btn.center = CGPointMake(coder_area.frame.size.width - 25 / 2, coder_area.frame.size.height / 2);
    [coder_area addSubview:clear_btn];
    
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
    input_tips.text = @"你的名字";
}

#pragma mark -- handle
- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:nil andMessage:@"LandingAreaCode" andArgs:nil];
}

- (void)phoneTextFieldChanged:(UITextField*)tf {
    
    if (![coder_area.text isEqualToString:@""]) {
        clear_btn.hidden = NO;
    } else {
        clear_btn.hidden = YES;
    }
}

- (void)confirmCodeTextFieldChanged:(UITextField*)tf {
    
    if (![coder_area.text isEqualToString:@""]) {
        next_btn.enabled = YES;
    } else {
        next_btn.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == confirm_area && confirm_area.text.length >= 4 && ![string isEqualToString:@""]) return NO;
//    else
        return YES;
}

- (void)confirmBtnSelected:(UIButton*)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:coder_area.text forKey:@"phoneNo"];
    [_controller performForView:self andFacade:@"LandingRemote" andMessage:@"LandingReqConfirmCode" andArgs:[dic copy]];
}

- (void)nextBtnSelected:(UIButton*)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:coder_area.text forKey:@"phoneNo"];
    NSString* reg_token = [_controller performForView:self andFacade:@"LoginModel" andMessage:@"QueryTmpUser" andArgs:[dic copy]];
    NSLog(@"query reg token is %@", reg_token);
    
    NSMutableDictionary* dic_auth = [[NSMutableDictionary alloc]init];
    [dic_auth setValue:coder_area.text forKey:@"phoneNo"];
    [dic_auth setValue:reg_token forKey:@"reg_token"];
    [dic_auth setValue:[Tools getDeviceUUID] forKey:@"uuid"];
 
    [_controller performForView:self andFacade:@"LandingRemote" andMessage:@"LandingAuthConfirm" andArgs:[dic_auth copy]];
}

#pragma mark -- view commands
- (id)hideKeyboard {
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
    return nil;
}

@end
