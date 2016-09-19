//
//  AYGroupListController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYGroupListController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYGroupListCellDefines.h"
#import "MJRefresh.h"

#define TABLE_VIEW_TOP_MARGIN   64

@implementation AYGroupListController {
    
    NSArray* chatGroupArray_mine;
    NSArray* chatGroupArray_recommend;
//    UIView *bkView;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CGPathRef startPath;
    
    CALayer *scaleMaskLayer;
    
    UIViewController* homeVC;
    
    NSArray *conversations;
    
    UIView *view_loading;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        homeVC = [dic objectForKey:kAYControllerChangeArgsKey];
        
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
   
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    {
        id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> del = [self.delegates objectForKey:@"JoinedGroupList"];
        id<AYCommand> cmd_datasource = [view_content.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_content.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)del;
        [cmd_datasource performWithResult:&obj];
        obj = (id)del;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_content.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYGroupListCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name];
        
        UITableView *tableView = (UITableView*)view_content;
//        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        // Enter the refresh status immediately
//        [tableView.mj_header beginRefreshing];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {//todo: 聊天列表
    [super viewDidAppear:animated];
    
    if (!conversations) {
        
        id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
        id<AYCommand> cmd = [em.commands objectForKey:@"QueryEMSations"];
        
        NSDictionary *info = nil;
        CURRENUSER(info)
        
        id brige = [info objectForKey:@"user_id"];
        NSLog(@"michauxs -- %@", (NSArray*)brige);
        
        conversations = [(NSArray*)brige mutableCopy];
        //    NSArray *sastions = [(NSArray*)brige copy];
        
        [cmd performWithResult:&brige];
        
        id<AYDelegateBase> del = [self.delegates objectForKey:@"JoinedGroupList"];
        id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
        [cmd_change performWithResult:&brige];
        
        id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_refresh = [view_content.commands objectForKey:@"refresh"];
        [cmd_refresh performWithResult:nil];
        
        brige = nil;
    }
    
//    {
//        id<AYDelegateBase> del = [self.delegates objectForKey:@"JoinedGroupList"];
//        id<AYFacadeBase> f_session = [self.facades objectForKey:@"ChatSessionRemote"];
//        AYRemoteCallCommand* cmd = [f_session.commands objectForKey:@"QueryChatGroup"];
//        
//        NSDictionary* obj = nil;
//        CURRENUSER(obj);
//        
//        [cmd performWithResult:[obj copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//            if (success) {
//                NSLog(@"query chat group: %@", result);
//                
//                id<AYFacadeBase> f_chat_session = CHATSESSIONMODEL;
//                id<AYCommand> cmd = [f_chat_session.commands objectForKey:@"UpdataChatSession"];
//                
//                id args = [result copy];
//                [cmd performWithResult:&args];
//                
//                id reVal = nil;
//                id<AYCommand> cmd_query = [f_chat_session.commands objectForKey:@"QueryChatSession"];
//                [cmd_query performWithResult:&reVal];
//                
//                id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
//                [cmd_change performWithResult:&reVal];
//
//                id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
//                id<AYCommand> cmd_refresh = [view_content.commands objectForKey:@"refresh"];
//                [cmd_refresh performWithResult:nil];
//            
//            } else {
//                // TODO: error notify
//            }
//        }];
//    }
}

#pragma mark -- layouts
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
    id<AYCommand> cmd_left_vis = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    [cmd_left_vis performWithResult:&left_hidden];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    CALayer* line = [CALayer layer];
    line.frame = CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools garyColor].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"消息";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, TABLE_VIEW_TOP_MARGIN, SCREEN_WIDTH, SCREEN_HEIGHT - TABLE_VIEW_TOP_MARGIN);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

#pragma mark -- actions
- (void)loadNewData {
    id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
    id<AYCommand> cmd = [em.commands objectForKey:@"QueryEMSations"];
    
    NSDictionary *info = nil;
    CURRENUSER(info)
    
    id brige = [info objectForKey:@"user_id"];
    NSLog(@"michauxs -- %@", (NSArray*)brige);
    
    conversations = [(NSArray*)brige mutableCopy];
    
    [cmd performWithResult:&brige];
    
    id<AYDelegateBase> del = [self.delegates objectForKey:@"JoinedGroupList"];
    id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
    [cmd_change performWithResult:&brige];
    
    id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_refresh = [view_content.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
    
    [((UITableView*)view_content).mj_header endRefreshing];
}

#pragma mark -- notifies
- (id)scrollToRefresh{
    
    
    
    return nil;
}


//- (id)startRemoteCall:(id)obj {
//    id<AYViewBase> loading = VIEW(@"Loading", @"Loading");
//    view_loading = (UIView*)loading;
//    [self.view addSubview:view_loading];
//    id<AYCommand> cmd = [loading.commands objectForKey:@"startGif"];
//    [cmd performWithResult:nil];
//    return nil;
//}
//
//- (id)endRemoteCall:(id)obj {
//    [view_loading removeFromSuperview];
//    return nil;
//}
@end
