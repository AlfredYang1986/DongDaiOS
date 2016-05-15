//
//  AYFriendController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/13/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFriendsController.h"
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

#define SEARCH_BAR_HEIGHT           0 //44
#define SEGAMENT_HEGHT              46

#define SEARCH_BAR_MARGIN_TOP       0
#define SEARCH_BAR_MARGIN_BOT       -2

#define SEGAMENT_MARGIN_BOTTOM      10.5
#define BOTTOM_BAR_HEIGHT           49

static NSString* const kAYFriendsControllerCommentsTableValue = @"Table";
static NSString* const kAYFriendsControllerFriendsTableValue = @"Table2";
static NSString* const kAYFriendsControllerNavSegValue = @"DongDaSeg";
static NSString* const kAYFriendsControllerFriendsSegValue = @"DongDaSeg2";
static NSString* const kAYFriendsControllerAddFriendsValue = @"AddFriends";

@implementation AYFriendsController {
    CALayer* line_friend_up;
}

#pragma mark -- functions
#define SHOWING_FRIENDS     [self showData:@"isFriendsDataReady" changFunc:@"changeFriendsData:" queryFunc:@"QueryFriends" resultKey:@"friends"]
#define SHOWING_FOLLOWING   [self showData:@"isFollowingDataReady" changFunc:@"changeFollowingData:" queryFunc:@"QueryFollowing" resultKey:@"following"]
#define SHOWING_FOLLOWED    [self showData:@"isFollowedDataReady" changFunc:@"changeFollowedData:" queryFunc:@"QueryFollowed" resultKey:@"followed"]
- (void)showData:(NSString*)ready_func_name changFunc:(NSString*)change_func_name queryFunc:(NSString*)query_func_name resultKey:(NSString*)result_key {

    id<AYViewBase> view_friend = [self.views objectForKey:kAYFriendsControllerFriendsTableValue];
    id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"UserRelations"];
    
//    id<AYCommand> cmd_is_ready = [cmd_relations.commands objectForKey:ready_func_name];
//    NSNumber* isReady = nil;
//    [cmd_is_ready performWithResult:&isReady];
    
    id<AYViewBase> view_friend_seg = [self.views objectForKey:kAYFriendsControllerFriendsSegValue];
    id<AYCommand> cmd = [view_friend_seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    NSLog(@"current index %@", index);
    
    id<AYCommand> cmd_change_index = [cmd_relations.commands objectForKey:@"resetCurrentShowingIndex:"];
    [cmd_change_index performWithResult:&index];
    
//    if (isReady.boolValue != YES)
    {
        id<AYFacadeBase> f_login_model = LOGINMODEL;
        id<AYCommand> cmd = [f_login_model.commands objectForKey:@"QueryCurrentLoginUser"];
        id obj = nil;
        [cmd performWithResult:&obj];
        NSLog(@"current login user is %@", obj);
        NSString* owner_id = [obj objectForKey:@"user_id"];
        {
            id<AYFacadeBase> f = [self.facades objectForKey:@"RelationshipRemote"];
            AYRemoteCallCommand* cmd = [f.commands objectForKey:query_func_name];
            
            NSMutableDictionary* dic = [obj mutableCopy];
            [dic setValue:owner_id forKey:@"owner_id"];
            
            [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                
                if (success) {
                    NSArray* reVal = [result objectForKey:result_key];
                   
                    id<AYFacadeBase> f_profile = [self.facades objectForKey:@"ProfileRemote"];
                    AYRemoteCallCommand* cmd_profile = [f_profile.commands objectForKey:@"QueryMultipleUsers"];
                    
                    NSMutableArray* ma = [[NSMutableArray alloc]initWithCapacity:reVal.count];
                    for (NSDictionary* iter in reVal) {
                        [ma addObject:[iter objectForKey:@"user_id"]];
                    }
                    
                    NSMutableDictionary* profile_dic = [obj mutableCopy];
                    [profile_dic setObject:[ma copy] forKey:@"query_list"];
                    
                    [cmd_profile performWithResult:[profile_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                         id<AYCommand> cmd = [cmd_relations.commands objectForKey:change_func_name];
                        [cmd performWithResult:&result];
                        
                        id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
                        [cmd_refresh performWithResult:nil];
                    }];
                
                } else {
                    NSLog(@"query user relations error");
                }
            }];
        }
    }
