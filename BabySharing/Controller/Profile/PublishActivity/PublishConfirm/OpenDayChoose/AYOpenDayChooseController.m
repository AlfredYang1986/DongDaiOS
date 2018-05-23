//
//  AYOpenDayChooseController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYOpenDayChooseController.h"
#import "AYOpenDayChooseView.h"
@interface AYOpenDayChooseController () {
    
    AYOpenDayChooseView * v;
    
    NSArray *openDays;
    
}

@end

@implementation AYOpenDayChooseController


- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        if ([dic objectForKey:kAYControllerChangeArgsKey]) {
            
            openDays = [dic objectForKey:kAYControllerChangeArgsKey];
            
        }
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {

        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    v = [[AYOpenDayChooseView alloc] init];
    [self.view addSubview:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarH + kStatusBarH);
        
    }];
    
    [v setSelectedDate:[openDays mutableCopy]];
    
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
    
    NSString *title = @"选择不提供开放日的日期";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title);
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton *right = [UIButton creatBtnWithTitle:@"保存" titleColor:[UIColor black] fontSize:17.0f backgroundColor:nil];
    [right.titleLabel setFont:[UIFont mediumFont:17.0f]];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &right);
    
    NSNumber* right_enable = [NSNumber numberWithBool:YES];
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
    
    NSLog(@"%@",v.selectedDate);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    if (v.selectedDate.count > 0) {
        
        
        [dic setValue:v.selectedDate forKey:kAYControllerChangeArgsKey];
        
    }
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
