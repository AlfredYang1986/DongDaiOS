//
//  AYSearchFilterController.m
//  BabySharing
//
//  Created by BM on 8/31/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterController.h"

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
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#import "AYSearchFilterCellDefines.h"
#import "AYCommandDefines.h"

#define STATUS_HEIGHT           20
#define NAV_HEIGHT              45

#define BOM_BTN_MARGIN          10
#define BOM_BTN_HEIGHT          45
#define BOM_BTN_RADIUS          4.f

@implementation AYSearchFilterController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        id args = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        id args = [dic objectForKey:kAYControllerChangeArgsKey];
        
        id<AYDelegateBase> cmd_delegate = [self.delegates objectForKey:@"SearchFilter"];
        id<AYCommand> cmd_change_data = [cmd_delegate.commands objectForKey:@"changeQueryData:"];
        [cmd_change_data performWithResult:&args];
        
        id<AYViewBase> table = [self.views objectForKey:@"Table"];
        id<AYCommand> refresh = [table.commands objectForKey:@"refresh"];
        [refresh performWithResult:nil];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    /**
     * 搜索按钮
     */
    UIButton* btn = [[UIButton alloc]init];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
   
    [self.view addSubview:btn];
    btn.frame = CGRectMake(BOM_BTN_MARGIN, SCREEN_HEIGHT - BOM_BTN_MARGIN - BOM_BTN_HEIGHT, SCREEN_WIDTH - 2 * BOM_BTN_MARGIN, BOM_BTN_HEIGHT);
    btn.backgroundColor = [Tools themeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:BOM_BTN_RADIUS];
    
    [btn addTarget:self action:@selector(searchBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    
    {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SearchFilter"];
        
        id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYSearchFilterCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name];
    }
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_HEIGHT + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - BOM_BTN_MARGIN * 2 - BOM_BTN_HEIGHT - NAV_HEIGHT - STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    [(UITableView*)view setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, NAV_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];

    {
        UIImage* img = IMGRESOURCE(@"content_close");
        id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"setLeftBtnImg:"];
        [cmd performWithResult:&img];
    }
   
    {
        id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"setRightBtnWithBtn:"];
        UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        [bar_right_btn setTitle:@"重置" forState:UIControlStateNormal];
        bar_right_btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.f];
        [bar_right_btn sizeToFit];
        bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
        [cmd performWithResult:&bar_right_btn];
    }
    return nil;
}

#pragma mark -- commands
- (id)leftBtnSelected {
    id<AYCommand> cmd = REVERSMODULE;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    // TODO : reset search filter conditions
    return nil;
}

#pragma mark -- notification
- (id)filterKidsAges:(id)args {
    UIView* table = [self.views objectForKey:@"Table"];
    UIView* cell = (UIView*)args;
    CGFloat height = cell.layer.frame.origin.y + cell.layer.frame.size.height + table.frame.origin.y;

    AYViewController* des = DEFAULTCONTROLLER(@"SearchFilterKidsAges");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushSplitValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithFloat:height] forKey:kAYControllerSplitHeightKey];
    
    id<AYCommand> cmd = PUSHSPLIT;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)filterDate:(id)args {
    UIView* table = [self.views objectForKey:@"Table"];
    UIView* cell = (UIView*)args;
    CGFloat height = cell.layer.frame.origin.y + cell.layer.frame.size.height + table.frame.origin.y;
    
    AYViewController* des = DEFAULTCONTROLLER(@"SearchFilterDate");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushSplitValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithFloat:height] forKey:kAYControllerSplitHeightKey];
    
    id<AYCommand> cmd = PUSHSPLIT;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)filterType:(id)args {
    UIView* table = [self.views objectForKey:@"Table"];
    UIView* cell = (UIView*)args;
    CGFloat height = cell.layer.frame.origin.y + cell.layer.frame.size.height + table.frame.origin.y;
    
    AYViewController* des = DEFAULTCONTROLLER(@"SearchFilterType");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushSplitValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithFloat:height] forKey:kAYControllerSplitHeightKey];
    
    id<AYCommand> cmd = PUSHSPLIT;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)filterPriceRange:(id)args {
    UIView* table = [self.views objectForKey:@"Table"];
    UIView* cell = (UIView*)args;
    CGFloat height = cell.layer.frame.origin.y + cell.layer.frame.size.height + table.frame.origin.y;

    AYViewController* des = DEFAULTCONTROLLER(@"SearchFilterPriceRange");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushSplitValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithFloat:height] forKey:kAYControllerSplitHeightKey];
    
    id<AYCommand> cmd = PUSHSPLIT;
    [cmd performWithResult:&dic_push];
    return nil;
}

#pragma mark -- btn handle
- (void)searchBtnSelected {
    NSLog(@"search");
}
@end
