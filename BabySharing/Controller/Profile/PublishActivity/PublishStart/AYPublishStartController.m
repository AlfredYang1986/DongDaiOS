//
//  AYPublishStartController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/11.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYPublishStartController.h"
#import "PublishStartView.h"
#import "AYShadowRadiusView.h"


@interface AYPublishStartController () {
    
    
    NSDictionary *service;
    
}

@end

@implementation AYPublishStartController


#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        service = [dic objectForKey:kAYControllerChangeArgsKey];
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor garyBackground]];
    
    UILabel *head = [UILabel creatLabelWithText:@"为以下服务发布招生" textColor:[UIColor black] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:head];
    
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(16 + kStatusBarH + kNavBarH);
        
    }];
    
    [head setFont:[UIFont boldFont:24.0f]];
    
    AYShadowRadiusView *shadowView = [[AYShadowRadiusView alloc] initWithRadius:4];
    [self.view addSubview:shadowView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(158);
        make.top.equalTo(head.mas_bottom).offset(40);
        
    }];
    
    PublishStartView *publishStartView = [[PublishStartView alloc] init];
    [shadowView addSubview:publishStartView];
    
    [publishStartView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(shadowView);
        
    }];
    
    [publishStartView.layer setCornerRadius:4];
    [publishStartView.layer setMasksToBounds:YES];
    
    [publishStartView setUp: service];
    
    UIButton *button = [UIButton creatBtnWithTitle:@"开始招生" titleColor:[UIColor white] fontSize:17.0f backgroundColor:[UIColor theme]];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(shadowView);
        
        make.top.equalTo(shadowView.mas_bottom).offset(16);
        
        make.height.mas_equalTo(56);
    }];
    
    [button.titleLabel setFont:[UIFont mediumFontSF:17.0]];
    [button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    [button.layer setCornerRadius: 4];
    [button.layer setMasksToBounds:YES];
    
    
    
    
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
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    
    
    return nil;
}

- (id)leftBtnSelected {
    
    //    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    //    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    //    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    //
    //    id<AYCommand> cmd = REVERSMODULE;
    //    [cmd performWithResult:&dic];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    
    return nil;
    
}


- (id)start {
    
    AYViewController* des = DEFAULTCONTROLLER(@"CoursePublishPrepare");
    
    NSString *category = [[service objectForKey:@"service_data"] objectForKey:@"category"];
    
    if ([category isEqualToString:@"看顾"]) {
        
        des = DEFAULTCONTROLLER(@"CarePublishPrepare");
        
    }
    
    if ([category isEqualToString:@"课程"]) {
        
        des = DEFAULTCONTROLLER(@"CoursePublishPrepare");
        
    }
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:self -> service forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
