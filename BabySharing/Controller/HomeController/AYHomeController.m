//
//  AYHomeController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYHomeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYHomeCellDefines.h"

#import "Tools.h"
#import "MJRefresh.h"
#import "QueryContent.h"
#import "Masonry.h"

typedef void(^queryContentFinish)(void);

#define HEADER_MARGIN_TO_SCREEN 10.5
#define CONTENT_START_POINT     71
#define PAN_HANDLE_CHECK_POINT  10

#define VIEW_BOUNTDS        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width; \
CGFloat screen_height = [UIScreen mainScreen].bounds.size.height; \
CGRect rc = CGRectMake(0, 0, screen_width, screen_height);

#define QUERY_VIEW_START    CGRectMake(HEADER_MARGIN_TO_SCREEN, -44, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
#define QUERY_VIEW_SCROLL   CGRectMake(HEADER_MARGIN_TO_SCREEN, 0, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
#define QUERY_VIEW_END      CGRectMake(-rc.size.width, -44, rc.size.width, rc.size.height)

#define BACK_TO_TOP_TIME    3.0
#define SHADOW_WIDTH 4
#define MARGIN_BETWEEN_CARD     3

#define DEBUG_NEW_HOME_PAGE
// 减速度
#define DECELERATION 400.0

@implementation AYHomeController {
//    BOOL _isPushed;
//    NSString* _push_home_title;
    NSArray* push_content;
    NSNumber* start_index;
    
    CATextLayer* badge;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CALayer *maskLayer;
}

@synthesize isPushed = _isPushed;
@synthesize push_home_title = _push_home_title;

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _isPushed = YES;
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        _push_home_title = [args objectForKey:@"home_title"];
        push_content = [args objectForKey:@"content"];
        start_index = [args objectForKey:@"start_index"];
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)loadView {
    [super loadView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [[UINavigationBar appearance] setShadowImage:[Tools imageWithColor:[UIColor colorWithWhite:0.5922 alpha:0.25] size:CGSizeMake(width, 1)]];
        [[UINavigationBar appearance] setBackgroundImage:[Tools imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    if (!_isPushed) {
        UIView* view_fake = [self.views objectForKey:@"FakeNavBar"];
        UIView* view_image = [self.views objectForKey:@"Image"];
        [view_fake addSubview:view_image];
        view_image.hidden = NO;
        
        id<AYCommand> cmd = [((id<AYViewBase>)view_fake).commands objectForKey:@"setLeftBtnVisibility:"];
        NSNumber* bHidden = [NSNumber numberWithBool:YES];
        [cmd performWithResult:&bHidden];

        [self createNavActionView];
        [self createAnimateView];
    } else {
        UIView* view_fake = [self.views objectForKey:@"FakeNavBar"];
        UIView* view_label = [self.views objectForKey:@"Label"];
        [view_fake addSubview:view_label];
        view_label.hidden = NO;

        id<AYCommand> cmd = [((id<AYViewBase>)view_label).commands objectForKey:@"changeLabelText:"];
        id args = _push_home_title;
        [cmd performWithResult:&args];

        [view_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view_fake);
            make.centerY.equalTo(view_fake);
        }];
    }
    
    {
        id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
        id<AYCommand> cmd_datasource = [view_content.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_content.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)del;
        [cmd_datasource performWithResult:&obj];
        obj = (id)del;
        [cmd_delegate performWithResult:&obj];

        id<AYCommand> cmd_cell = [view_content.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYHomeCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name];
       
        id<AYCommand> cmd_reg = [del.commands objectForKey:@"setCallBackTableView:"];
        [cmd_reg performWithResult:&view_content];
        
        if (_isPushed) {
            id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
            NSArray* arr = push_content;
            [cmd_change performWithResult:&arr];
            
        } else {
            id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
            NSArray* arr = [self enumLocalHomeContent];
            [cmd_change performWithResult:&arr];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isPushed && start_index) {
        id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_scroll = [view_content.commands objectForKey:@"scrollToPostion:"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:start_index forKey:@"row"];
        [dic setValue:[NSNumber numberWithInteger:0] forKey:@"section"];
   
        [cmd_scroll performWithResult:&dic];
    }
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
#define CONTENT_TAB_BAT_HEIGHT          (_isPushed ? 0 : 49)

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 64 - CONTENT_TAB_BAT_HEIGHT;
    
    view.frame = CGRectMake(0, 64, width, height);
    view.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 12.5)];
    footView.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
    [((UITableView*)view) setTableFooterView:footView];
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    
    if (!_isPushed) {
        __unsafe_unretained UITableView *tableView = (UITableView*)view;
        
        // 下拉刷新
        tableView.mj_header = [BSRefreshAnimationHeader headerWithRefreshingBlock:^{
            [self refreshHomeContent:^{
                [tableView reloadData];
                [tableView.mj_header endRefreshing];
            }];
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.automaticallyChangeAlpha = YES;
        
        // 上拉刷新
        tableView.mj_footer = [BSRefreshAnimationFooter footerWithRefreshingBlock:^{
            [self appendHomeContent:^{
                [tableView reloadData];
                [tableView.mj_footer endRefreshing];
            }];
        }];
    }
//    view.backgroundColor = [UIColor redColor];
    return nil;
}

- (id)ImageLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, 70, 22);
    ((UIImageView*)view).image = PNGRESOURCE(@"home_title_logo");
    view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 + 2, 44 / 2);
    view.hidden = YES;
