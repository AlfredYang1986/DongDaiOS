//
//  AYCarePayFixedController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCarePayFixedController.h"
#import "AYCoursePayPriceView.h"

@interface AYCarePayFixedController () {
    
    AYCoursePayPriceView *fullDay;
    AYCoursePayPriceView *halfDay;
    
     NSMutableDictionary *data;
}

@end

@implementation AYCarePayFixedController

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        data = [[NSMutableDictionary alloc] init];
        
        if ([dic objectForKey:kAYControllerChangeArgsKey]) {
            
            data = [dic objectForKey:kAYControllerChangeArgsKey];
            
        }
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UILabel *monthLabel = [UILabel creatLabelWithText:@"全日托" textColor:[UIColor black] font:[UIFont mediumFontSF:15] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:monthLabel];
    
    [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(16 + kNavBarH + kStatusBarH);
        
    }];
    
    fullDay = [[AYCoursePayPriceView alloc] initWithTitle:@"单月价格" and:@"¥" andFont:[UIFont mediumFont:15]];
    [self.view addSubview:fullDay];
    
    [fullDay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(monthLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(56);
        
    }];
    [fullDay.myTextField setDelegate:self];
    
    if ([data objectForKey:@"full_time"]) {
        
        NSNumber *full_time = [data objectForKey:@"full_time"];
        
        [fullDay.myTextField setText:full_time.stringValue];
        
    }
    
    
    
    UILabel *dayLabel = [UILabel creatLabelWithText:@"半日托" textColor:[UIColor black] font:[UIFont regularFont:15] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:dayLabel];
    
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(monthLabel);
        make.top.equalTo(self -> fullDay.mas_bottom).offset(56);
        
    }];
    
    halfDay = [[AYCoursePayPriceView alloc] initWithTitle:@"单月价格" and:@"¥" andFont:[UIFont mediumFont:15]];
    [self.view addSubview:halfDay];
    
    [halfDay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.height.equalTo(self -> fullDay);
        make.top.equalTo(dayLabel.mas_bottom).offset(16);
        
    }];
    [halfDay.myTextField setDelegate:self];
    
    if ([data objectForKey:@"half_time"]) {
        NSNumber *half_time = [data objectForKey:@"half_time"];
        
        [halfDay.myTextField setText:half_time.stringValue];
    }
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn)];
    
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor garyBackground];
    return nil;
    
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor garyBackground];
    
    NSString *title = @"灵活付费设置";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title);
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton *right = [UIButton creatBtnWithTitle:@"保存" titleColor:[UIColor theme] fontSize:17.0f backgroundColor:nil];
    [right.titleLabel setFont:[UIFont mediumFont:17.0f]];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &right);
    
    NSNumber* right_enable = [NSNumber numberWithBool:NO];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
    
    return nil;
    
}

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    
    
    
    return nil;
    
}

- (id)rightBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc] init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *payment_monthly = [[NSMutableDictionary alloc] init];
    
    NSInteger half = halfDay.myTextField.text.integerValue;
    NSInteger full = fullDay.myTextField.text.integerValue;
    
    
    [payment_monthly setValue:[NSNumber numberWithInteger:full] forKey:@"full_time"];
    [payment_monthly setValue:[NSNumber numberWithInteger:half] forKey:@"half_time"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:payment_monthly forKey:@"payment_monthly"];
    
    [dic_pop setValue:dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    
    
    return nil;
    
}

-(void)textFieldShouldReturn {
    
    [fullDay.myTextField resignFirstResponder];
    [halfDay.myTextField resignFirstResponder];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (![fullDay.myTextField  isExclusiveTouch]) {
        
        [fullDay.myTextField  resignFirstResponder];
        
    }
    
    if (![halfDay.myTextField  isExclusiveTouch]) {
        
        [halfDay.myTextField  resignFirstResponder];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![fullDay.myTextField.text isEqual: @""] && ![halfDay.myTextField.text isEqual: @""]) {
        
        NSNumber* right_enable = [NSNumber numberWithBool:YES];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length + string.length > 4) {
        
        return NO;
        
    }
    
    if (textField.text.length < range.location + range.length) {
        
        return NO;
        
    }
    
    return YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
