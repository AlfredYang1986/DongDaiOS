//
//  AYCoursePayByMemberController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCoursePayByMemberController.h"

#import "AYCoursePayView.h"
#import "AYCoursePayPriceView.h"

@interface AYCoursePayByMemberController () {
    
    AYCoursePayPriceView *priceView;
    AYCoursePayView *validTime;
    AYCoursePayView *courseDuration;
    
    NSMutableDictionary *data;
    
}

@end

@implementation AYCoursePayByMemberController

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
    
    priceView = [[AYCoursePayPriceView alloc] initWithTitle:@"会员价格" and:@"¥" andFont:[UIFont mediumFont:15]];
    [self.view addSubview:priceView];
    
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(16 + kNavBarH + kStatusBarH);
        make.height.mas_equalTo(64);
        
    }];
    [priceView.myTextField setDelegate:self];
    [priceView.myTextField setText:[data objectForKey:@"price"]];
    
    validTime = [[AYCoursePayView alloc] initWithTitle:@"有效单位时间" and:@"个月" andFont:[UIFont mediumFont:15]];
    [self.view addSubview:validTime];
    
    [validTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.height.equalTo(self -> priceView);
        make.top.equalTo(self -> priceView.mas_bottom).offset(8);
        
    }];
    [validTime.myTextField setDelegate:self];
    [validTime.myTextField setText:[data objectForKey:@"period"]];
    
    courseDuration = [[AYCoursePayView alloc] initWithTitle:@"单次授课时长" and:@"分钟" andFont:[UIFont regularFontSF:15]];
    [self.view addSubview:courseDuration];
    
    [courseDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.height.equalTo(self -> validTime);
        make.top.equalTo(self -> validTime.mas_bottom).offset(24);
        
    }];
    [courseDuration.myTextField setDelegate:self];
    [courseDuration.myTextField setText:[data objectForKey:@"length"]];
    
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
    
    NSString *title = @"会员制付费设置";
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
    
    //    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    //    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    //    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    //
    //    id<AYCommand> cmd = REVERSMODULE;
    //    [cmd performWithResult:&dic];
    
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
    
    NSMutableDictionary *payment_membership = [[NSMutableDictionary alloc] init];
    
    NSInteger price = priceView.myTextField.text.integerValue;
    NSInteger period = validTime.myTextField.text.integerValue;
    NSInteger length = courseDuration.myTextField.text.integerValue;
    
    [payment_membership setValue:[NSNumber numberWithInteger:price] forKey:@"price"];
    [payment_membership setValue:[NSNumber numberWithInteger:period] forKey:@"period"];
    [payment_membership setValue:[NSNumber numberWithInteger:length] forKey:@"length"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:payment_membership forKey:@"payment_membership"];
    
    [dic_pop setValue:dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    
    
    return nil;
    
}

-(void)textFieldShouldReturn {
    
    [priceView.myTextField resignFirstResponder];
    [validTime.myTextField resignFirstResponder];
    [courseDuration.myTextField resignFirstResponder];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (![priceView.myTextField  isExclusiveTouch]) {
        
        [priceView.myTextField  resignFirstResponder];
        
    }
    
    if (![validTime.myTextField  isExclusiveTouch]) {
        
        [validTime.myTextField  resignFirstResponder];
        
    }
    
    if (![courseDuration.myTextField  isExclusiveTouch]) {
        
        [courseDuration.myTextField  resignFirstResponder];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![priceView.myTextField.text isEqual: @""] && ![validTime.myTextField.text isEqual: @""] && ![courseDuration.myTextField.text isEqual: @""]) {
        
        NSNumber* right_enable = [NSNumber numberWithBool:YES];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
