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

typedef void(^queryContentFinish)(void);

#define HEADER_MARGIN_TO_SCREEN 10.5
#define CONTENT_START_POINT     71
#define PAN_HANDLE_CHECK_POINT  10

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *coverImg = [[UIImageView alloc]init];
    coverImg.image = [UIImage imageNamed:@""];
    coverImg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:coverImg];
    [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 370));
    }];
    
    UIButton *found = [[UIButton alloc]init];
    found.layer.cornerRadius = 35.f;
    found.clipsToBounds = YES;
    found.backgroundColor = [UIColor whiteColor];
    [found setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateNormal];
    [found addTarget:self action:@selector(foundBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:found];
    [found mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(coverImg.mas_bottom).offset(-35);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
//    [cur setValue:tmp.who.screen_image forKey:@"screen_photo"];
    NSString *name = tmp.who.screen_name;
    
    UILabel *hello = [[UILabel alloc]init];
    hello.text = [NSString stringWithFormat:@"%@，你好",name];
    hello.font = [UIFont systemFontOfSize:16.f];
    hello.textColor = [UIColor blackColor];
    [self.view addSubview:hello];
    [hello mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(found.mas_bottom).offset(20);
    }];
    UILabel *say = [[UILabel alloc]init];
    say.text = @"找到附近你认同的妈妈，帮你带两个小时孩子";
    say.font = [UIFont systemFontOfSize:16.f];
    say.textColor = [UIColor grayColor];
    [self.view addSubview:say];
    [say mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hello);
        make.top.equalTo(hello.mas_bottom).offset(10);
    }];
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

#pragma mark -- notifies

@end
