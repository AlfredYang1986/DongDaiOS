//
//  AYLandingInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingInputView.h"
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

@implementation AYLandingInputView {
    UIButton * area_code_btn;
    UITextField * phone_area;
    UITextField * confirm_area;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    NSTimer* timer;
    NSInteger seconds;
    
    //    OBShapedButton* clear_btn;
    UIButton* clear_btn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height_ori = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = CGRectMake(0, 0, width, height_ori);
    
    [self createAreaCodeBtnInRect:rect];
    [self createPhoneAreaIn:rect];
    [self createCodeLabelInRect:rect];
    [self createConfirmCodeAreaInRect:rect];
    [self createCodeBtnInRect:rect];
    [self createLoginBtnInRect:rect];
    
    CGFloat height = BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN + LOGIN_BTN_HEIGHT + BASICMARGIN;
    self.bounds = CGRectMake(0, 0, width, height);
    
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

#pragma mark -- init view
- (void)createAreaCodeBtnInRect:(CGRect)rect {
    
    UIFont* font = [UIFont systemFontOfSize:12.f];
    area_code_btn = [[UIButton alloc]init];
    [self addSubview:area_code_btn];
    [area_code_btn setBackgroundImage:PNGRESOURCE(@"login_input_left") forState:UIControlStateNormal];
    [area_code_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(BASICMARGIN);
        make.left.equalTo(self).offset(INPUT_MARGIN);
        make.width.mas_equalTo(AREA_CODE_WIDTH);
        make.height.mas_equalTo(INPUT_TEXT_FIELD_HEIGHT);
    }];
    
    UILabel* area_code_label = [[UILabel alloc]init];
    area_code_label.text = @"+86";
    area_code_label.font = font;
    area_code_label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [area_code_label sizeToFit];
//    area_code_label.frame = CGRectMake(13.5, INPUT_TEXT_FIELD_HEIGHT / 2 - area_code_label.bounds.size.height / 2, area_code_label.bounds.size.width, area_code_label.bounds.size.height);
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
    
//    phone_area = [[UITextField alloc]initWithFrame:CGRectMake(first_line_start_margin, BASICMARGIN, width - AREA_CODE_WIDTH - 2 * INPUT_MARGIN, INPUT_TEXT_FIELD_HEIGHT)];
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
//    phone_area.delegate = self;
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
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"动态密码";
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [label sizeToFit];
//    label.center = CGPointMake(AREA_CODE_WIDTH / 2, INPUT_TEXT_FIELD_HEIGHT / 2);
    label.tag = -1;
    [tmp addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tmp);
        make.centerY.equalTo(tmp);
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
//    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
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
    
    //    // 这个地方需要该
    //    confirm_btn.titleLabel.text = @"   获取\n动态密码";
    //
    //
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:confirm_btn.titleLabel.text];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle setLineSpacing:2];
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, confirm_btn.titleLabel.text.length)];
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:[Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.0] range:NSMakeRange(0, confirm_btn.titleLabel.text.length)];
    //
    //    [confirm_btn setAttributedTitle:attributedString forState:UIControlStateNormal];
    [confirm_btn setTitle:@"获取\n动态密码" forState:UIControlStateNormal];
    confirm_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    confirm_btn.titleLabel.numberOfLines = 2;
    [confirm_btn addTarget:self action:@selector(confirmBtnSelected:) forControlEvents:UIControlEventTouchDown];
    
}


- (void)createLoginBtnInRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    
//    next_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN, width - 2 * INPUT_MARGIN, LOGIN_BTN_HEIGHT)];
    next_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN, width - 2 * INPUT_MARGIN, LOGIN_BTN_HEIGHT)];
    [self addSubview:next_btn];
    [next_btn addTarget:self action:@selector(nextBtnSelected:) forControlEvents:UIControlEventTouchDown];
    next_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [next_btn setTitle:@"登 录" forState:UIControlStateNormal];
    [next_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    next_btn.clipsToBounds = YES;
    [next_btn setBackgroundImage:PNGRESOURCE(@"login_btn_bg") forState:UIControlStateNormal];
    [next_btn setBackgroundImage:PNGRESOURCE(@"login_btn_bg_disable") forState:UIControlStateDisabled];
    next_btn.enabled = NO;
    [next_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(width - 2 * INPUT_MARGIN);
        make.height.mas_equalTo(LOGIN_BTN_HEIGHT);
    }];
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
    [phone_area resignFirstResponder];
    [confirm_area resignFirstResponder];
    return nil;
}

- (id)startConfirmCodeTimer {
    seconds = 60;
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
@end
