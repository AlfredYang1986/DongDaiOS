//
//  AYTipController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYTipController.h"
#import "AYTipView.h"

@interface AYTipController ()

@end

@implementation AYTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.width.mas_equalTo(16);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(14 + kStatusBarH);
        
    }];
    [imageView setImage:IMGRESOURCE(@"content_close")];
    [imageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnSelected)];
    
    [imageView addGestureRecognizer:tap];
    
    AYTipView *v = [[AYTipView alloc] init];
    
    [self.view addSubview:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(kStatusBarH + kNavBarH);
        make.left.right.bottom.equalTo(self.view);
        
    }];
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
    
}


#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = REVERSMODULE;
    [cmd performWithResult:&dic];
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
