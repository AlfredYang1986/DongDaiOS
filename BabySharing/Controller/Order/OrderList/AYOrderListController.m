//
//  AYOrderListController.m
//  BabySharing
//
//  Created by Alfred Yang on 25/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderListController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYDongDaSegDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYUserDisplayDefines.h"
#import "AYNotificationCellDefines.h"

#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height

#define SEGAMENT_HEGHT              46

#define SEARCH_BAR_MARGIN_BOT       -2

#define SEGAMENT_MARGIN_BOTTOM      10.5
#define BOTTOM_BAR_HEIGHT           49

@implementation AYOrderListController {
    CALayer* line_friend_up;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* loading = [self.views objectForKey:@"Loading"];
    loading.hidden = YES;
    [self.view bringSubviewToFront:loading];
    
    line_friend_up = [CALayer layer];
    line_friend_up.borderWidth = 1.f;
    line_friend_up.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.18].CGColor;
    line_friend_up.frame = CGRectMake(0, 74 + SEARCH_BAR_MARGIN_BOT + SEGAMENT_HEGHT + SEGAMENT_MARGIN_BOTTOM, SCREEN_WIDTH, 1);
    line_friend_up.hidden = YES;
    [self.view.layer addSublayer:line_friend_up];
    
    
    {
        id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrder"];
        
        id<AYCommand> cmd_datasource = [view_future.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_future.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_future.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name];
        
    }
    
    {
        id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"PastOrder"];
        
        id<AYCommand> cmd_datasource = [view_past.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_past.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_relations;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_relations;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_hot_cell = [view_past.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];
    }
    
    UIButton *personal = [[UIButton alloc]init];
    personal.hidden = YES;
    [personal setTitle:@"我的订单" forState:UIControlStateNormal];
    personal.backgroundColor = [Tools themeColor];
    [self.view addSubview:personal];
    [personal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-60);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    [personal addTarget:self action:@selector(didPushInfo) forControlEvents:UIControlEventTouchUpInside];
}
-(void)didPushInfo{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES];
    
    UIView* seg = [self.views objectForKey:@"DongDaSeg"];
    [self.navigationController.navigationBar addSubview:seg];
    
    UIView* btn = [self.views objectForKey:@"AddFriends"];
    [self.navigationController.navigationBar addSubview:btn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIView* seg = [self.views objectForKey:@"DongDaSeg"];
    [seg removeFromSuperview];
    UIView* btn = [self.views objectForKey:@"AddFriends"];
    [btn removeFromSuperview];
}

#pragma mark -- layout commands
- (id)TableLayout:(UIView*)view {
    CGFloat offset_x = 0;
    CGFloat offset_y = 10;
    
    view.frame = CGRectMake(offset_x, offset_y, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)Table2Layout:(UIView*)view {
    CGFloat offset_y = 10;
    
    view.frame = CGRectMake(SCREEN_WIDTH, offset_y, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
    NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
    [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_0 setValue:@"将至订单" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_0];
    
    NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
    [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_1 setValue:@"过往订单" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_1];
    
    NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
    [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:0.25f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

- (id)AddFriendsLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, 50, 50);
    
    CALayer* layer = [CALayer layer];
    layer.contents = (id)IMGRESOURCE(@"bar_left_black").CGImage;
    layer.frame = CGRectMake(0, 0, 25, 25);
    layer.position = CGPointMake(25, 25);
    [view.layer addSublayer:layer];
    
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- notification
- (id)segValueChanged:(id)obj {
    id<AYViewBase> seg = (id<AYViewBase>)obj;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    NSLog(@"current index %@", index);
    
    CGFloat step = 0;
    if (index.intValue == 0)
        step = SCREEN_WIDTH;
    else
        step = -SCREEN_WIDTH;

    id<AYViewBase> btn = [self.views objectForKey:@"AddFriends"];
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView* view in self.views.allValues) {
            if (view != (UIView*)btn && view != (UIView*)seg) {
                view.center = CGPointMake(view.center.x + step, view.center.y);
            }
        }
    }];
    return nil;
}

- (id)touchUpInside {
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)startRemoteCall:(id)obj {
    
    NSString* method = (NSString*)obj;
    if ([method containsString:@"QueryMultipleUsers"]
        || [method containsString:@"QueryFriends"]
        || [method containsString:@"QueryFollowing"]
        || [method containsString:@"QueryFollowed"]) {
        
        if (![method containsString:@"QueryMultipleUsers"]) {
            UIView* loading_view = [self.views objectForKey:@"Loading"];
            loading_view.hidden = YES;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"stopGif"] performWithResult:nil];
        }
        
    } else {
        return [super startRemoteCall:obj];
    }
    
    return nil;
}

- (id)endRemoteCall:(id)obj {
    
    NSString* method = (NSString*)obj;
    if ([method containsString:@"QueryMultipleUsers"]
        || [method containsString:@"QueryFriends"]
        || [method containsString:@"QueryFollowing"]
        || [method containsString:@"QueryFollowed"]) {
        
        if ([method containsString:@"QueryMultipleUsers"]) {
            UIView* loading_view = [self.views objectForKey:@"Loading"];
            loading_view.hidden = YES;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"stopGif"] performWithResult:nil];
        }
        
    } else {
        return [super endRemoteCall:obj];
    }
    
    return nil;
}
//michauxs:scrollToHideKeyBoard
- (id)scrollToHideKeyBoard {
    return nil;
}

@end
