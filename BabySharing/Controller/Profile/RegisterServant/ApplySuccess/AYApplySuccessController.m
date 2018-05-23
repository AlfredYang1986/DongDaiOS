//
//  AYApplySuccessController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYApplySuccessController.h"
#import "AYApplySuccessView.h"



@interface AYApplySuccessController ()

@end

@implementation AYApplySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.view);
        
    }];
    
    [imageView setImage:IMGRESOURCE(@"register_servant_bg")];
    [imageView setUserInteractionEnabled:YES];
    
    
    UIImageView *left = [[UIImageView alloc] init];
    [imageView addSubview:left];
    
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(6);
        make.top.mas_equalTo(13 + kStatusBarH);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(25);
        
    }];
    
    [left setImage:IMGRESOURCE(@"bar_left_white")];
    
    [left setUserInteractionEnabled:YES];
    [left setContentMode:UIViewContentModeScaleAspectFit];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnSelected)];
    
    [left addGestureRecognizer:leftTap];
    
    
    AYApplySuccessView *successView = [[AYApplySuccessView alloc] init];
    
    [imageView addSubview:successView];
    
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(imageView);
        make.top.mas_equalTo(kNavBarH + kStatusBarH);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (void)leftBtnSelected {
    
    AYViewController *des = DEFAULTCONTROLLER(@"Profile");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    
    id<AYCommand> cmd = POPTODEST;
    
    [cmd performWithResult:&dic];
    
}

@end
