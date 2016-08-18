//
//  AYOrderServiceController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCalendarServiceController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"
#import "Tools.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

@interface AYCalendarServiceController ()

@end

@implementation AYCalendarServiceController
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Tools garyBackgroundColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    id<AYViewBase> fiter = [self.views objectForKey:@"FiterScroll"];
//    id<AYCommand> cmd = [fiter.commands objectForKey:@"dateScrollToCenter:"];
//    NSString *str = [dateString copy];
//    [cmd performWithResult:&str];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- Layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"日程管理";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left_vis = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    [cmd_left_vis performWithResult:&left_hidden];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"发布服务" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 44 - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)ScheduleLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 +10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 -10);
    
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

- (id)rightBtnSelected {
//    id<AYViewBase> view = [self.views objectForKey:@"FiterScroll"];
//    id<AYCommand> cmd = [view.commands objectForKey:@"resetFiterArgs"];
//    [cmd performWithResult:nil];
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
