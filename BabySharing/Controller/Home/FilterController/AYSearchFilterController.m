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
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "Tools.h"
#import "AYSearchFilterCellDefines.h"
#import "AYCommandDefines.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

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
    btn.backgroundColor = [UIColor redColor];
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
        NSString* str = @"重置";
        id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"setRightBtnWithTitle:"];
        [cmd performWithResult:&str];
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

#pragma mark -- btn handle
- (void)searchBtnSelected {
    NSLog(@"search");
}
@end