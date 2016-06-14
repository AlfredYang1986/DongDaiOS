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
    coverImg.image = [UIImage imageNamed:@"lol"];
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
    
    UIButton *personal = [[UIButton alloc]init];
    [personal setTitle:@"一键发布服务信息" forState:UIControlStateNormal];
    personal.backgroundColor = [Tools themeColor];
    [self.view addSubview:personal];
    [personal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(say.mas_bottom).offset(50);
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
    NSDictionary* obj = nil;
    CURRENUSER(obj)
    NSDictionary* args = [obj mutableCopy];
//    NSDate *timeSpan = [NSDate dateWithTimeInterval:<#(NSTimeInterval)#> sinceDate:<#(nonnull NSDate *)#>]
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[args objectForKey:@"user_id"]  forKey:@"owner_id"];
    
    NSString *startDateString = @"2016-06-15 11:15";
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [format dateFromString:startDateString];
    NSTimeInterval start = startDate.timeIntervalSinceReferenceDate * 1000;
    
    NSString *endDateString = @"2016-06-15 12:15";
    NSDate *endDate = [format dateFromString:endDateString];
    NSTimeInterval end = endDate.timeIntervalSinceReferenceDate * 1000;
    
    NSMutableDictionary *offer_date = [[NSMutableDictionary alloc]init];
    [offer_date setValue:[NSNumber numberWithLong:start] forKey:@"start"];
    [offer_date setValue:[NSNumber numberWithLong:end] forKey:@"end"];
    [dic setValue:offer_date forKey:@"offer_date"];
    
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:39.901508 longitude:116.406997];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:39.961508 longitude:116.456997];
    NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
    [location setValue:[NSNumber numberWithFloat:loc.coordinate.latitude] forKey:@"latitude"];
    [location setValue:[NSNumber numberWithFloat:loc.coordinate.longitude] forKey:@"longtitude"];
    [dic setValue:location forKey:@"location"];
    
    [dic setValue:@"爱花花的文艺妈妈33" forKey:@"title"];
    [dic setValue:@"description:33一位爱花花的文艺妈妈" forKey:@"description"];
    [dic setValue:[NSNumber numberWithInt:2] forKey:@"capacity"];
    [dic setValue:[NSNumber numberWithFloat:66] forKey:@"price"];
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushPersonalInfo"];
    [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            //    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            
            NSMutableDictionary *dic_publish = [[NSMutableDictionary alloc]init];
            [dic_publish setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
            [dic_publish setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
            AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"PublishService"];
            [cmd_publish performWithResult:[dic_publish copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                if (success) {
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发布成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                }
            }];
        }
    }];
    
    //    owner_id :  (String)
    //    offer_date: (json object) {
    //          start: (long => 苹果的timespan）
    //          end: (同上)
    //        }
    //    location: (json object) {
    //      latitude: (float => 高德地图经度)
    //      longtitude: (float => 高德地图纬度)
    //    }
    //    title: (String)
    //    description: (String)
    //    capacity : (Int)
    //    price: (Float)
}

#pragma mark -- notifies
- (id)startRemoteCall:(id)obj {
    return nil;
}

- (id)endRemoteCall:(id)obj {
    return nil;
}
@end
