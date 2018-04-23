//
//  AYCoursePayByTimeController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCoursePayByTimeController.h"
#import "AYCoursePayView.h"
#import "AYCoursePayPriceView.h"

@interface AYCoursePayByTimeController () {
    
    AYCoursePayPriceView *priceView;
    AYCoursePayView *minOrderTimes;
    AYCoursePayView *courseDuration;
    
    NSMutableDictionary *data;
}

@end

@implementation AYCoursePayByTimeController

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
    
    priceView = [[AYCoursePayPriceView alloc] initWithTitle:@"单次课程价格" and:@"¥" andFont:[UIFont mediumFont:15]];
    [self.view addSubview:priceView];
    
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(16 + kNavBarH + kStatusBarH);
        make.height.mas_equalTo(64);
        
    }];
    [priceView.myTextField setDelegate:self];
    
    if ([data objectForKey:@"price"]) {
        
        NSNumber *price = [data objectForKey:@"price"];
        
        [priceView.myTextField setText: price.stringValue];
        
    }
    
    
    
    minOrderTimes = [[AYCoursePayView alloc] initWithTitle:@"单次最少预定次数" and:@"次" andFont:[UIFont mediumFont:15]];
    [self.view addSubview:minOrderTimes];
    
    [minOrderTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.height.equalTo(self -> priceView);
        make.top.equalTo(self -> priceView.mas_bottom).offset(8);
        
    }];
    [minOrderTimes.myTextField setDelegate:self];
    
    if([data objectForKey:@"times"]) {
        
        NSNumber *times = [data objectForKey:@"times"];
        
        [minOrderTimes.myTextField setText:times.stringValue];
        
    }
    
    
    
    courseDuration = [[AYCoursePayView alloc] initWithTitle:@"单次授课时长" and:@"分钟" andFont:[UIFont regularFontSF:15]];
    [self.view addSubview:courseDuration];
    
    [courseDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.height.equalTo(self -> minOrderTimes);
        make.top.equalTo(self -> minOrderTimes.mas_bottom).offset(24);
        
    }];
    [courseDuration.myTextField setDelegate:self];
    
    if ([data objectForKey:@"length"]) {
        
        NSNumber *length = [data objectForKey:@"length"];
        [courseDuration.myTextField setText:length.stringValue];
        
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
    
    NSString *title = @"按次付费设置";
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
    
    NSMutableDictionary *payment_time = [[NSMutableDictionary alloc] init];
    
    NSInteger price = priceView.myTextField.text.integerValue;
    NSInteger times = minOrderTimes.myTextField.text.integerValue;
    NSInteger length = courseDuration.myTextField.text.integerValue;
    
    [payment_time setValue:[NSNumber numberWithInteger:price] forKey:@"price"];
    [payment_time setValue:[NSNumber numberWithInteger:times] forKey:@"times"];
    [payment_time setValue:[NSNumber numberWithInteger:length] forKey:@"length"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:payment_time forKey:@"payment_time"];
    
    [dic_pop setValue:dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    
    
    return nil;
    
}

-(void)textFieldShouldReturn {
    
    [priceView.myTextField resignFirstResponder];
    [minOrderTimes.myTextField resignFirstResponder];
    [courseDuration.myTextField resignFirstResponder];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {


    if (![priceView.myTextField  isExclusiveTouch]) {

        [priceView.myTextField  resignFirstResponder];

    }
    
    if (![minOrderTimes.myTextField  isExclusiveTouch]) {
        
        [minOrderTimes.myTextField  resignFirstResponder];
        
    }
    
    if (![courseDuration.myTextField  isExclusiveTouch]) {
        
        [courseDuration.myTextField  resignFirstResponder];
        
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![priceView.myTextField.text isEqual: @""] && ![minOrderTimes.myTextField.text isEqual: @""] && ![courseDuration.myTextField.text isEqual: @""]) {
        
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
    
}



@end
