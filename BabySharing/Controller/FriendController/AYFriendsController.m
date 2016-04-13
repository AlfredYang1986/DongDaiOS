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

@implementation AYFriendsController
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

#pragma mark -- layout commands
- (id)TableLayout:(UIView*)view {
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat offset_x = 0;
    CGFloat offset_y = 10; //20 + 44 + 10;
    
    view.frame = CGRectMake(offset_x, offset_y, width, height - offset_y - BOTTOM_BAR_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)Table2Layout:(UIView*)view {
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat offset_x = 0;
    CGFloat offset_y = 0;
    
    offset_x += width;
    offset_y += /*20 + 44 +*/ 10 + SEARCH_BAR_MARGIN_TOP + SEARCH_BAR_HEIGHT + SEARCH_BAR_MARGIN_BOT + SEGAMENT_HEGHT + SEGAMENT_MARGIN_BOTTOM;
    CGFloat height_last = height - offset_y - BOTTOM_BAR_HEIGHT;
    
    view.frame = CGRectMake(offset_x, offset_y, width, height_last);
    view.backgroundColor = [UIColor whiteColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
   
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    {
        id<AYViewBase> seg = (id<AYViewBase>)view; //[self.views objectForKey:kAYFriendsControllerNavSegValue];
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
        [dic_user_info setValue:[NSNumber numberWithInt:14.f] forKey:kAYSegViewNormalFontColorKey];
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

#pragma mark -- notification
- (id)segValueChanged:(id)obj {
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
   
   
    id<AYViewBase> view_friend_seg = [self.views objectForKey:kAYFriendsControllerFriendsSegValue];
    
    id<AYViewBase> seg = (id<AYViewBase>)obj;
    
    if (seg == view_friend_seg) {

    } else {
        id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
        NSNumber* index = nil;
        [cmd performWithResult:&index];
        NSLog(@"current index %@", index);
        
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
    return nil;
}
@end
