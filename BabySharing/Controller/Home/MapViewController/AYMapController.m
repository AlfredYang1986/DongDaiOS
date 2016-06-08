//
//  AYMapViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYSearchDefines.h"
#import "Tools.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@interface AYMapController ()
    
@end

@implementation AYMapController{
    NSMutableArray *loading_status;
    CLLocation *loc;
    NSArray *fiteResultArrWithLoc;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        loc = [args objectForKey:@"location"];
        fiteResultArrWithLoc = [args objectForKey:@"result_data"];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    [bar_left_btn setTitle:@"  " forState:UIControlStateNormal];
    bar_left_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_left_btn sizeToFit];
    bar_left_btn.center = CGPointMake(10.5 + bar_left_btn.frame.size.width / 2, 44 / 2);
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnWithBtn:"];
    //    UIImage* left = PNGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&bar_left_btn];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"关闭" forState:UIControlStateNormal];
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
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 44 / 2);
    return nil;
}

- (id)ShowBoardLayout:(UIView*)view {
    CGFloat margin = 0.f;
    view.frame = CGRectMake(margin, SCREEN_HEIGHT - 130, SCREEN_WIDTH - 2* margin, 110);
    view.backgroundColor = [UIColor clearColor];
    ((UIScrollView*)view).showsVerticalScrollIndicator = NO;
    ((UIScrollView*)view).showsHorizontalScrollIndicator = NO;
    return nil;
}

- (id)MapViewLayout:(UIView*)view {
    CGFloat margin = 0.f;
    view.frame = CGRectMake(margin, 64, SCREEN_WIDTH - 2* margin, SCREEN_HEIGHT - 64);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
//    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
//    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
//    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
//    
//    id<AYCommand> cmd = POP;
//    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    id<AYCommand> cmd = REVERSMODULE;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [cmd performWithResult:&dic];
    return nil;
}

-(id)queryTheLoc:(id)args{
    
    return loc;
}
@end
