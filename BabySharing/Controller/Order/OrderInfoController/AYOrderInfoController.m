//
//  AYOrderInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 28/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoController.h"
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

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@implementation AYOrderInfoController{
    NSMutableArray *loading_status;
    
    UIImageView *orderImage;
    UILabel *orderTitle;
    UILabel *orderOwner;
    UILabel *orderLoc;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        //        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        id<AYViewBase> view = [self.views objectForKey:@"TimeOption"];
        id<AYCommand> cmd = [view.commands objectForKey:@"sendFiterArgs:"];
        NSDictionary *dic = [args copy];
        [cmd performWithResult:&dic];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
//    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
//    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
//    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
//    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderInfo"];
//    
//    id obj = (id)cmd_recommend;
//    [cmd_datasource performWithResult:&obj];
//    obj = (id)cmd_recommend;
//    [cmd_delegate performWithResult:&obj];
//    /****************************************/
//    id<AYCommand> cmd_head = [view_table.commands objectForKey:@"registerCellWithClass:"];
//    NSString* head_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//    [cmd_head performWithResult:&head_name];
//    
//    id<AYCommand> cmd_nib = [view_table.commands objectForKey:@"registerCellWithNib:"];
//    NSString* nib_contact_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//    [cmd_nib performWithResult:&nib_contact_name];
//    /****************************************/
    
    UIView *headView = [[UIView alloc]init];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
    }];
    
    orderImage = [[UIImageView alloc]init];
    [headView addSubview:orderImage];
    orderImage.image = IMGRESOURCE(@"lol");
    [orderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).offset(15);
        make.left.equalTo(headView).offset(15);
        make.size.mas_equalTo(CGSizeMake(115, 65));
    }];
    
    orderTitle = [[UILabel alloc]init];
    orderTitle = [Tools setLabelWith:orderTitle andText:@"服务订单简介标题" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:0];
    [headView addSubview:orderTitle];
    [orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderImage);
        make.left.equalTo(orderImage.mas_right).offset(20);
    }];
    
    orderOwner = [[UILabel alloc]init];
    orderOwner = [Tools setLabelWith:orderOwner andText:@"服务妈妈 杨大婶" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [headView addSubview:orderOwner];
    [orderOwner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderTitle.mas_bottom).offset(5);
        make.left.equalTo(orderTitle);
    }];
    
    orderLoc = [[UILabel alloc]init];
    orderLoc = [Tools setLabelWith:orderLoc andText:@"北京，朝阳区" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [headView addSubview:orderLoc];
    [orderLoc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderOwner.mas_bottom).offset(10);
        make.left.equalTo(orderTitle);
    }];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [Tools garyColor].CGColor;
    line.frame = CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5);
    [headView.layer addSublayer:line];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [self.view addSubview:confirmBtn];
    [self.view bringSubviewToFront:confirmBtn];
    confirmBtn.backgroundColor = [Tools themeColor];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    [confirmBtn addTarget:self action:@selector(didConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [Tools garyColor].CGColor;
    line.frame = CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5);
    [view.layer addSublayer:line];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"订单详情";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

- (id)TimeOptionLayout:(UIView*)view {
    CGFloat margin = 15.f;
    view.frame = CGRectMake(margin, 64 + 100 + 10, SCREEN_WIDTH - margin * 2, view.frame.size.height);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)PayOptionLayout:(UIView*)view {
    view.frame = CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT - 264);
    
//    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
//    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
//    ((UITableView*)view).showsVerticalScrollIndicator = NO;
//    ((UITableView*)view).scrollEnabled = NO;
//    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view.hidden = YES;
    return nil;
}

#pragma mark -- actions
-(void)didConfirmBtnClick:(UIButton*)btn {
    
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

- (id)rightBtnSelected {
    
    return nil;
}

- (id)didServiceDetailClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    //    NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
    //    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}

- (id)endRemoteCall:(id)obj {
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}
@end