//    [bkView addSubview:imgView];
    return nil;
}

- (id)LabelLayout:(UIView*)view {
//    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    view.hidden = YES;
    return nil;
}

- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, screen_width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, screen_width, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25].CGColor;
    line.frame = CGRectMake(0, 43, screen_width, 1);
    [view.layer addSublayer:line];
    return nil;
}

#pragma mark -- create navigation action view
- (void)createNavActionView {
    
    actionView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 38)];
    actionView.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
    
    [actionView addTarget:self action:@selector(didSelectChatGroupBtn) forControlEvents:UIControlEventTouchUpInside];
    actionView.tag = -99;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    actionView.center = CGPointMake(width - actionView.frame.size.width / 2 + 5 + 65, 1 + actionView.frame.size.height / 2);
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, 30, 30);
    layer.position = CGPointMake(CGRectGetWidth(actionView.frame) / 2 - 65 / 2 - 0.5 - 4.5, CGRectGetHeight(actionView.frame) / 2);
    layer.contents = (id)PNGRESOURCE(@"home_chat_back").CGImage;
    [actionView.layer addSublayer:layer];
    
    maskLayer = [[CALayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, sqrt(pow(15, 2)), sqrt(pow(15, 2)));
    maskLayer.position = CGPointMake(15, 15);
    maskLayer.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0].CGColor;
    [layer addSublayer:maskLayer];
    
    actionView.layer.cornerRadius = 19;
    actionView.layer.shadowColor = [UIColor blackColor].CGColor;
    actionView.layer.shadowOffset = CGSizeMake(-1, 1);
    actionView.layer.shadowOpacity = 0.3;
    actionView.layer.shadowRadius = 1;
    //    加入两个线条
    
    UIView* bkView = [self.views objectForKey:@"FakeNavBar"];
    [bkView addSubview:actionView];
    
    // badge
    CGPoint animateCenter = [actionView convertPoint:CGPointMake(28, actionView.frame.size.height / 2) toView:actionView];
    badge = [CATextLayer layer];
    badge.fontSize = 11.f;
    badge.contentsScale = 2.f;
    badge.backgroundColor = [UIColor clearColor].CGColor;
    badge.foregroundColor = [UIColor whiteColor].CGColor;
    badge.alignmentMode = @"center";
    
    CGSize sz = [Tools sizeWithString:@"..." withFont:[UIFont systemFontOfSize:11.f] andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    badge.frame = CGRectMake(0, 0, sz.width, sz.height);
    
    badge.position = CGPointMake(animateCenter.x, animateCenter.y);
    [actionView.layer addSublayer:badge];
}

