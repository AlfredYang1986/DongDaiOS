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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface AYMapController ()
    
@end

@implementation AYMapController{
    
    NSDictionary *resultAndLoc;
    CLLocation *loc;
    NSArray *fiteResultData;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        resultAndLoc = [dic objectForKey:kAYControllerChangeArgsKey];
        loc = [resultAndLoc objectForKey:@"location"];
        fiteResultData = [resultAndLoc objectForKey:@"result_data"];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:IMGRESOURCE(@"map_cancel") forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    [closeBtn addTarget:self action:@selector(didCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    id<AYViewBase> show = [self.views objectForKey:@"ShowBoard"];
    id<AYCommand> cmd = [show.commands objectForKey:@"changeResultData:"];
    NSDictionary *dic_show = [resultAndLoc mutableCopy];
    [cmd performWithResult:&dic_show];
    
    [self.view bringSubviewToFront:(UIView*)show];
    
    id<AYViewBase> map = [self.views objectForKey:@"MapView"];
    id<AYCommand> cmd_map = [map.commands objectForKey:@"changeResultData:"];
    NSDictionary *dic_map = [resultAndLoc mutableCopy];
    [cmd_map performWithResult:&dic_map];
    
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
    view.backgroundColor = [UIColor clearColor];
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
    view.frame = CGRectMake(margin, 0, SCREEN_WIDTH - 2* margin, SCREEN_HEIGHT);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}


#pragma mark -- actions
- (void)didCloseBtnClick:(UIButton*)btn {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    return nil;
}

- (id)rightBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

-(id)queryTheLoc:(id)args{
    return resultAndLoc;
}

-(id)queryResultDate:(id)args{
    return resultAndLoc;
}

-(id)sendChangeOffsetMessage:(NSNumber*)index {
    id<AYViewBase> view = [self.views objectForKey:@"ShowBoard"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeOffsetX:"];
    [cmd performWithResult:&index];
    
    return nil;
}

-(id)sendChangeAnnoMessage:(NSNumber*)index{
    id<AYViewBase> view = [self.views objectForKey:@"MapView"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeAnnoView:"];
    [cmd performWithResult:&index];
    
    return nil;
}
@end
