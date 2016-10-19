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
#import "AYThumbsAndPushDefines.h"

#import "MJRefresh.h"
#import "QueryContent.h"

#import "AYModelFacade.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^queryContentFinish)(void);


#define HEADER_MARGIN_TO_SCREEN         10.5
#define CONTENT_START_POINT             71
#define PAN_HANDLE_CHECK_POINT          10

//#define VIEW_BOUNTDS        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width; \
//CGFloat screen_height = [UIScreen mainScreen].bounds.size.height; \
//CGRect rc = CGRectMake(0, 0, screen_width, screen_height);
//
//#define QUERY_VIEW_START    CGRectMake(HEADER_MARGIN_TO_SCREEN, -44, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
//#define QUERY_VIEW_SCROLL   CGRectMake(HEADER_MARGIN_TO_SCREEN, 0, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
//#define QUERY_VIEW_END      CGRectMake(-rc.size.width, -44, rc.size.width, rc.size.height)

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
    
    UIView *cover;
    NSString *notePostId;
    
    UIImageView *coverImg;
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
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
        if (backArgs) {
            
            if ([backArgs isKindOfClass:[NSString class]]) {
                
                NSString *title = (NSString*)backArgs;
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
            
        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        UITableView *tableView = (UITableView*)view_notify;
        coverImg = [[UIImageView alloc]init];
        coverImg.image = [UIImage imageNamed:@"theme_image"];
        coverImg.backgroundColor = [UIColor lightGrayColor];
        [tableView addSubview:coverImg];
        [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableView).offset(-SCREEN_WIDTH);
            make.centerX.equalTo(tableView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        }];
        
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        UIButton *found = [[UIButton alloc]init];
        //    found.layer.cornerRadius = 37.5f;
        //    found.clipsToBounds = YES;
        found.backgroundColor = [UIColor clearColor];
        [found setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
        [found addTarget:self action:@selector(foundBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [tableView addSubview:found];
        [tableView bringSubviewToFront:found];
        [found mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableView).offset(30);
            make.bottom.equalTo(coverImg).offset(35);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Home"];
        id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name_tip = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeTipCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name_tip];
        
        NSString* class_name_his = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name_his];
        
        NSString* class_name_lik = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeLikesCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&class_name_lik];
        
        /**
         *  query collect service
         */
        NSDictionary* info = nil;
        CURRENUSER(info)
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"AllCollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                id<AYCommand> cmd_change_data = [cmd_notify.commands objectForKey:@"changeQueryData:"];
                NSArray *data = [result objectForKey:@"result"];
                [cmd_change_data performWithResult:&data];
                
                id<AYCommand> refresh = [view_notify.commands objectForKey:@"refresh"];
                [refresh performWithResult:nil];
            } else {
                NSLog(@"push error with:%@",result);
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请检查网络链接是否正常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    }
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(SCREEN_WIDTH, 0, 0, 0);
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view.hidden = YES;
    return nil;
}

#pragma mark -- controller actions
- (id)foundBtnClick {
    
//    id<AYCommand> des = DEFAULTCONTROLLER(@"CommentService");
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
//    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    //    [dic setValue:[args copy] forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd_show_module = SHOWMODULEUP;
//    [cmd_show_module performWithResult:&dic];
    
    AYViewController* des = DEFAULTCONTROLLER(@"Location");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)didPushInfo {
    AYViewController* des = DEFAULTCONTROLLER(@"OrderList");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

#pragma mark -- actions
- (void)loadMoreData {
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"AllCollectService"];
    [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Home"];
            id<AYCommand> cmd_change_data = [cmd_notify.commands objectForKey:@"changeQueryData:"];
            NSArray *data = [result objectForKey:@"result"];
            [cmd_change_data performWithResult:&data];
            
            id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
            id<AYCommand> refresh = [view_notify.commands objectForKey:@"refresh"];
            [refresh performWithResult:nil];
        } else {
            NSLog(@"push error with:%@",result);
            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请检查网络链接是否正常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        [((UITableView*)view_notify).mj_footer endRefreshing];
    }];
}

#pragma mark -- notifies
- (id)scrollOffsetY:(NSNumber*)args {
    CGFloat offset_y = args.floatValue;
    CGFloat offsetH = SCREEN_WIDTH + offset_y;
    
    if (offsetH < 0) {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        UITableView *tableView = (UITableView*)view_notify;
        [coverImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tableView);
            make.top.equalTo(tableView).offset(-SCREEN_WIDTH + offsetH);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - offsetH, SCREEN_WIDTH - offsetH));
        }];
    }
    return nil;
}

- (id)crimeReport:(NSString*)postid{
    notePostId = postid;
    if (!cover) {
        cover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        cover.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
        [self.view addSubview:cover];
        [self.view bringSubviewToFront:cover];
        
        UIView *btnBg = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 124, SCREEN_WIDTH, 124)];
        btnBg.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
        [cover addSubview:btnBg];
        
        CALayer *line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.7922 alpha:1.f].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(0, 62, [UIScreen mainScreen].bounds.size.width, 1);
        [btnBg.layer addSublayer:line];
        
        UIButton *doCrime = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 61)];
        [doCrime setTitle:@"举报该内容" forState:UIControlStateNormal];
        doCrime.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [doCrime setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
        [doCrime addTarget:self action:@selector(doCrimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btnBg addSubview:doCrime];
        
        UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 61)];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [cancel setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btnBg addSubview:cancel];
    }else cover.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y + 49);
    }];
    return nil;
}

- (void)doCrimeBtnClick{
    
    NSMutableDictionary *expose = [[NSMutableDictionary alloc]init];
    [expose setValue:[NSNumber numberWithInt:1] forKey:@"expose_type"];
    [expose setValue:notePostId forKey:@"post_id"];
    
    id<AYFacadeBase> expose_remote = [self.facades objectForKey:@"ExposeRemote"];
    AYRemoteCallCommand* cmd = [expose_remote.commands objectForKey:@"ExposeContent"];
    [cmd performWithResult:expose andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
            NSString *title = @"我们将尽快处理您举报的内容！\n感谢您的监督和支持！";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }else {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"举报发生未知错误，请检查网络是否正常连接！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
    
    cover.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y - 49);
    }];
}

- (void)cancelBtnClick{
    cover.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y - 49);
    }];
}

@end