- (void)createAnimateView {
    // 动画的layer
    UIView* bkView = [self.views objectForKey:@"FakeNavBar"];
    CGPoint animateCenter = [actionView convertPoint:CGPointMake(19, actionView.frame.size.height / 2) toView:bkView];
    
    // 半径
    radius = sqrt(pow(0 - animateCenter.x, 2) + pow(0 - animateCenter.y, 2));
    animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    animationView.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
    animationView.center = animateCenter;
    
    
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame)), radius - 19, radius - 19)];
    circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.backgroundColor = [UIColor redColor].CGColor;
    circleLayer.path = startCircle.CGPath;
    animationView.layer.mask = circleLayer;
    [bkView addSubview:animationView];
    bkView.clipsToBounds = YES;
    [bkView bringSubviewToFront:actionView];
}

- (void)didSelectChatGroupBtn {
    UIView* bkView = [self.views objectForKey:@"FakeNavBar"];

    UIViewController* groupVC = DEFAULTCONTROLLER(@"GroupList");
  
    {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:self forKey:kAYControllerChangeArgsKey];
        [dic setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
        [((id<AYCommand>)groupVC) performWithResult:&dic];
    }
    
    groupVC.view.frame = CGRectMake(CGRectGetWidth(self.navigationController.view.frame), 0, CGRectGetWidth(self.navigationController.view.frame), CGRectGetHeight(self.navigationController.view.frame));
    [self.view addSubview:groupVC.view];
//    [self.view bringSubviewToFront:bkView];
    actionView.enabled = NO;
    
    CABasicAnimation *maskLayerAnimation = [circleLayer animationForKey:@"path"] ? (CABasicAnimation *)[circleLayer animationForKey:@"path"] : [CABasicAnimation animationWithKeyPath:@"path"];
    CGRect endRect = CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame));
    maskLayerAnimation.fromValue = (__bridge id)(circleLayer.path);
    maskLayerAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithOvalInRect:endRect].CGPath);
    maskLayerAnimation.duration = 0.4;
    maskLayerAnimation.delegate = self;
    [circleLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowAnimation.fillMode=kCAFillModeForwards;
    shadowAnimation.removedOnCompletion = NO;
    shadowAnimation.duration = 0.0;
    shadowAnimation.fromValue = [NSNumber numberWithFloat:0.3];
    shadowAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [actionView.layer addAnimation:shadowAnimation forKey:@"shadowOpacity"];
    
    // 设定为缩放
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    scaleAnimation.duration = 0.4; // 动画持续时间
    scaleAnimation.repeatCount = 1; // 重复次数
    // 缩放倍数
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0]; // 结束时的倍率
    // 添加动画
    [maskLayer addAnimation:scaleAnimation forKey:@"scale-layer"];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIView *subView in self.view.subviews) {
            if (![subView isEqual:bkView]) {
                subView.frame = CGRectMake(CGRectGetMinX(subView.frame) - [UIScreen mainScreen].bounds.size.width, CGRectGetMinY(subView.frame), CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
            }
        }
        self.tabBarController.tabBar.frame = CGRectMake(CGRectGetMinX(self.tabBarController.tabBar.frame) - CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetMinY(self.tabBarController.tabBar.frame), CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame));
    } completion:^(BOOL finished) {
        groupVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [groupVC.view removeFromSuperview];
        [self.navigationController pushViewController:groupVC animated:NO];

        for (UIView *subView in self.view.subviews) {
            if (![subView isEqual:bkView]) {
                subView.frame = CGRectMake(CGRectGetMinX(subView.frame) + [UIScreen mainScreen].bounds.size.width, CGRectGetMinY(subView.frame), CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
            }
        }
        CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowAnimation.fillMode=kCAFillModeForwards;
        shadowAnimation.removedOnCompletion = NO;
        shadowAnimation.duration = 0.0;
        shadowAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        shadowAnimation.toValue = [NSNumber numberWithFloat:0.3];
        [actionView.layer addAnimation:shadowAnimation forKey:@"shadowOpacity"];
        // actionView.layer.shadowOpacity = 0.3;
        actionView.enabled = YES;
    }];
}

