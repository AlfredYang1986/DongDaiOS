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

@implementation AYPersonalPageController{
    NSDictionary *personal_info;
    UIButton *shareBtn;
    UIButton *collectionBtn;
}
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        personal_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServicePage"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYViewBase> main_scroll = [self.views objectForKey:@"MainScroll"];
    id<AYCommand> cmd = [main_scroll.commands objectForKey:@"setPersonalInfo:"];
    NSDictionary *dic_info = personal_info;
    [cmd performWithResult:&dic_info];
    
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
    [self.view bringSubviewToFront:(UINavigationBar*)navBar];
    ((UINavigationBar*)navBar).hidden = YES;
    
    shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:IMGRESOURCE(@"service_share") forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    [self.view bringSubviewToFront:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-25);
        make.centerY.equalTo(self.view.mas_top).offset(225);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    [shareBtn addTarget:self action:@selector(didShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    collectionBtn = [[UIButton alloc]init];
    [collectionBtn setImage:IMGRESOURCE(@"service_collection") forState:UIControlStateNormal];
    [self.view addSubview:collectionBtn];
    [self.view bringSubviewToFront:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareBtn.mas_left).offset(-20);
        make.centerY.equalTo(shareBtn);
        make.size.equalTo(shareBtn);
    }];
    [collectionBtn addTarget:self action:@selector(didCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bookBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [bookBtn setBackgroundColor:[Tools themeColor]];
    [bookBtn setTitle:@"预定" forState:UIControlStateNormal];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookBtn addTarget:self action:@selector(didBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookBtn];
    [self.view bringSubviewToFront:bookBtn];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor orangeColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    id right = [NSNumber numberWithBool:YES];
    [cmd_right performWithResult:&right];
    
    UIButton *bar_publich_btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10.5 - 50, 25, 50, 30)];
    [bar_publich_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_publich_btn setTitle:@"分享" forState:UIControlStateNormal];
    bar_publich_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [bar_publich_btn setBackgroundImage:[Tools imageWithColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.F] size:CGSizeMake(bar_publich_btn.bounds.size.width, bar_publich_btn.bounds.size.height)] forState:UIControlStateNormal];
    [bar_publich_btn setBackgroundImage:[Tools imageWithColor:[UIColor darkGrayColor] size:CGSizeMake(bar_publich_btn.bounds.size.width, bar_publich_btn.bounds.size.height)] forState:UIControlStateDisabled];
    bar_publich_btn.layer.cornerRadius = 4.f;
    bar_publich_btn.clipsToBounds = YES;
    bar_publich_btn.center = CGPointMake(SCREEN_WIDTH - 10 - bar_publich_btn.frame.size.width / 2, 44 / 2);
    [view addSubview:bar_publich_btn];
    bar_publich_btn.enabled = NO;
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    
    [self.view sendSubviewToBack:view];
    return nil;
}

//- (id)FouceScrollLayout:(UIView*)view {
//    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 225);
//    
//    [self.view sendSubviewToBack:view];
//    return nil;
//}
//
//- (id)MainScrollLayout:(UIView*)view {
//    CGFloat margin = 15.f;
//    view.frame = CGRectMake(margin, 225, SCREEN_WIDTH - margin*2, SCREEN_HEIGHT - 225 - 44);
//    return nil;
//}

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

-(id)sendPopMessage{
    [self leftBtnSelected];
    return nil;
}

-(id)scrollOffsetY:(NSNumber*)y{
    
    [shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-25);
        make.centerY.equalTo(self.view.mas_top).offset(225 - y.floatValue);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    [collectionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareBtn.mas_left).offset(-20);
        make.centerY.equalTo(shareBtn);
        make.size.equalTo(shareBtn);
    }];
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
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"该服务正在准备'~_~'" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
}

-(void)didShareBtnClick:(UIButton*)btn{
    
}

-(void)didCollectionBtnClick:(UIButton*)btn{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
@end
