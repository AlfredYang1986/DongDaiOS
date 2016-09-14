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

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#import "Tools.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@implementation AYOrderInfoController{
    
    NSDictionary *service_info;
    NSDictionary *setedTimes;
    
    NSNumber *order_date;
    
    UIView *alertView;
    UILabel *order_detail;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
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
    self.view.backgroundColor = [Tools garyBackgroundColor];
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
    [aplyBtn setTitle:@"申请预定" forState:UIControlStateNormal];
    aplyBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [aplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    [aplyBtn addTarget:self action:@selector(didAplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *  alert page
     */
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alertView.backgroundColor = [Tools blackColor];
    [self.tabBarController.view addSubview:alertView];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:IMGRESOURCE(@"bar_left_white") forState:UIControlStateNormal];
    [alertView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView).offset(20);
        make.top.equalTo(alertView).offset(35);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [closeBtn addTarget:self action:@selector(didCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel = [Tools setLabelWith:tipsLabel andText:@"确认您的订单" andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [alertView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertView).offset(150);
        make.centerX.equalTo(alertView);
    }];
    
    UIView *seprator = [UIView new];
    seprator.backgroundColor = [UIColor whiteColor];
    [alertView addSubview:seprator];
    [seprator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(10);
        make.centerX.equalTo(alertView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 1));
    }];
    
    order_detail = [UILabel new];
    order_detail = [Tools setLabelWith:order_detail andText:nil andTextColor:[UIColor whiteColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    order_detail.numberOfLines = 0;
    [alertView addSubview:order_detail];
    [order_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seprator.mas_bottom).offset(10);
        make.centerX.equalTo(alertView);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [alertView addSubview:confirmBtn];
    confirmBtn.backgroundColor = [Tools themeColor];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(order_detail.mas_bottom).offset(45);
        make.centerX.equalTo(alertView);
        make.size.mas_equalTo(CGSizeMake(145, 44));
    }];
    [confirmBtn addTarget:self action:@selector(didConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    NSString *title = @"订单详情";
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
- (void)didCloseBtnClick {
    [UIView animateWithDuration:0.25 animations:^{
        alertView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5 + SCREEN_HEIGHT);
    }];
}

- (void)didAplyBtnClick:(UIButton*)btn {
    
    if (!order_date) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有预订时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:order_date.doubleValue];
    NSString *order_dateStr = [format stringFromDate:today];
    
    
    if (!setedTimes) {
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:@"10:00" forKey:@"start"];
        [tmp setValue:@"12:00" forKey:@"end"];
        setedTimes = [tmp copy];
    }
    NSString *start = [setedTimes objectForKey:@"start"];
    NSString *end = [setedTimes objectForKey:@"end"];
    
    /**
     *  最小时长限制
     */
    int startClock = [start substringToIndex:2].intValue;
    int endClock = [end substringToIndex:2].intValue;
    if (endClock - startClock < ((NSNumber*)[service_info objectForKey:@"least_hours"]).intValue) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有预订足够的时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    CGFloat sumPrice = 0;
    BOOL isLeave = ((NSNumber*)[service_info objectForKey:@"allow_leave"]).boolValue;
    if (isLeave) {
        sumPrice += 40;
    }
    NSNumber *unit_price = [service_info objectForKey:@"price"];
    sumPrice += unit_price.floatValue * (endClock - startClock);
    
    NSString *detailStr = [NSString stringWithFormat:@"%@ %@-%@\n费用：￥%.f | 支付方式：微信",order_dateStr,start,end,sumPrice];
    order_detail.text = detailStr;
    
    [UIView animateWithDuration:0.25 animations:^{
        alertView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    }];
}

- (void)didConfirmBtnClick:(UIButton*)btn {
    
    NSDictionary* args = nil;
    CURRENUSER(args)
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushOrder"];
    
    
    /**
     yyyyMMdd + HH:mm -> timeSpan
     */
    
    if (!order_date) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有预订时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:order_date.doubleValue];
    NSString *dateStr = [format stringFromDate:today];
    
    NSString *start = [setedTimes objectForKey:@"start"];
    NSString *end = [setedTimes objectForKey:@"end"];
    
    /**
     *  最小时长限制
     */
    int startClock = [start substringToIndex:2].intValue;
    int endClock = [end substringToIndex:2].intValue;
    if (endClock - startClock < ((NSNumber*)[service_info objectForKey:@"least_hours"]).intValue) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有预订足够的时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSString *dateStartStr = [dateStr stringByAppendingString:start];
    NSString *dateEndStr = [dateStr stringByAppendingString:end];
    
    NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
    [format2 setDateFormat:@"yyyy年MM月dd日HH:mm"];
    [format2 setTimeZone:timeZone];
    NSDate *date_start = [format2 dateFromString:dateStartStr];
    NSDate *date_end = [format2 dateFromString:dateEndStr];
    
    NSTimeInterval startSpan = date_start.timeIntervalSince1970;
    NSTimeInterval endSpan = date_end.timeIntervalSince1970;
    
    NSMutableDictionary *dic_date = [[NSMutableDictionary alloc]init];
    [dic_date setValue:[NSNumber numberWithDouble:startSpan] forKey:@"start"];
    [dic_date setValue:[NSNumber numberWithDouble:endSpan] forKey:@"end"];
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    [dic_push setValue:[args objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_push setValue:[[service_info objectForKey:@"images"] objectAtIndex:0] forKey:@"order_thumbs"];
    [dic_push setValue:dic_date forKey:@"order_date"];
    [dic_push setValue:[service_info objectForKey:@"title"] forKey:@"order_title"];
    
    CGFloat sumPrice = 0;
    BOOL isLeave = ((NSNumber*)[service_info objectForKey:@"allow_leave"]).boolValue;
    if (isLeave) {
        sumPrice += 40;
    }
    NSNumber *unit_price = [service_info objectForKey:@"price"];
    sumPrice += unit_price.floatValue * (endClock - startClock);
    
    [dic_push setValue:[NSNumber numberWithFloat:sumPrice] forKey:@"total_fee"];
    
    [cmd_push performWithResult:[dic_push copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"服务预订成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            // 支付
            id<AYFacadeBase> facade = [self.facades objectForKey:@"SNSWechat"];
            AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"PayWithWechat"];
            
            NSMutableDictionary* pay = [[NSMutableDictionary alloc]init];
            [pay setValue:[result objectForKey:@"prepay_id"] forKey:@"prepay_id"];
            
            [cmd performWithResult:&pay];
            
        }else {
            NSLog(@"push error with:%@",result);
            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务预订失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
        [self didCloseBtnClick];
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
    id<AYCommand> des = DEFAULTCONTROLLER(@"SearchFilterDate");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:@"order_set_date" forKey:kAYControllerChangeArgsKey];
    
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
    [dic setValue:setedTimes forKey:kAYControllerChangeArgsKey];
    
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

- (id)WechatPaySuccess:(id)args {
    return nil;
}

- (id)WechatPayFailed:(id)args {
    return nil;
}
@end