#pragma mark -- controller actions
- (NSArray*)enumLocalHomeContent {
    id<AYFacadeBase> f_owner_query = HOMECONTENTMODEL;
    id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"EnumHomeQueryData"];
    NSArray* arr = nil;
    [cmd performWithResult:&arr];
    return arr;
}

- (void)refreshHomeContent:(queryContentFinish)block {
    id<AYFacadeBase> f_login_model = LOGINMODEL;
    id<AYCommand> cmd = [f_login_model.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    NSLog(@"current login user is %@", obj);
    
    {
        id<AYFacadeBase> f_query_content = [self.facades objectForKey:@"ContentQueryRemote"];
        AYRemoteCallCommand* cmd_query_content = [f_query_content.commands objectForKey:@"QueryHomeContent"];
        
        NSMutableDictionary* dic = [obj mutableCopy];
        [dic setValue:[NSNumber numberWithInteger:0] forKey:@"skip"];
        
        [cmd_query_content performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"user post result %@", result);
            
            NSDictionary* args = [result copy];
            
            id<AYFacadeBase> f_owner_query = HOMECONTENTMODEL;
            id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"RefrashHomeQueryData"];
            [cmd performWithResult:&args];
            
            id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
            id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
            NSArray* arr = [self enumLocalHomeContent];
            [cmd_change performWithResult:&arr];
            
            block();
        }];
    }
}

- (void)appendHomeContent:(queryContentFinish)block {

    NSDictionary* user = nil;
    CURRENUSER(user);
    
    {
        NSArray* arr = [self enumLocalHomeContent];
        
        id<AYFacadeBase> f_query_content = [self.facades objectForKey:@"ContentQueryRemote"];
        AYRemoteCallCommand* cmd_query_content = [f_query_content.commands objectForKey:@"QueryHomeContent"];
        
        NSMutableDictionary* dic = [user mutableCopy];
        [dic setValue:[NSNumber numberWithInteger:arr.count] forKey:@"skip"];
       
        id<AYCommand> cmd_time_span = [f_query_content.commands objectForKey:@"EnumHomeTimeSpan"];
        NSDate* d = nil;
        [cmd_time_span performWithResult:&d];
        [dic setValue:d forKey:@"date"];
        
        [cmd_query_content performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"user post result %@", result);
            
            NSDictionary* args = [result copy];
            
            id<AYFacadeBase> f_owner_query = HOMECONTENTMODEL;
            id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"AppendHomeQueryData"];
            [cmd performWithResult:&args];
            
            id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
            id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
            NSArray* arr = [self enumLocalHomeContent];
            [cmd_change performWithResult:&arr];
            
            block();
        }];
    }
}

#pragma mark -- notifies 
- (id)showUserInfo:(id)args {
    
    QueryContent* tmp = (QueryContent*)args;
   
    AYViewController* des = DEFAULTCONTROLLER(@"Profile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:tmp.owner_id forKey:kAYControllerChangeArgsKey];
    
    [self performWithResult:&dic_push];
    return nil;
}

- (id)likePostItem:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
    QueryContent* content = [dic objectForKey:kAYHomeCellContentKey];
    id<AYViewBase> cell = [dic objectForKey:kAYHomeCellCellKey];
   
    NSDictionary* obj = nil;
    CURRENUSER(obj)
    
    NSMutableDictionary* dic_like = [obj mutableCopy];
    [dic_like setValue:content.content_post_id forKey:@"post_id"];
   
    id<AYFacadeBase> f_post = [self.facades objectForKey:@"ContentPostRemote"];
    AYRemoteCallCommand* cmd_like = [f_post.commands objectForKey:@"PostLikeContent"];
    
    [cmd_like performWithResult:[dic_like copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
           
            {
                id<AYFacadeBase> f_home = HOMECONTENTMODEL;
                id<AYCommand> cmd_refresh_like = [f_home.commands objectForKey:@"RefreshLikeData"];
                NSMutableDictionary* dic = [result mutableCopy];
                [dic setValue:content.content_post_id forKey:@"post_id"];
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"like_result"];
                [cmd_refresh_like performWithResult:&dic];
            }
            
            {
                id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
                id<AYCommand> cmd_refresh_cell = [del.commands objectForKey:@"likePostItemResult:"];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"like_result"];
                [dic setValue:cell forKey:kAYHomeCellCellKey];
                [cmd_refresh_cell performWithResult:&dic];
            }
        
        } else {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"由于某些不可抗力，出现了错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
    return nil;
}

