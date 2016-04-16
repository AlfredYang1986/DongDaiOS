//
//  AYFoundSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundSearchController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

#import "AYDongDaSegDefines.h"

#define STATUS_HEIGHT   20

#define SEARCH_BAR_HEIGHT               44
#define SEG_BAR_HEIGHT                  44
#define MARGIN                          8

#define CANCEL_BTN_WIDTH                70
#define CANCEL_BTN_WIDTH_WITH_MARGIN    70
#define STATUS_BAR_HEIGHT               20
#define TAB_BAR_HEIGHT                  0 //49

@implementation AYFoundSearchController
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

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
    
    offset_y += SEARCH_BAR_HEIGHT;
    offset_y += SEG_BAR_HEIGHT + MARGIN;
    view.frame = CGRectMake(0, offset_y, width, height - offset_y - TAB_BAR_HEIGHT);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
    
    view.frame = CGRectMake(0, offset_y, width, SEARCH_BAR_HEIGHT);
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"搜索标签和角色";
    [cmd_place_hold performWithResult:&place_holder];
    
    id<AYCommand> cmd_apperence = [((id<AYViewBase>)view).commands objectForKey:@"foundSearchBar"];
    [cmd_apperence performWithResult:nil];
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
    
    offset_y += SEARCH_BAR_HEIGHT;
    view.frame = CGRectMake(0, offset_y, width, SEG_BAR_HEIGHT);
    
//    view.frame = CGRectMake(0, 0, 100, 200);
    view.backgroundColor = [UIColor whiteColor];
   
    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
    NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
    [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_0 setValue:@"标签" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_0];
    
    NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
    [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_1 setValue:@"角色" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_1];
    
    NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
    [dic_user_info setValue:[NSNumber numberWithFloat:4.f] forKey:kAYSegViewCornerRadiusKey];
    [dic_user_info setValue:[UIColor whiteColor] forKey:kAYSegViewBackgroundColorKey];
    [dic_user_info setValue:[NSNumber numberWithBool:NO] forKey:kAYSegViewLineHiddenKey];
    [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:0.15f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat found_width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, found_width, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

#pragma mark -- notifications
- (id)segValueChanged:(id)args {
    
    id<AYViewBase> seg = (id<AYViewBase>)args;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    switch (index.intValue) {
        case 0: {
            id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"FoundRoleTag"];
            
            id obj = (id)cmd_pubish;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_pubish;
            [cmd_delegate performWithResult:&obj];
        }
            break;
        case 1: {
            id<AYDelegateBase> cmd_push = [self.delegates objectForKey:@"FoundTags"];
            
            id obj = (id)cmd_push;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_push;
            [cmd_delegate performWithResult:&obj];
        }
            break;
        default:
            break;
    }
    
    id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
    [refresh performWithResult:nil];
    
    return nil;
}
@end
