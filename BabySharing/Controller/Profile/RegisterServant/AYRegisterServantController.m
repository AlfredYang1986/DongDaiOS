//
//  AYRegisterServantController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYRegisterServantController.h"
#import "AYShadowRadiusView.h"

@interface AYRegisterServantController ()

@end

@implementation AYRegisterServantController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.view);
        
    }];
    
    [imageView setImage:IMGRESOURCE(@"register_servant_bg")];
    [imageView setUserInteractionEnabled:YES];
    
    UILabel *title = [UILabel creatLabelWithText:nil textColor:[UIColor white246] font:[UIFont boldFont:24] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    
    [imageView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.centerY.equalTo(self.view).offset(-50);
        
    }];
    [title setNumberOfLines:2];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    [shadow setShadowBlurRadius:5];
    [shadow setShadowOffset:CGSizeMake(0, 2)];
    [shadow setShadowColor:[UIColor gary]];

    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"咚哒为0~12岁的孩子\n提供看顾和兴趣教育课程" attributes:@{NSShadowAttributeName : shadow }];
    
    [title setAttributedText:str];
    
    
    AYShadowRadiusView *shadowView = [[AYShadowRadiusView alloc] initWithRadius:28 offSet:(CGSizeMake(0, 9)) blur:3.0f color:[UIColor shadowColor]];
    [imageView addSubview:shadowView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(56);
        make.bottom.equalTo(imageView).offset(-110);
        
    }];
    
    [shadowView setBackgroundColor:[UIColor white]];
    
    [shadowView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerTapped)];
    
    [shadowView addGestureRecognizer:tap];
    
    
    
    UILabel *apply = [UILabel creatLabelWithText:@"申请获取授权账号" textColor:[UIColor blue92] font:[UIFont mediumFont:17.0f] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    
    [shadowView addSubview:apply];
    
    [apply mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(shadowView);
        
    }];

    UILabel *tip = [UILabel creatLabelWithText:@"出于对于用户安全和服务质量的保证\n该功能暂时只对有授权账号的用户开放" textColor:[UIColor white] font:[UIFont mediumFont:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentCenter];

    [imageView addSubview:tip];

    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(shadowView.mas_top).offset(-16);
    }];
    
    
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
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}


- (void)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
}


-(void)registerTapped {
    
    AYViewController *des = DEFAULTCONTROLLER(@"ApplyPrepare");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