- (id)unLikePostItem:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    QueryContent* content = [dic objectForKey:kAYHomeCellContentKey];
    id<AYViewBase> cell = [dic objectForKey:kAYHomeCellCellKey];
    
    NSDictionary* obj = nil;
    CURRENUSER(obj)
    
    NSMutableDictionary* dic_like = [obj mutableCopy];
    [dic_like setValue:content.content_post_id forKey:@"post_id"];
    
    id<AYFacadeBase> f_post = [self.facades objectForKey:@"ContentPostRemote"];
    AYRemoteCallCommand* cmd_like = [f_post.commands objectForKey:@"PostUnlikeContent"];
    
    [cmd_like performWithResult:[dic_like copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
            {
                id<AYFacadeBase> f_home = HOMECONTENTMODEL;
                id<AYCommand> cmd_refresh_like = [f_home.commands objectForKey:@"RefreshLikeData"];
                NSMutableDictionary* dic = [result mutableCopy];
                [dic setValue:content.content_post_id forKey:@"post_id"];
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"like_result"];
                [cmd_refresh_like performWithResult:&dic];
            }
            
            {
                id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
                id<AYCommand> cmd_refresh_cell = [del.commands objectForKey:@"likePostItemResult:"];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:[NSNumber numberWithBool:NO] forKey:@"like_result"];
                [dic setValue:cell forKey:kAYHomeCellCellKey];
                [cmd_refresh_cell performWithResult:&dic];
            }
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"由于某些不可抗力，出现了错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
    return nil;
}

- (id)pushPostItem:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    QueryContent* content = [dic objectForKey:kAYHomeCellContentKey];
    id<AYViewBase> cell = [dic objectForKey:kAYHomeCellCellKey];
    
    NSDictionary* obj = nil;
    CURRENUSER(obj)
    
    NSMutableDictionary* dic_like = [obj mutableCopy];
    [dic_like setValue:content.content_post_id forKey:@"post_id"];
    
    id<AYFacadeBase> f_post = [self.facades objectForKey:@"ContentPostRemote"];
    AYRemoteCallCommand* cmd_like = [f_post.commands objectForKey:@"PostPushContent"];
    
    [cmd_like performWithResult:[dic_like copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
            {
                id<AYFacadeBase> f_home = HOMECONTENTMODEL;
                id<AYCommand> cmd_refresh_like = [f_home.commands objectForKey:@"RefreshPushData"];
                NSMutableDictionary* dic = [result mutableCopy];
                [dic setValue:content.content_post_id forKey:@"post_id"];
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"lpush_result"];
                [cmd_refresh_like performWithResult:&dic];
            }
            
            {
                id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
                id<AYCommand> cmd_refresh_cell = [del.commands objectForKey:@"pushPostItemResult:"];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"push_result"];
                [dic setValue:cell forKey:kAYHomeCellCellKey];
                [cmd_refresh_cell performWithResult:&dic];
            }
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"由于某些不可抗力，出现了错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
    return nil;
}

- (id)joinGroup:(id)args {
    
    QueryContent* tmp = (QueryContent*)args;
    
    AYViewController* des = DEFAULTCONTROLLER(@"GroupChat");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:tmp.owner_id forKey:@"owner_id"];
    [dic setValue:tmp.content_post_id forKey:@"post_id"];
    [dic setValue:tmp.content_description forKey:@"theme"];
    
    [dic_push setValue:[dic copy] forKey:kAYControllerChangeArgsKey];
    [self performWithResult:&dic_push];
    
    return nil;
}

- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}
@end
