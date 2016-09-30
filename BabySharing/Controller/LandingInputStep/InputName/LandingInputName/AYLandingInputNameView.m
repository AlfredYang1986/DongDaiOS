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
#import "AYAlertView.h"

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
    
    /**/
    UIView  *inputView;
    UITextField *name_area;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    UILabel *tips = [[UILabel alloc]init];
    tips = [Tools setLabelWith:tips andText:@"还有，您的姓名" andTextColor:[UIColor colorWithWhite:1.f alpha:0.95f] andFontSize:22.f andBackgroundColor:nil andTextAlignment:1];
    [self addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    /* 姓名 */
    inputView = [[UIView alloc]init];
    [self addSubview:inputView];
    [inputView setBackgroundColor:[Tools colorWithRED:238.f GREEN:251.f BLUE:250.f ALPHA:1.f]];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).offset(32);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(42);
    }];
    
    CALayer *rule_layer = [CALayer layer];
    rule_layer.frame = CGRectMake(15, 13, 1, 14);
    rule_layer.backgroundColor = [Tools garyLineColor].CGColor;
    [inputView.layer addSublayer:rule_layer];
    
//    UILabel *leftView = [[UILabel alloc]init];
//    leftView.backgroundColor = [Tools colorWithRED:220.f GREEN:247.f BLUE:244.f ALPHA:1.f];
//    leftView.text = @"姓 名";
//    leftView.font = [UIFont systemFontOfSize:14.f];
//    leftView.textColor = [Tools themeColor];
//    leftView.textAlignment = NSTextAlignmentCenter;
//    [inputView addSubview:leftView];
//    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputView);
//        make.left.equalTo(inputView);
//        make.size.mas_equalTo(CGSizeMake(96, 40));
//    }];
    
    name_area = [[UITextField alloc]init];
    name_area.delegate = self;
    name_area.backgroundColor = [UIColor clearColor];
    name_area.font = [UIFont systemFontOfSize:14.f];
    name_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    name_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    name_area.placeholder = @"填写您的真实姓名或昵称";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [inputView addSubview:name_area];
    [name_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputView);
        make.top.equalTo(inputView);
        make.left.equalTo(inputView).offset(30);
        make.height.equalTo(inputView);
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
}

#pragma mark -- handle
- (void)nameTextFieldChanged:(UITextField*)tf {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tmp = textField.text;
    if ([Tools bityWithStr:tmp] >= 32){
        [self showAYAlertViewWithTitle:@"4-32个字符(汉字／大写字母长度为2)，仅限中英文"];
        return NO;
    }
    else {
        return YES;
    }
}


- (void)showAYAlertViewWithTitle:(NSString*)title {
    AYAlertView *alertView = [[AYAlertView alloc]initWithTitle:title andTitleColor:nil];
    [self addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(60);
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

#pragma mark -- view commands
- (id)hideKeyboard {
    if ([name_area isFirstResponder]) {
        [name_area resignFirstResponder];
    }
    return nil;
}

-(id)queryInputName:(NSString*)args{
    return name_area.text;
}

@end
