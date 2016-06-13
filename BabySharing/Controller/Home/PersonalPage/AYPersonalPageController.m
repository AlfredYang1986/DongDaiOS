//
//  AYPersonalPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalPageController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#import "Tools.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

@interface AYPersonalPageController ()

@end

@implementation AYPersonalPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *view = [[UIView alloc]init];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
//    id<AYViewBase> bar = (id<AYViewBase>)view;
    UIButton* bar_left_btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 25, 25)];
    [bar_left_btn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [bar_left_btn setTitle:@"返回" forState:UIControlStateNormal];
    bar_left_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_left_btn sizeToFit];
    [bar_left_btn addTarget:self action:@selector(didPOPClick) forControlEvents:UIControlEventTouchUpInside];
    bar_left_btn.center = CGPointMake(10.5 + bar_left_btn.frame.size.width / 2, 44 / 2);
    [view addSubview:bar_left_btn];
    
//    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnWithBtn:"];
//    //    UIImage* left = PNGRESOURCE(@"bar_left_white");
//    [cmd_left performWithResult:&bar_left_btn];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 28)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"1个共同好友" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 10.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    [view addSubview:bar_right_btn];
    
    UIImageView *friendsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [friendsImage setBackgroundColor:[UIColor orangeColor]];
    friendsImage.layer.cornerRadius = 14.f;
    friendsImage.clipsToBounds = YES;
    friendsImage.center = CGPointMake( width - 10.5 - bar_right_btn.frame.size.width - 28/2, 44/2);
    [view addSubview:friendsImage];
    
    UIButton *bookBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 44)];
    [bookBtn setBackgroundColor:[Tools themeColor]];
    [bookBtn setTitle:@"立即预定" forState:UIControlStateNormal];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookBtn addTarget:self action:@selector(didBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookBtn];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    return nil;
}

//- (id)FakeNavBarLayout:(UIView*)view {
//
////    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
////    [cmd_right performWithResult:&bar_right_btn];
//    return nil;
//}

- (id)FouceScrollLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 210);
    return nil;
}
- (id)MainScrollLayout:(UIView*)view {
    CGFloat margin = 15.f;
    view.frame = CGRectMake(margin, 210, SCREEN_WIDTH - margin*2, SCREEN_HEIGHT - 210 - 44 - 10);
    
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

#pragma mark -- actions
- (void)didPOPClick{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
}

- (void)didBookBtnClick:(UIButton*)btn{
    
}

@end
