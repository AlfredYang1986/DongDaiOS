//
//  AYLandingInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingInputNoView.h"
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

@implementation AYLandingInputNoView {
    UIButton * area_code_btn;
    UITextField * confirm_area;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    NSTimer* timer;
    NSInteger seconds;
    
    UIButton* clear_btn;
    
    /**/
    UILabel *input_tips;
    UIView* areaView;
    UIView* inputView;
    UITextField * phone_area;
    UILabel* area_country_input;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    input_tips = [[UILabel alloc]init];
    input_tips.text = @"请输入您的手机号码";
    input_tips.font = [UIFont systemFontOfSize:14.f];
    input_tips.textColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.f];
    input_tips.textAlignment = NSTextAlignmentLeft;
    [self addSubview:input_tips];
    [input_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    
    /* 国家地区 */
    areaView = [[UIView alloc]init];
    [self addSubview:areaView];
    [areaView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    areaView.layer.cornerRadius = 6.f;
    areaView.clipsToBounds = YES;
    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input_tips.mas_bottom).offset(15);
        make.left.equalTo(input_tips);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    areaView.userInteractionEnabled = YES;
    [areaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaCodeBtnSelected:)]];
    
    UILabel *area_country = [[UILabel alloc]init];
    [areaView addSubview:area_country];
    area_country.text = @"国家/地区";
    area_country.font = [UIFont systemFontOfSize:14.f];
    area_country.textColor = [Tools themeColor];
    [area_country mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(areaView);
        make.left.equalTo(areaView).offset(8);
    }];
    
    UIImageView* rules = [[UIImageView alloc]init];
    [areaView addSubview:rules];
    rules.image = PNGRESOURCE(@"rules_themecolor");
    [rules mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(area_country.mas_right).offset(8);
        make.centerY.equalTo(areaView);
        make.size.mas_equalTo(CGSizeMake(2, 25));
    }];
    
    area_country_input = [[UILabel alloc]init];
    [areaView addSubview:area_country_input];
    area_country_input.text = @"中国";
    area_country_input.font = [UIFont systemFontOfSize:14.f];
    area_country_input.textColor = [Tools themeColor];
    [area_country_input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(areaView);
        make.left.equalTo(rules.mas_right).offset(15);
    }];
    
    /* 号码输入 */
    inputView = [[UIView alloc]init];
    [self addSubview:inputView];
    [inputView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    inputView.layer.cornerRadius = 6.f;
    inputView.clipsToBounds = YES;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(areaView.mas_bottom).offset(12);
        make.left.equalTo(areaView);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView* phone_icon = [[UIImageView alloc]init];
    [inputView addSubview:phone_icon];
    phone_icon.image = PNGRESOURCE(@"phone_icon");
    [phone_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView);
        make.left.equalTo(inputView).offset(19);
        make.size.mas_equalTo(CGSizeMake(10, 20));
    }];
    
    UIImageView* rules2 = [[UIImageView alloc]init];
    [inputView addSubview:rules2];
    rules2.image = PNGRESOURCE(@"rules_themecolor");
    [rules2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phone_icon.mas_right).offset(19);
        make.centerY.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(2, 25));
    }];
    
    phone_area = [[UITextField alloc]init];
    [self addSubview:phone_area];
    phone_area.backgroundColor = [UIColor clearColor];
    phone_area.font = [UIFont systemFontOfSize:14.f];
    phone_area.placeholder = @"手机号码";
    [phone_area setValue:[Tools themeColor] forKeyPath:@"_placeholderLabel.textColor"];
    phone_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    phone_area.keyboardType = UIKeyboardTypeNumberPad;
    phone_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [phone_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rules2.mas_right).offset(5);
        make.centerY.equalTo(inputView);
        make.right.equalTo(inputView);
//        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    CGRect frame = phone_area.frame;
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    phone_area.leftViewMode = UITextFieldViewModeAlways;
    phone_area.leftView = leftview;
    
    
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, phone_area.frame.size.height)];
    clear_btn.center = CGPointMake(phone_area.frame.size.width - 25 / 2, phone_area.frame.size.height / 2);
    [phone_area addSubview:clear_btn];
    
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

#pragma mark -- handle
- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:nil andMessage:@"LandingAreaCode" andArgs:nil];
}

#define CODE_DIG_COUNT          4
- (void)phoneTextFieldChanged:(UITextField*)tf {
    //    if (!([phone_area.text isEqualToString:@""] || [confirm_area.text isEqualToString:@""])) {
    if (![phone_area.text isEqualToString:@""] && confirm_area.text.length >= CODE_DIG_COUNT) {
        next_btn.enabled = YES;
    } else {
        next_btn.enabled = NO;
    }
    
    if (![phone_area.text isEqualToString:@""]) {
        clear_btn.hidden = NO;
    } else {
        clear_btn.hidden = YES;
    }
}

- (void)confirmCodeTextFieldChanged:(UITextField*)tf {
    //    if (!([phone_area.text isEqualToString:@""] || [confirm_area.text isEqualToString:@""])) {
    if (![phone_area.text isEqualToString:@""] && confirm_area.text.length >= CODE_DIG_COUNT) {
        next_btn.enabled = YES;
    } else {
        next_btn.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == confirm_area && confirm_area.text.length >= CODE_DIG_COUNT && ![string isEqualToString:@""]) return NO;
    else return YES;
}

- (void)confirmBtnSelected:(UIButton*)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phone_area.text forKey:@"phoneNo"];
    [_controller performForView:self andFacade:@"LandingRemote" andMessage:@"LandingReqConfirmCode" andArgs:[dic copy]];
}

- (void)nextBtnSelected:(UIButton*)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phone_area.text forKey:@"phoneNo"];
    NSString* reg_token = [_controller performForView:self andFacade:@"LoginModel" andMessage:@"QueryTmpUser" andArgs:[dic copy]];
    NSLog(@"query reg token is %@", reg_token);
    
    NSMutableDictionary* dic_auth = [[NSMutableDictionary alloc]init];
    [dic_auth setValue:phone_area.text forKey:@"phoneNo"];
    [dic_auth setValue:reg_token forKey:@"reg_token"];
    [dic_auth setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic_auth setValue:confirm_area.text forKey:@"code"];
 
    [_controller performForView:self andFacade:@"LandingRemote" andMessage:@"LandingAuthConfirm" andArgs:[dic_auth copy]];
}

#pragma mark -- view commands
- (id)hideKeyboard {
    if ([phone_area isFirstResponder]) {
        [phone_area resignFirstResponder];
    }
    return nil;
}

-(id)queryPhoneNo:(NSString*)args{
    return phone_area.text;;
}
@end
