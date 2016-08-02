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
#import "AYThumbsAndPushDefines.h"

#import "Tools.h"
#import "MJRefresh.h"
#import "QueryContent.h"
#import "Masonry.h"

#import "AYModelFacade.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^queryContentFinish)(void);

#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height

#define HEADER_MARGIN_TO_SCREEN         10.5
#define CONTENT_START_POINT             71
#define PAN_HANDLE_CHECK_POINT          10

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
    
    UIView *cover;
    NSString *notePostId;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    UIImageView *coverImg = [[UIImageView alloc]init];
    coverImg.image = [UIImage imageNamed:@"lol"];
    coverImg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:coverImg];
    [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
    }];
    
    UIButton *found = [[UIButton alloc]init];
//    found.layer.cornerRadius = 37.5f;
//    found.clipsToBounds = YES;
    found.backgroundColor = [UIColor clearColor];
    [found setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    [found addTarget:self action:@selector(foundBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:found];
    [found mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(coverImg.mas_bottom).offset(-35);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    NSString *name = tmp.who.screen_name;
    UILabel *hello = [[UILabel alloc]init];
    hello.font = [UIFont systemFontOfSize:16.f];
    hello.textColor = [UIColor blackColor];
    NSString *subName = [name substringFromIndex:name.length - 1];
    NSMutableAttributedString *helloString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@，你好",subName]];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:43.f],NSForegroundColorAttributeName:[Tools themeColor]};
    [helloString setAttributes:dic range:NSMakeRange(0, subName.length)];
    hello.attributedText = helloString;
    [self.view addSubview:hello];
    [hello mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(found.mas_bottom).offset(20);
    }];
    UILabel *say = [[UILabel alloc]init];
    say.text = @"找到附近你认同的妈妈，帮你带两个小时孩子";
    say.font = [UIFont systemFontOfSize:16.f];
    say.numberOfLines = 0;
    say.textColor = [UIColor grayColor];
    [self.view addSubview:say];
    [say mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(hello.mas_bottom).offset(10);
    }];
    
    UIButton *personal = [[UIButton alloc]init];
//    personal.hidden = YES;
    [personal setTitle:@"我的订单" forState:UIControlStateNormal];
    personal.backgroundColor = [Tools themeColor];
    [self.view addSubview:personal];
    [personal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(say.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    [personal addTarget:self action:@selector(didPushInfo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    
    return nil;
}

- (id)ImageLayout:(UIView*)view {
    
    return nil;
}

- (id)LabelLayout:(UIView*)view {
    return nil;
}

- (id)FakeStatusBarLayout:(UIView*)view {
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    return nil;
}

#pragma mark -- controller actions
-(void)foundBtnClick{
    AYViewController* des = DEFAULTCONTROLLER(@"Location");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:cur forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

-(void)didPushInfo{
    AYViewController* des = DEFAULTCONTROLLER(@"OrderList");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)startRemoteCall:(id)obj {
    return nil;
}

- (id)endRemoteCall:(id)obj {
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
    }else
        cover.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(CGRectGetMinX(self.tabBarController.tabBar.frame), CGRectGetMinY(self.tabBarController.tabBar.frame) + CGRectGetHeight(self.tabBarController.tabBar.frame), CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame));
    }];
    return nil;
}

- (void)doCrimeBtnClick{
    
    //    id<AYViewBase> view = [self.views objectForKey:@"HomeCell"];
    //    id<AYCommand> query_cmd = [view.commands objectForKey:@"queryPostId:"];
    //    NSString *post_id = nil;
    //    [query_cmd performWithResult:&post_id];
    //
    //    id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
    //    id<AYCommand> cmd_ex = [del.commands objectForKey:@"queryPostId:"];
    
    NSMutableDictionary *expose = [[NSMutableDictionary alloc]init];
    [expose setValue:[NSNumber numberWithInt:1] forKey:@"expose_type"];
    [expose setValue:notePostId forKey:@"post_id"];
    
    id<AYFacadeBase> expose_remote = [self.facades objectForKey:@"ExposeRemote"];
    AYRemoteCallCommand* cmd = [expose_remote.commands objectForKey:@"ExposeContent"];
    [cmd performWithResult:expose andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"我们将尽快处理您举报的内容！感谢您的监督和支持！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }else {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"举报发生未知错误，请检查网络是否正常连接！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
    
    cover.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(CGRectGetMinX(self.tabBarController.tabBar.frame), CGRectGetMinY(self.tabBarController.tabBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame), CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame));
    }];
}

- (void)cancelBtnClick{
    cover.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(CGRectGetMinX(self.tabBarController.tabBar.frame), CGRectGetMinY(self.tabBarController.tabBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame), CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame));
    }];
}

@end
