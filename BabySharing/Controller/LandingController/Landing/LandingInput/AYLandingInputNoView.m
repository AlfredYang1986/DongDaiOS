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
//    UITextField * phone_area;
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
    
    
//    [self createAreaCodeBtnInRect:rect];
//    [self createPhoneAreaIn:rect];
//    [self createCodeLabelInRect:rect];
//    [self createConfirmCodeAreaInRect:rect];
//    [self createCodeBtnInRect:rect];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(handleTimer:)
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

#pragma mark -- init view
- (void)createAreaCodeBtnInRect:(CGRect)rect {
    
    area_code_btn = [[UIButton alloc]init];
    [self addSubview:area_code_btn];
    [area_code_btn setBackgroundImage:PNGRESOURCE(@"login_input_left") forState:UIControlStateNormal];
    [area_code_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input_tips.mas_bottom).offset(15);
        make.left.equalTo(input_tips);
        make.size.mas_equalTo(CGSizeMake(AREA_CODE_WIDTH, INPUT_TEXT_FIELD_HEIGHT));
    }];
    
    UILabel* area_code_label = [[UILabel alloc]init];
    area_code_label.text = @"+86";
    area_code_label.font = [UIFont systemFontOfSize:12.f];
    area_code_label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [area_code_label sizeToFit];
    area_code_label.tag = -1;
    [area_code_btn addSubview:area_code_label];
    [area_code_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.5);
        make.centerY.equalTo(area_code_btn);
    }];
    
    CALayer* t_layer = [CALayer layer];
    t_layer.contents = (id)PNGRESOURCE(@"landing_input_triangle").CGImage;
    t_layer.frame = CGRectMake(0, 0, 9, 8);
    t_layer.position = CGPointMake(area_code_btn.frame.size.width - 18, area_code_btn.frame.size.height / 2);
    [area_code_btn.layer addSublayer:t_layer];
    [area_code_btn addTarget:self action:@selector(areaCodeBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)createPhoneAreaIn:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat first_line_start_margin = INPUT_MARGIN;
    first_line_start_margin = INPUT_MARGIN + AREA_CODE_WIDTH;
    
    UIFont* font = [UIFont systemFontOfSize:13.f];
    
    phone_area = [[UITextField alloc]init];
    [self addSubview:phone_area];
    [phone_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(INPUT_MARGIN + AREA_CODE_WIDTH);
        make.centerY.equalTo(area_code_btn);
        make.width.mas_equalTo(width - AREA_CODE_WIDTH - 2 * INPUT_MARGIN);
        make.height.mas_equalTo(INPUT_TEXT_FIELD_HEIGHT);
    }];
    
    phone_area.backgroundColor = [UIColor whiteColor];
    phone_area.font = font;
    
    CGRect frame = phone_area.frame;
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    phone_area.leftViewMode = UITextFieldViewModeAlways;
    phone_area.leftView = leftview;
    
    phone_area.placeholder = @"请输入您的手机号码";
    [phone_area setValue:[UIColor colorWithWhite:0.6078 alpha:1.f] forKeyPath:@"_placeholderLabel.textColor"];
    phone_area.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    phone_area.keyboardType = UIKeyboardTypeNumberPad;
    phone_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, phone_area.frame.size.height)];
    clear_btn.center = CGPointMake(phone_area.frame.size.width - 25 / 2, phone_area.frame.size.height / 2);
    [phone_area addSubview:clear_btn];
    
    CALayer* layer = [CALayer layer];
    layer.contents = (id)PNGRESOURCE(@"login_input_clear_btn");
    layer.frame = CGRectMake(0, 0, 12, 12);
    layer.position = CGPointMake(10, phone_area.frame.size.height / 2 - 1);
    [clear_btn.layer addSublayer:layer];
    
    clear_btn.hidden = YES;
    
}

