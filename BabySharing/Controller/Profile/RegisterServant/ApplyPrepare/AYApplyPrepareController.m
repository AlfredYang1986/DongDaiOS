//
//  AYApplyPrepareController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYApplyPrepareController.h"
#import "AYLineView.h"
#import "SwipeView.h"
#import "AYNameInputView.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"


@interface AYApplyPrepareController () {
    
    AYLineView *line;
    SwipeView *swipeView;
    
    NSMutableDictionary *data;
    
    NSString *userName;
    NSString *brandName;
    NSString *cityName;
    NSString *phoneNumber;
    NSString *category;
    
}

@end

@implementation AYApplyPrepareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    line = [[AYLineView alloc] initWithNumber:4];
    
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(4);
        make.top.mas_equalTo(kNavBarH + kStatusBarH);
        make.left.equalTo(self.view);
        
    }];
    
    [line setStep:0];
    
    swipeView = [[SwipeView alloc] init];
    [self.view addSubview:swipeView];
    
    [swipeView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kNavBarH + kStatusBarH + 8);
        
    }];
    
    [swipeView setDelegate:self];
    [swipeView setDataSource:self];
    [swipeView setScrollEnabled:NO];
    
    
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor white];
    return nil;
    
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor white];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton *right = [UIButton creatBtnWithTitle:@"下一步" titleColor:[UIColor black] fontSize:17.0f backgroundColor:nil];
    [right.titleLabel setFont:[UIFont mediumFont:17.0f]];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &right);
    
    NSNumber* right_enable = [NSNumber numberWithBool:NO];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
    NSString *title = @"申请授权账号";
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title);
    
    
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
    
    NSInteger index = swipeView.currentPage;
    
    
    if (index == 0) {
        
        if(!data) {
            
            data = [[NSMutableDictionary alloc] init];
            
        }
        
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        
        [temp setValue:userName forKey:@"name"];

        if (brandName) {
            
            [temp setValue:brandName forKey:@"brand_name"];
            
        }
        
        [data setValue:temp forKey:@"apply"];

        
    }else if (index == 1) {
        
        [[data objectForKey:@"apply"] setValue:cityName forKey:@"city"];
        
    }else if (index == 2) {
        
        [[data objectForKey:@"apply"] setValue:cityName forKey:@"phone"];
        
    }else if (index == 3) {
        
        if (![category isEqual:@""]) {
            
            [[data objectForKey:@"apply"] setValue:category forKey:@"category"];
        
            
        }
        
        
    }
    
    if (index != 3) {
        
        [swipeView scrollToPage:index + 1 duration:0];
        [line setStep:index + 1];
        
        NSNumber* right_enable = [NSNumber numberWithBool:NO];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
        
    }else {
    
        NSDictionary *user;
        CURRENUSER(user);
        
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
        
        [data setValue:condition forKey:kAYCommArgsCondition];
        [data setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"ApplicationRemote"];
        AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"AddApplication"];
        
        
        
        [cmd performWithResult:[data copy] andFinishBlack:^(BOOL success, NSDictionary *result) {

            if (success) {
                
                AYViewController *des = DEFAULTCONTROLLER(@"ApplySuccess");
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
                [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
                [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
                
                id<AYCommand> md = PUSH;
                [md performWithResult:&dic];

            }else {



            }

        }];
    
        
        
    }
    
    
    
    
    
    return nil;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if(index == 0) {
        
        AYNameInputView *v = [[AYNameInputView alloc] init];
        
        [v setDelegate:self];
        
        return v;
        
    }
    
    if (index == 1) {
        
        NSString *name = [[data objectForKey:@"apply"] objectForKey:@"name"];
        
        AYCityInputView *v = [[AYCityInputView alloc] initWithName:name];
        
        [v setDelegate:self];
        
        return v;
        
    }
    
    if (index == 2) {
        
        NSString *name = [[data objectForKey:@"apply"] objectForKey:@"name"];
        NSString *city = [[data objectForKey:@"apply"] objectForKey:@"city"];
        
        AYPhoneInputView *v = [[AYPhoneInputView alloc] initWithName:name city:city];
        [v setDelegate:self];
        
        return v;
        
    }
    
    if (index == 3) {
        
        AYServiceChooseView *v = [[AYServiceChooseView alloc] init];
        
        [v setDelegate:self];
        
        return v;
        
    }
    
    AYNameInputView *v = [[AYNameInputView alloc] init];
    
    return v;
    
    
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    
    return 4;
    
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarH - kStatusBarH);
    
}

- (void)updateName:(NSString *)name andBrand:(NSString *)brand {
    
    userName = name;
    
    brandName = brand;
    
    NSNumber* right_enable = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
}

- (void)updateCity:(NSString *)city {
    
    cityName = city;
    
    NSNumber* right_enable = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
}

- (void)updatePhone:(NSString *)phone valid:(Boolean)value {
    
    if (value) {
        
        phoneNumber = phone;
        
    }
    NSNumber* right_enable = [NSNumber numberWithBool:value];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
}

- (void)tipTapped {
    
    AYViewController *des = DEFAULTCONTROLLER(@"Tip");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    
    id<AYCommand> cmd = SHOWMODULEUP;
    [cmd performWithResult:&dic];
    
}

- (void)updateCategory:(NSString *)s {
    
    if (![s isEqual:@""]) {
        
        NSNumber* right_enable = [NSNumber numberWithBool:YES];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
        
        category = s;
        
    }else {
        
        NSNumber* right_enable = [NSNumber numberWithBool:NO];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
