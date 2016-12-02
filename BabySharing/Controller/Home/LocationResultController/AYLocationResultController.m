//
//  AYLocationResultController.m
//  BabySharing
//
//  Created by Alfred Yang on 2/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYLocationResultController.h"
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

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>


@implementation AYLocationResultController{
    
    CLLocation *loc;
    NSString *location_name;
    AMapSearchAPI *search;
    
    NSInteger skipCount;
    
    NSMutableArray *searchResultArrWithLoc;
    NSDictionary *dic_pop;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        loc = [args objectForKey:@"location"];
        location_name = [args objectForKey:@"location_name"];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        dic_pop = [dic objectForKey:kAYControllerChangeArgsKey];
        
        //获取新的fiter条件 --> remote --> 刷新table
        id<AYViewBase> view = [self.views objectForKey:@"TimeOption"];
        id<AYCommand> cmd = [view.commands objectForKey:@"sendFiterArgs:"];
        NSDictionary *dic = [dic_pop copy];
        [cmd performWithResult:&dic];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    skipCount = 0;
    searchResultArrWithLoc = [NSMutableArray array];
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"LocationResult"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"CLResultCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
    ((UITableView*)view_table).mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    ((UITableView*)view_table).mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self loadNewData];
}

- (void)loadMoreData {

    NSDictionary* user = nil;
    CURRENUSER(user);
    
    id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
    
    NSMutableDictionary *dic_search = [user mutableCopy];
    [dic_search setValue:[NSNumber numberWithInteger:skipCount] forKey:@"skip"];
    
    NSTimeInterval timeSpan = [NSDate date].timeIntervalSince1970;
    [dic_search setValue:[NSNumber numberWithDouble:timeSpan * 1000] forKey:@"date"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (loc) {
        NSNumber *latitude = [NSNumber numberWithFloat:loc.coordinate.latitude];
        NSNumber *longtitude = [NSNumber numberWithFloat:loc.coordinate.longitude];
        [dic setValue:latitude forKey:@"latitude"];
        [dic setValue:longtitude forKey:@"longtitude"];
    }
    
    [dic_search setValue:dic forKey:@"location"];
    
    [cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand tags result %@", result);
            
            if (result.count == 0) {
                NSString *title = @"没有更多服务了";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            } else {
                skipCount += result.count;
                [searchResultArrWithLoc addObjectsFromArray:(NSArray*)result];
                id arr = [searchResultArrWithLoc copy];
                id<AYDelegateBase> del = [self.delegates objectForKey:@"LocationResult"];
                id<AYCommand> cmd = [del.commands objectForKey:@"changeQueryData:"];
                [cmd performWithResult:&arr];
                
                kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
            }
            
        } else {
            NSString *title = @"请改善网络环境并重试";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        [((UITableView*)view_table).mj_footer endRefreshing];
        
    }];
}

- (void)loadNewData {
   
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
    
    NSMutableDictionary *dic_search = [user mutableCopy];
    [dic_search setValue:[NSNumber numberWithInteger:0] forKey:@"skip"];
    
    NSTimeInterval timeSpan = [NSDate date].timeIntervalSince1970;
    [dic_search setValue:[NSNumber numberWithDouble:timeSpan * 1000] forKey:@"date"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (loc) {
        NSNumber *latitude = [NSNumber numberWithFloat:loc.coordinate.latitude];
        NSNumber *longtitude = [NSNumber numberWithFloat:loc.coordinate.longitude];
        [dic setValue:latitude forKey:@"latitude"];
        [dic setValue:longtitude forKey:@"longtitude"];
    }
    
    [dic_search setValue:dic forKey:@"location"];
    
    [cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand tags result %@", result);
            
            skipCount = result.count;
            
            searchResultArrWithLoc = [(NSArray*)result mutableCopy];
            id arr = (NSArray*)result;
            id<AYDelegateBase> del = [self.delegates objectForKey:@"LocationResult"];
            id<AYCommand> cmd = [del.commands objectForKey:@"changeQueryData:"];
            [cmd performWithResult:&arr];
            
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
            
        } else {
            NSString *title = @"请改善网络环境并重试";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        [((UITableView*)view_table).mj_header endRefreshing];
        
    }];
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
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = location_name;
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnImg:"];
    UIImage* right = IMGRESOURCE(@"map_icon");
    [cmd_right performWithResult:&right];
    
    UIButton *fiterBtn = [[UIButton alloc]init];
    [fiterBtn setImage:IMGRESOURCE(@"fiter_icon") forState:UIControlStateNormal];
    [view addSubview:fiterBtn];
    [fiterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-50);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    [fiterBtn addTarget:self action:@selector(didFiterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    fiterBtn.hidden = YES;
    
    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    [cmd_bot performWithResult:nil];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    view.backgroundColor = [Tools garyBackgroundColor];
    return nil;
}

- (id)TimeOptionLayout:(UIView*)view {
    CGFloat margin = 15.f;
    view.frame = CGRectMake(margin, 64 + 10, SCREEN_WIDTH - margin * 2, view.frame.size.height);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

#pragma mark -- actions
- (void)didFiterBtnClick:(UIButton*)btn {
    AYViewController* des = DEFAULTCONTROLLER(@"SearchFilter");
    UINavigationController * nav = CONTROLLER(@"DefaultController", @"Navigation");
    [nav pushViewController:des animated:NO];
    [des.navigationController setNavigationBarHidden:YES];
   
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic_push setValue:nav forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:userId forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = SHOWMODULEUP;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
    [args setValue:loc forKey:@"location"];
    [args setValue:[searchResultArrWithLoc copy] forKey:@"result_data"];
    id<AYCommand> des = DEFAULTCONTROLLER(@"Map");
    
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    [dic_show_module setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic_show_module];
    
    return nil;
}

-(id)ownerIconTap:(NSString *)userId{
    
    AYViewController* des = DEFAULTCONTROLLER(@"OneProfile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:userId forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}
@end
