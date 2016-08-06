//
//  AYReadyOrderController.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYReadyOrderController.h"
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

#import "AYTabBarServiceController.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@implementation AYReadyOrderController{
    NSMutableArray *loading_status;
    
    NSDictionary *order_info;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        order_info = [dic objectForKey:kAYControllerChangeArgsKey];
        NSLog(@"%@",order_info);
        
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
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ReadyOrder"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> change_data = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
    NSDictionary *args = order_info;
    [change_data performWithResult:&args];
    
//    id<AYCommand> refresh_2 = [view_table.commands objectForKey:@"refresh"];
//    [refresh_2 performWithResult:nil];
    
    /****************************************/
    id<AYCommand> cmd_head = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* head_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&head_name];
    
    id<AYCommand> cmd_nib = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_contact_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_nib performWithResult:&nib_contact_name];
    
    NSString* nib_state_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderStateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_nib performWithResult:&nib_state_name];
    
    NSString* nib_pay_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_nib performWithResult:&nib_pay_name];
    
    NSString* nib_map_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&nib_map_name];
    /****************************************/
    
    NSNumber *status = [order_info objectForKey:@"status"];
    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
    if (status.intValue == 0 && [self.tabBarController isKindOfClass:[des class]]) {
        
        UIButton *confirmSerBtn = [[UIButton alloc]init];
        confirmSerBtn.backgroundColor = [Tools themeColor];
        [confirmSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:confirmSerBtn];
        [self.view bringSubviewToFront:confirmSerBtn];
        [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        [confirmSerBtn setTitle:@"接受或者拒绝" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(didComfirmOrRejectBtnClick) forControlEvents:UIControlEventTouchDown];
        
    }
    
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"待确认订单";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    NSNumber *status = [order_info objectForKey:@"status"];
    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
    BOOL isNap = (status.intValue == 0 && [self.tabBarController isKindOfClass:[des class]]);
    
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 + 10 - (isNap?44:0));
    
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

- (id)TimeOptionLayout:(UIView*)view {
    CGFloat margin = 15.f;
    view.frame = CGRectMake(margin, 64 + 10, SCREEN_WIDTH - margin * 2, view.frame.size.height);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

#pragma mark -- actions
- (void)didComfirmOrRejectBtnClick {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"接受",@"拒绝", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateOrderRead"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
    
    if (buttonIndex == 0) {
        [dic setValue:[NSNumber numberWithInt:1] forKey:@"status"];
        
    } else if (buttonIndex == 1) {
        [dic setValue:[NSNumber numberWithInt:3] forKey:@"status"];
    }
    
    [cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            NSString *message = nil;
            if (buttonIndex == 0)
                message = @"您已经接受订单，请及时处理!";
            else if
                (buttonIndex == 1) message = @"您已经拒绝该订单";
            
            [[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        } else {
            NSLog(@"error with:%@",result);
        }
    }];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

- (id)didServiceDetailClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[[order_info objectForKey:@"service"] copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)didQRCodeBtnClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ScanQRCode");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)didContactBtnClick:(id)args {
    AYViewController* des = DEFAULTCONTROLLER(@"GroupChat");
//    id<AYCommand> des = DEFAULTCONTROLLER(@"GroupList");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}
@end
