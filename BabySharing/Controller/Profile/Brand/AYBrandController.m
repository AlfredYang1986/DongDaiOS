//
//  AYBrandController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYBrandController.h"
#import "AYBrandView.h"

@interface AYBrandController ()

@end

@implementation AYBrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AYBrandView *brandView = [[AYBrandView alloc] init];
    
    [self.view addSubview:brandView];
    
    [brandView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kNavBarH + kStatusBarH);
        
    }];
    
   
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
    
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor garyBackground];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSString *title = @"我的品牌";
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    
    
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