- (void)createCodeLabelInRect:(CGRect)rect {
    
    UIButton* tmp = [[UIButton alloc]init];
    [self addSubview:tmp];
    [tmp setBackgroundImage:PNGRESOURCE(@"login_input_left") forState:UIControlStateNormal];
    [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(area_code_btn);
        make.top.equalTo(self).offset(BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN);
        make.size.equalTo(area_code_btn);
    }];
    
    UIImageView* label = [[UIImageView alloc]init];
    label.image = PNGRESOURCE(@"iphone_icon");
//    label.center = CGPointMake(AREA_CODE_WIDTH / 2, INPUT_TEXT_FIELD_HEIGHT / 2);
    label.tag = -1;
    [tmp addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tmp);
        make.centerY.equalTo(tmp);
        make.size.mas_equalTo(CGSizeMake(10, 20));
    }];
    
}

- (void)createConfirmCodeAreaInRect:(CGRect)rect {
    CGFloat width = rect.size.width;
//    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    confirm_area = [[UITextField alloc]init];
    [self addSubview:confirm_area];
    confirm_area.font = [UIFont systemFontOfSize:13.f];
    [confirm_area setBackground:PNGRESOURCE(@"login_input_right")];
    [confirm_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(INPUT_MARGIN + AREA_CODE_WIDTH);
        make.top.equalTo(self).offset(BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN);
        make.width.mas_equalTo(width - 2 * INPUT_MARGIN - AREA_CODE_WIDTH - CODE_BTN_WIDTH - 5);
        make.height.mas_equalTo(INPUT_TEXT_FIELD_HEIGHT);
    }];
    
    CGRect frame = confirm_area.frame;
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    confirm_area.leftViewMode = UITextFieldViewModeAlways;
    confirm_area.leftView = leftview;
    confirm_area.placeholder = @"请输入您的动态密码";
    confirm_area.textAlignment = NSTextAlignmentLeft;
    [confirm_area setValue:[UIColor colorWithWhite:0.6078 alpha:1.f] forKeyPath:@"_placeholderLabel.textColor"];
    confirm_area.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmCodeTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    confirm_area.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)createCodeBtnInRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    
    confirm_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(width - INPUT_MARGIN - CODE_BTN_WIDTH, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN, CODE_BTN_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    [self addSubview:confirm_btn];
    confirm_btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [confirm_btn setTitleColor:[UIColor colorWithWhite:0.2902 alpha:1.f] forState:UIControlStateNormal];
    confirm_btn.clipsToBounds = YES;
    [confirm_btn setBackgroundImage:PNGRESOURCE(@"login_code_bg") forState:UIControlStateNormal];
    [confirm_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-INPUT_MARGIN);
        make.centerY.equalTo(confirm_area);
        make.width.mas_equalTo(CODE_BTN_WIDTH);
        make.height.mas_equalTo(INPUT_TEXT_FIELD_HEIGHT);
    }];
    
    [confirm_btn setTitle:@"获取\n动态密码" forState:UIControlStateNormal];
    confirm_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    confirm_btn.titleLabel.numberOfLines = 2;
    [confirm_btn addTarget:self action:@selector(confirmBtnSelected:) forControlEvents:UIControlEventTouchDown];
    
}


#pragma mark -- handle
- (void)handleTimer:(NSTimer*)sender {
    if (-- seconds > 0) {
        //        [confirm_btn setTitle:[NSString stringWithFormat:@"(%ld)秒重试", (long)seconds] forState:UIControlStateDisabled];
        [confirm_btn setTitle:[NSString stringWithFormat:@"%lds", (long)seconds] forState:UIControlStateDisabled];
    } else {
        seconds = 60;
        [timer setFireDate:[NSDate distantFuture]];
        confirm_btn.enabled = YES;
    }
    
}

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
//    [confirm_area resignFirstResponder];
    return nil;
}

-(id)queryPhoneNo:(NSString*)args{
    NSString* sss = phone_area.text;
    return sss;
}
@end
