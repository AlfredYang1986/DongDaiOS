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

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height
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
    }
    
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {//todo: 聊天列表
    [super viewDidAppear:animated];
    
    id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
    id<AYCommand> cmd = [em.commands objectForKey:@"QueryEMSations"];
    
    NSDictionary *info = nil;
    CURRENUSER(info)
    
    id brige = [info objectForKey:@"user_id"];
    NSLog(@"michauxs -- %@", (NSArray*)brige);
    
    [cmd performWithResult:&brige];
    
    id<AYDelegateBase> del = [self.delegates objectForKey:@"JoinedGroupList"];
    id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
    [cmd_change performWithResult:&brige];

    id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_refresh = [view_content.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
    
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
    line.borderWidth = 1.f;
    line.borderColor = [Tools garyColor].CGColor;
    line.frame = CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5);
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

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- notifies
- (id)startRemoteCall:(id)obj {
//    _loading = VIEW(@"Loading", @"Loading");
//    ((UIView*)_loading).backgroundColor = [UIColor redColor];
//    ((UIView*)_loading).userInteractionEnabled = NO;
//    
//    [self.view addSubview:((UIView*)_loading)];
    
    id<AYViewBase> view_loading = [self.views objectForKey:@"Loading"];
    ((UIView*)view_loading).hidden = NO;
    id<AYCommand> cmd = [view_loading.commands objectForKey:@"startGif"];
    [cmd performWithResult:nil];
    return nil;
}

- (id)endRemoteCall:(id)obj {
//    [((UIView*)_loading) removeFromSuperview];
    UIView* view_loading = [self.views objectForKey:@"Loading"];
    view_loading.hidden = YES;
//    [view_loading removeFromSuperview];
    
    return nil;
}
@end