//        else {
//        id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
//        [cmd_refresh performWithResult:nil];
//    }
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
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    line_friend_up = [CALayer layer];
    line_friend_up.borderWidth = 1.f;
    line_friend_up.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.18].CGColor;
    line_friend_up.frame = CGRectMake(0, 74 + SEARCH_BAR_MARGIN_TOP + SEARCH_BAR_HEIGHT + SEARCH_BAR_MARGIN_BOT + SEGAMENT_HEGHT + SEGAMENT_MARGIN_BOTTOM, width, 1);
    line_friend_up.hidden = YES;
    [self.view.layer addSublayer:line_friend_up];
    
    CALayer* line_seg = [CALayer layer];
    line_seg.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line_seg.borderWidth = 1.f;
    line_seg.frame = CGRectMake(0, SEGAMENT_HEGHT - 1, width, 1);
    UIView* friend_seg = [self.views objectForKey:kAYFriendsControllerFriendsSegValue];
    [friend_seg.layer addSublayer:line_seg];
    
    CALayer* line_seg_up = [CALayer layer];
    line_seg_up.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.18].CGColor;
    line_seg_up.borderWidth = 1.f;
    line_seg_up.frame = CGRectMake(0, 0, width, 1);
    [friend_seg.layer addSublayer:line_seg_up];

    {
        id<AYViewBase> view_notify = [self.views objectForKey:kAYFriendsControllerCommentsTableValue];
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Notification"];

        id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];

        id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYNotificationCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name];
        
        id<AYFacadeBase> f = CHATSESSIONMODEL;
        id<AYCommand> cmd_query_notify = [f.commands objectForKey:@"QueryNotifications"];
        NSArray* notifies = nil;
        [cmd_query_notify performWithResult:&notifies];
        
        id<AYCommand> cmd = [cmd_notify.commands objectForKey:@"changeQueryData:"];
        [cmd performWithResult:&notifies];
    }
    
    {
        id<AYViewBase> view_friend = [self.views objectForKey:kAYFriendsControllerFriendsTableValue];
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"UserRelations"];

        id<AYCommand> cmd_datasource = [view_friend.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_friend.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_relations;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_relations;
        [cmd_delegate performWithResult:&obj];

        id<AYCommand> cmd_hot_cell = [view_friend.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserDisplayTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];
    }

    SHOWING_FRIENDS;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIView* seg = [self.views objectForKey:kAYFriendsControllerNavSegValue];
    [self.navigationController.navigationBar addSubview:seg];
   
    UIView* btn =[self.views objectForKey:kAYFriendsControllerAddFriendsValue];
    [self.navigationController.navigationBar addSubview:btn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIView* seg = [self.views objectForKey:kAYFriendsControllerNavSegValue];
    [seg removeFromSuperview];
   
    UIView* btn =[self.views objectForKey:kAYFriendsControllerAddFriendsValue];
    [btn removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark -- layout commands
- (id)TableLayout:(UIView*)view {
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat offset_x = 0;
    CGFloat offset_y = 10; //20 + 44 + 10;
    
    view.frame = CGRectMake(offset_x, offset_y, width, height - offset_y - BOTTOM_BAR_HEIGHT - 64);
    view.backgroundColor = [UIColor whiteColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)Table2Layout:(UIView*)view {
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat offset_x = 0;
    CGFloat offset_y = 0;
    
    offset_x += width;
    offset_y += /*20 + 44 +*/ 10 + SEARCH_BAR_MARGIN_TOP + SEARCH_BAR_HEIGHT + SEARCH_BAR_MARGIN_BOT + SEGAMENT_HEGHT + SEGAMENT_MARGIN_BOTTOM;
    CGFloat height_last = height - offset_y - BOTTOM_BAR_HEIGHT - 64;
    
    view.frame = CGRectMake(offset_x, offset_y, width, height_last);
    view.backgroundColor = [UIColor whiteColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
   
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    {
        id<AYViewBase> seg = (id<AYViewBase>)view;
        id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
        
        id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
        NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
        [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_0 setValue:@"动态" forKey:kAYSegViewTitleKey];
        [cmd_add_item performWithResult:&dic_add_item_0];
        
        NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
        [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_1 setValue:@"好友" forKey:kAYSegViewTitleKey];
        [cmd_add_item performWithResult:&dic_add_item_1];
        
        NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
        [dic_user_info setValue:[NSNumber numberWithFloat:0.2933f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
        
        [cmd_info performWithResult:&dic_user_info];
    }
    view.frame = CGRectMake(0, 0, width, 44);
    
    return nil;
}

- (id)DongDaSeg2Layout:(UIView*)view {
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat offset_x = 0;
    CGFloat offset_y = 0;
    
    offset_x += width;
    offset_y += /*20 + 44 +*/ 10 + SEARCH_BAR_MARGIN_TOP + SEARCH_BAR_HEIGHT + SEARCH_BAR_MARGIN_BOT;
    view.frame = CGRectMake(offset_x, offset_y, width, SEGAMENT_HEGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    {
        id<AYViewBase> seg = [self.views objectForKey:kAYFriendsControllerFriendsSegValue];
        id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
        
        NSMutableDictionary* dic_reset_lay = [[NSMutableDictionary alloc]init];
        [dic_reset_lay setValue:[NSNumber numberWithBool:YES] forKey:kAYSegViewLineHiddenKey];
        [cmd_info performWithResult:&dic_reset_lay];
        
        id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
        NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
        [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_0 setValue:@"好友" forKey:kAYSegViewTitleKey];
        [cmd_add_item performWithResult:&dic_add_item_0];
        
        NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
        [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_1 setValue:@"关注" forKey:kAYSegViewTitleKey];
        [cmd_add_item performWithResult:&dic_add_item_1];
        
        NSMutableDictionary* dic_add_item_2 = [[NSMutableDictionary alloc]init];
        [dic_add_item_2 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_2 setValue:@"粉丝" forKey:kAYSegViewTitleKey];
        [cmd_add_item performWithResult:&dic_add_item_2];
        
        NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
        [dic_user_info setValue:[NSNumber numberWithInt:14.f] forKey:kAYSegViewSelectedFontSizeKey];
        [dic_user_info setValue:[UIColor colorWithWhite:0.4667 alpha:1.f] forKey:kAYSegViewNormalFontColorKey];
        [dic_user_info setValue:[NSNumber numberWithBool:YES] forKey:kAYSegViewLineHiddenKey];
        [dic_user_info setValue:[NSNumber numberWithFloat:0.05* [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
        [cmd_info performWithResult:&dic_user_info];
        
    }
    
    return nil;
}

- (id)AddFriendsLayout:(UIView*)view {
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    {
        view.frame = CGRectMake(width - 23 - 25, 0, 50, 50);
        
        CALayer* layer = [CALayer layer];
        layer.contents = (id)PNGRESOURCE(@"friend_add").CGImage;
        
        layer.frame = CGRectMake(0, 0, 25, 25);
        layer.position = CGPointMake(25, 25);
        [view.layer addSublayer:layer];
    }
    
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, height);
    return nil;
}

#pragma mark -- notification
- (id)segValueChanged:(id)obj {
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    id<AYViewBase> view_friend_seg = [self.views objectForKey:kAYFriendsControllerFriendsSegValue];
    
    id<AYViewBase> seg = (id<AYViewBase>)obj;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    NSLog(@"current index %@", index);
    
    if (seg == view_friend_seg) {

        switch (index.intValue) {
            case 0:
                SHOWING_FRIENDS;
                break;
            case 1:
                SHOWING_FOLLOWING;
                break;
            case 2:
                SHOWING_FOLLOWED;
                break;
            default:
                break;
        }
        
    } else {
        CGFloat step = 0;
        if (index.intValue == 0)
            step = width;
        else
            step = -width;
        
        id<AYViewBase> btn = [self.views objectForKey:kAYFriendsControllerAddFriendsValue];
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView* view in self.views.allValues) {
                if (view != (UIView*)btn && view != (UIView*)seg) {
                    view.center = CGPointMake(view.center.x + step, view.center.y);
                }
            }
        }];
    }
    
    return nil;
}

- (id)touchUpInside {
    NSLog(@"add friends btn selected");
    
    id<AYCommand> AddFriend = DEFAULTCONTROLLER(@"AddFriend");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:AddFriend forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [self performWithResult:&dic];
    
    return nil;
}

- (id)XMPPReceiveMessage:(id)message {
    id<AYViewBase> view_notify = [self.views objectForKey:kAYFriendsControllerCommentsTableValue];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Notification"];
    
    id<AYFacadeBase> f = CHATSESSIONMODEL;
    id<AYCommand> cmd_query_notify = [f.commands objectForKey:@"QueryNotifications"];
    NSArray* notifies = nil;
    [cmd_query_notify performWithResult:&notifies];
    
    id<AYCommand> cmd = [cmd_notify.commands objectForKey:@"changeQueryData:"];
    [cmd performWithResult:&notifies];
    
    id<AYCommand> cmd_refresh = [view_notify.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
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
