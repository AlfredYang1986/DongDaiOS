//
//  AYCarePayFlexibleController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCarePayFlexibleController.h"
#import "AYCoursePayView.h"
#import "AYCoursePayPriceView.h"

@interface AYCarePayFlexibleController () {
    
    AYCoursePayPriceView *priceView;
    AYCoursePayView *minOrderTime;
    
    NSMutableDictionary *data;
    
}

@end

@implementation AYCarePayFlexibleController


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
    
    priceView = [[AYCoursePayPriceView alloc] initWithTitle:@"每小时服务" and:@"¥" andFont:[UIFont regularFont :15]];
    [self.view addSubview:priceView];
    
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(16 + kNavBarH + kStatusBarH);
        make.height.mas_equalTo(56);
        
    }];
    [priceView.myTextField setDelegate:self];
    
    if ([data objectForKey:@"price"]) {
        
        NSNumber *price = [data objectForKey:@"price"];
        
        [priceView.myTextField setText:price.stringValue];
        
    }
    
    
    
    minOrderTime = [[AYCoursePayView alloc] initWithTitle:@"单次最少购买时长" and:@"小时" andFont:[UIFont regularFont :15]];
    [self.view addSubview:minOrderTime];
    
    [minOrderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.height.equalTo(self -> priceView);
        make.top.equalTo(self -> priceView.mas_bottom).offset(8);
        
    }];
    [minOrderTime.myTextField setDelegate:self];
    
    if ([data objectForKey:@"length"]) {
        
        NSNumber *length = [data objectForKey:@"length"];
        
        [minOrderTime.myTextField setText:length.stringValue];
        
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
    
    
    
    NSMutableDictionary *payment_daily = [[NSMutableDictionary alloc] init];
    
    NSInteger price = priceView.myTextField.text.integerValue;
    NSInteger length = minOrderTime.myTextField.text.integerValue;
    
    [payment_daily setValue:[NSNumber numberWithInteger:price] forKey:@"price"];
    [payment_daily setValue:[NSNumber numberWithInteger:length] forKey:@"length"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:payment_daily forKey:@"payment_daily"];
    
    [dic_pop setValue:dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    
    
    return nil;
    
}

-(void)textFieldShouldReturn {
    
    [priceView.myTextField resignFirstResponder];
    [minOrderTime.myTextField resignFirstResponder];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (![priceView.myTextField  isExclusiveTouch]) {
        
        [priceView.myTextField  resignFirstResponder];
        
    }
    
    if (![minOrderTime.myTextField  isExclusiveTouch]) {
        
        [minOrderTime.myTextField  resignFirstResponder];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![priceView.myTextField.text isEqual: @""] && ![minOrderTime.myTextField.text isEqual: @""]) {
        
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
