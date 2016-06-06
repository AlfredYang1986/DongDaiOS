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
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#import "Tools.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "AYCalendarView.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@implementation AYLocationResultController{
    NSMutableArray *loading_status;
    
    CLLocation *loc;
    AMapSearchAPI *search;
    
    UIButton *doSearchBtn;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
//        if (<#condition#>) {
//            <#statements#>
//        }
        loc = [args objectForKey:@"location"];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYFacadeBase> f_search = [self.facades objectForKey:@"SearchRemote"];
    AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"QueryMMWithLocation"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSNumber *latitude = [NSNumber numberWithFloat:loc.coordinate.latitude];
    NSNumber *longtitude = [NSNumber numberWithFloat:loc.coordinate.longitude];
    if (latitude) {
        [dic setValue:latitude forKey:@"latitude"];
    }
    if (longtitude) {
        [dic setValue:longtitude forKey:@"longtitude"];
    }
    [cmd_tags performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand tags result %@", result);
            
        }
    }];
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
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
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [headView.layer addSublayer:line2];
    
    doSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 45 - 20, SCREEN_WIDTH - 40, 45)];
    [doSearchBtn setBackgroundColor:[Tools themeColor]];
    [doSearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    doSearchBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [doSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doSearchBtn.layer.cornerRadius = 4.f;
    doSearchBtn.clipsToBounds = YES;
    doSearchBtn.hidden = YES;
    [self.view addSubview:doSearchBtn];
    
    [doSearchBtn addTarget:self action:@selector(doSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    id<AYViewBase> view = [self.views objectForKey:@"Calendar"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hiddenBeShowing"];
    [cmd performWithResult:nil];
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
    
    UIButton* bar_left_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_left_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
    [bar_left_btn setTitle:@"返回" forState:UIControlStateNormal];
    bar_left_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_left_btn sizeToFit];
    bar_left_btn.center = CGPointMake(10.5 + bar_left_btn.frame.size.width / 2, 44 / 2);
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnWithBtn:"];
//    UIImage* left = PNGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&bar_left_btn];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"地图" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 10.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"当前位置";
    titleView.font = [UIFont systemFontOfSize:14.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 44 / 2);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 74 + 160, SCREEN_WIDTH, SCREEN_HEIGHT - 74-160);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

- (id)CalendarLayout:(UIView*)view {
    CGFloat margin = 20.f;
    view.frame = CGRectMake(margin, 74, SCREEN_WIDTH - 2* margin, 140);
    view.backgroundColor = [UIColor clearColor];
    ((UIScrollView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

#pragma mark -- actions
-(void)doSearchBtnClick{
    
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    NSLog(@"setting view controller");
    
//    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputCoder");
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic setValue:setting forKey:kAYControllerActionDestinationControllerKey];
//    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    
//    id<AYCommand> cmd_push = PUSH;
//    [cmd_push performWithResult:&dic];
    
    return nil;
}

-(id)hiddenCLResultTable{
    UIView *view_table = [self.views objectForKey:@"Table"];
    view_table.hidden = !view_table.hidden;
    
    doSearchBtn.hidden = !doSearchBtn.hidden;
    return nil;
}

- (id)scrollToHideKeyBoard {
    UIView* view = [self.views objectForKey:@"SearchBar"];
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
    }
    return nil;
}

- (id)resetContentSize:(NSNumber*)numb{
    UIScrollView *view = [self.views objectForKey:@"Calendar"];
    view.contentSize = CGSizeMake(0, numb.floatValue);
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}
@end
