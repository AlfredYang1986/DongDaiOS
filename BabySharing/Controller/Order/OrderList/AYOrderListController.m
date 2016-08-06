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
    BOOL isPush;
    
    NSMutableArray *result_status_0;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        isPush = YES;
        
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
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"DongDaSeg"];
    [view_nav addSubview:(UIView*)view_title];
    [view_nav sendSubviewToBack:(UIView*)view_title];
    
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
    
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    NSDictionary* args = [info mutableCopy];
    
    if (isPush) {
        id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
        AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryApplyOrders"];
        NSMutableDictionary *dic_query = [[NSMutableDictionary alloc]init];
        [dic_query setValue:[args objectForKey:@"user_id"] forKey:@"user_id"];
        
        [cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                [self sortResultArray:result];
            }else {
                NSLog(@"query orders error: %@",result);
            }
        }];
    } else {
    
        id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
        AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOwnOrders"];
        NSMutableDictionary *dic_query = [[NSMutableDictionary alloc]init];
        [dic_query setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
        
        [cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                [self sortResultArray:result];
            }else {
                NSLog(@"query orders error: %@",result);
            }
        }];
    }
}

- (void)sortResultArray:(NSDictionary*)result{
    NSArray *resultArr = [result objectForKey:@"result"];
    
    NSPredicate *pred_2 = [NSPredicate predicateWithFormat:@"SELF.status=%d",2];
    NSArray *result_status_2 = [resultArr filteredArrayUsingPredicate:pred_2];
    
    id<AYDelegateBase> cmd_past = [self.delegates objectForKey:@"PastOrder"];
    id<AYCommand> changeData_2 = [cmd_past.commands objectForKey:@"changeQueryData:"];
    [changeData_2 performWithResult:&result_status_2];
    
    id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
    id<AYCommand> refresh_2 = [view_past.commands objectForKey:@"refresh"];
    [refresh_2 performWithResult:nil];
    
    /*****************************/
    
    NSPredicate *pred_0 = [NSPredicate predicateWithFormat:@"SELF.status=%d",0];
    result_status_0 = [NSMutableArray arrayWithArray:[resultArr filteredArrayUsingPredicate:pred_0]];
    NSPredicate *pred_1 = [NSPredicate predicateWithFormat:@"SELF.status=%d",1];
    NSArray *result_status_1 = [resultArr filteredArrayUsingPredicate:pred_1];
    if (result_status_0.count == 0) {
        result_status_0 = [NSMutableArray arrayWithArray:result_status_1];
    } else [result_status_0 arrayByAddingObjectsFromArray:result_status_1];
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrder"];
    id<AYCommand> changeData_0 = [cmd_notify.commands objectForKey:@"changeQueryData:"];
    NSArray *arr = result_status_0;
    [changeData_0 performWithResult:&arr];
    
    id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
    id<AYCommand> refresh_0 = [view_future.commands objectForKey:@"refresh"];
    [refresh_0 performWithResult:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self.navigationItem setHidesBackButton:YES];
//
//    UIView* seg = [self.views objectForKey:@"DongDaSeg"];
//    [self.navigationController.navigationBar addSubview:seg];
//    
//    UIView* btn = [self.views objectForKey:@"AddFriends"];
//    [self.navigationController.navigationBar addSubview:btn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    UIView* seg = [self.views objectForKey:@"DongDaSeg"];
//    [seg removeFromSuperview];
//    UIView* btn = [self.views objectForKey:@"AddFriends"];
//    [btn removeFromSuperview];
}

#pragma mark -- layout commands
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    if (isPush) {
        id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
        UIImage* left = IMGRESOURCE(@"bar_left_black");
        [cmd_left performWithResult:&left];
    }else {
        id<AYCommand> cmd_left_vis = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
        NSNumber* left_hidden = [NSNumber numberWithBool:YES];
        [cmd_left_vis performWithResult:&left_hidden];
    }
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat offset_x = 0;
    CGFloat offset_y = 74;
    
    view.frame = CGRectMake(offset_x, offset_y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - (isPush?0:49));
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)Table2Layout:(UIView*)view {
    CGFloat offset_y = 74;
    
    view.frame = CGRectMake(SCREEN_WIDTH, offset_y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - (isPush?0:49));
    view.backgroundColor = [UIColor clearColor];
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

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)segValueChanged:(id)obj {
    id<AYViewBase> seg = (id<AYViewBase>)obj;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    NSLog(@"current index %@", index);
    
    UIView* table = [self.views objectForKey:@"Table"];
    UIView* table2 = [self.views objectForKey:@"Table2"];
    
    if (index.intValue == 0){
        [UIView animateWithDuration:0.3 animations:^{
            table.center = CGPointMake(SCREEN_WIDTH * 0.5, table.center.y);
            table2.center = CGPointMake(SCREEN_WIDTH * 1.5, table2.center.y);
        }];
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            table.center = CGPointMake(- SCREEN_WIDTH * 0.5, table.center.y);
            table2.center = CGPointMake(SCREEN_WIDTH * 0.5, table2.center.y);
        }];
    }
    return nil;
}

- (id)updateReadState:(NSDictionary*)args{
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateOrderRead"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[args objectForKey:@"is_read"] forKey:@"is_read"];
    [dic setValue:[args objectForKey:@"order_id"] forKey:@"order_id"];
    
    [cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            NSIndexPath *indexPath = [args objectForKey:@"index_path"];
            [[result_status_0 objectAtIndex:indexPath.section] setValue:[NSNumber numberWithInt:1] forKey:@"is_read"];
            
            id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrder"];
            id<AYCommand> changeData_0 = [cmd_notify.commands objectForKey:@"changeQueryData:"];
            NSArray *arr = result_status_0;
            [changeData_0 performWithResult:&arr];
            
            id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
            id<AYCommand> refresh_0 = [view_future.commands objectForKey:@"refresh"];
            [refresh_0 performWithResult:nil];
            
        } else {
            NSLog(@"error with:%@",result);
        }
    }];
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
