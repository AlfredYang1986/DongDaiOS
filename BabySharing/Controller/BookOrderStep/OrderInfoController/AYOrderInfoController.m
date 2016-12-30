//
//  AYOrderInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 28/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoController.h"
#import "TmpFileStorageModel.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

@implementation AYOrderInfoController {
    
    NSDictionary *service_info;
	NSArray *order_times;
    NSDictionary *setedTimes;
    
    NSNumber *order_date;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
		service_info = [tmp objectForKey:kAYServiceArgsServiceInfo];
		order_times = [tmp objectForKey:@"order_times"];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        
        if ([args objectForKey:@"order_date"]) {
            order_date = [args objectForKey:@"order_date"];
            
            id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderInfo"];
            id<AYCommand> cmd_date = [cmd_recommend.commands objectForKey:@"setOrderDate:"];
            NSNumber *tmp = [order_date copy];
            [cmd_date performWithResult:&tmp];
            
            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
            id<AYCommand> cmd_refresh = [view_table.commands objectForKey:@"refresh"];
            [cmd_refresh performWithResult:nil];
        }
        if ([args objectForKey:@"start"]) {
            setedTimes = args;
            id times = [args copy];
            
            id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderInfo"];
            id<AYCommand> cmd_times = [cmd_recommend.commands objectForKey:@"setOrderTimes:"];
            [cmd_times performWithResult:&times];
            
            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
            id<AYCommand> cmd_refresh = [view_table.commands objectForKey:@"refresh"];
            [cmd_refresh performWithResult:nil];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderInfo"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    /****************************************/
    id<AYCommand> cmd_head = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* head_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&head_class];
    
    NSString* date_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&date_class];
    
    NSString* price_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&price_class];
    
    NSString* payway_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoPayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&payway_class];
    
    id<AYCommand> change_data = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
    NSDictionary *tmp = [service_info copy];
    [change_data performWithResult:&tmp];
    
//    id<AYCommand> cmd_nib = [view_table.commands objectForKey:@"registerCellWithNib:"];
//    NSString* nib_contact_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//    [cmd_nib performWithResult:&nib_contact_name];
//    /****************************************/
    
    UIButton *aplyBtn = [[UIButton alloc]init];
    [self.view addSubview:aplyBtn];
    [self.view bringSubviewToFront:aplyBtn];
    aplyBtn.backgroundColor = [Tools themeColor];
    [aplyBtn setTitle:@"申请预订" forState:UIControlStateNormal];
    aplyBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [aplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    [aplyBtn addTarget:self action:@selector(didAplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
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
    NSString *title = @"服务详情";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    [cmd_bot performWithResult:nil];
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [Tools garyBackgroundColor];
    return nil;
}

#pragma mark -- actions
- (void)didAplyBtnClick:(UIButton*)btn {
    
    if (!order_date) {
        NSString *title = @"您还没有预订时间";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithAction)
        return;
    }
    
    NSMutableDictionary *dic_order_info = [[NSMutableDictionary alloc]init];
    [dic_order_info setValue:[service_info copy] forKey:@"service_info"];   //service
    [dic_order_info setValue:[order_date copy] forKey:@"order_date"];       //date
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    
    if (!setedTimes) {
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:@"10:00" forKey:@"start"];
        [tmp setValue:@"12:00" forKey:@"end"];
        setedTimes = [tmp copy];
    }
    [dic_order_info setValue:[setedTimes copy] forKey:@"order_times"];      //times
    
    NSString *start = [setedTimes objectForKey:@"start"];
    NSString *end = [setedTimes objectForKey:@"end"];
    
    /**
     *  最小时长限制
     */
    int startClock = [start substringToIndex:2].intValue;
    int endClock = [end substringToIndex:2].intValue;
    int least = ((NSNumber*)[service_info objectForKey:@"least_hours"]).intValue;
    if (endClock - startClock < least) {
        
        NSString *title = [NSString stringWithFormat:@"您没有预定足够的时长:\n%d小时",least];
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmOrder");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:dic_order_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSHFROMBOT;
    [cmd_show_module performWithResult:&dic];
    
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
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
    
    //    NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
    //    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}

/**
 *  date
 */
- (id)didEditDate {
    
    AYHideBtmAlertView
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"SearchFilterDate");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[service_info objectForKey:@"offer_date"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
    return nil;
}

- (id)didEditTimes {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"OrderTimes");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_times = [[NSMutableDictionary alloc]init];
    [dic_times setValue:[setedTimes copy] forKey:@"order_times"];
    [dic_times setValue:[service_info objectForKey:@"least_hours"] forKey:@"least_hours"];
    [dic setValue:dic_times forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
    
    return nil;
}
/**
 *  price
 */
- (id)didShowDetailClick {
    
    UITableView *table_view = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_delegate = [self.delegates objectForKey:@"OrderInfo"];
    id<AYCommand> cmd_animation = [cmd_delegate.commands objectForKey:@"TransfromExpend"];
    [cmd_animation performWithResult:nil];
    
    [table_view beginUpdates];
    [table_view endUpdates];
    
    return nil;
}

@end