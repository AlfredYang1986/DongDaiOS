//
//  AYConfirmOrderController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmOrderController.h"
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


@implementation AYConfirmOrderController {
    NSDictionary *order_info;
    NSString* order_id;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        order_info = [dic objectForKey:kAYControllerChangeArgsKey];
        //        NSLog(@"%@",order_info);
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools darkBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel = [Tools setLabelWith:tipsLabel andText:@"确认接受订单" andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150);
        make.centerX.equalTo(self.view);
    }];
    
    UIView *seprator = [UIView new];
    seprator.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seprator];
    [seprator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 1));
    }];
    
    UILabel *order_detail = [UILabel new];
    order_detail = [Tools setLabelWith:order_detail andText:nil andTextColor:[UIColor whiteColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    order_detail.numberOfLines = 0;
    [self.view addSubview:order_detail];
    [order_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seprator.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [self.view addSubview:confirmBtn];
    confirmBtn.backgroundColor = [Tools themeColor];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(order_detail.mas_bottom).offset(45);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(145, 44));
    }];
    [confirmBtn addTarget:self action:@selector(didConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dic_args = [order_info objectForKey:@"service_info"];
    NSNumber *unit_price = [dic_args objectForKey:@"price"];            //单价
    
    CGFloat sumPrice = 0;
    
    BOOL isLeave = ((NSNumber*)[dic_args objectForKey:@"allow_leave"]).boolValue;
    if (isLeave) {
        sumPrice += 40;
    }
    
    double start = ((NSNumber*)[order_info objectForKey:@"order_date"]).doubleValue;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:start];
    NSString *order_dateStr = [format stringFromDate:today];
    
    NSDictionary *setedTimes = [order_info objectForKey:@"order_times"];
    NSString *startStr = [setedTimes objectForKey:@"start"];
    NSString *endStr = [setedTimes objectForKey:@"end"];
    
    int startClock = [startStr substringToIndex:2].intValue;
    int endClock = [endStr substringToIndex:2].intValue;
    
    sumPrice += unit_price.floatValue * (endClock - startClock);
    
    NSString *detailStr = [NSString stringWithFormat:@"%@ %@-%@\n费用：￥%.f | 支付方式：微信",order_dateStr,startStr,endStr,sumPrice];
    order_detail.text = detailStr;
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
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 54);
    view.backgroundColor = [UIColor clearColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    //    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    //    NSString *title = @"待确认订单";
    //    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    //    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    //    [cmd_bot performWithResult:nil];
    
    return nil;
}

#pragma mark -- actions
- (void)didConfirmBtnClick:(UIButton*)btn {
    
    NSDictionary* args = nil;
    CURRENUSER(args)
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushOrder"];
    
    /**
     yyyyMMdd + HH:mm -> timeSpan
     */
    
    NSDictionary *service_info = [order_info objectForKey:@"service_info"];
    NSNumber *order_date = [order_info objectForKey:@"order_date"];
    if (!order_date) {
        
        NSString *title = @"您还没有预订时间";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:order_date.doubleValue];
    NSString *dateStr = [format stringFromDate:today];
    
    NSDictionary *setedTimes = [order_info objectForKey:@"order_times"];
    NSString *start = [setedTimes objectForKey:@"start"];
    NSString *end = [setedTimes objectForKey:@"end"];
    
    /**
     *  最小时长限制
     */
    int startClock = [start substringToIndex:2].intValue;
    int endClock = [end substringToIndex:2].intValue;
    
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
    [dic_date setValue:[NSNumber numberWithDouble:startSpan*1000] forKey:@"start"];
    [dic_date setValue:[NSNumber numberWithDouble:endSpan*1000] forKey:@"end"];
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    [dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:@"owner_id"];
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
    sumPrice = 1;
    
    [dic_push setValue:[NSNumber numberWithFloat:sumPrice] forKey:@"total_fee"];
    
    [cmd_push performWithResult:[dic_push copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            // 支付
            id<AYFacadeBase> facade = [self.facades objectForKey:@"SNSWechat"];
            AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"PayWithWechat"];
            
            NSMutableDictionary* pay = [[NSMutableDictionary alloc]init];
            [pay setValue:[result objectForKey:@"prepay_id"] forKey:@"prepay_id"];
            
            [cmd performWithResult:&pay];
           
            order_id = [result objectForKey:@"order_id"];
            
        } else {
            
            NSString *title = @"服务预订失败\n请改善网络环境并重试";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
}

- (void)popToRootVCWithTip:(NSString*)tip {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:tip forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
    
}

#pragma mark -- notification
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}


- (id)WechatPaySuccess:(id)args {
    
    NSDictionary* user = nil;
    CURRENUSER(user)
    
    // 支付成功
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"PayOrder"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:order_id forKey:@"order_id"];

    NSDictionary *service_info = [order_info objectForKey:@"service_info"];
    [dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    [dic setValue:[service_info objectForKey:@"owner_id"] forKey:@"owner_id"];
    [dic setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSString *title = @"服务预订成功";
            [self popToRootVCWithTip:title];
        } else {
            NSString *title = @"服务预订支付失败";
            [self popToRootVCWithTip:title];
        }
    }];
    return nil;
}

- (id)WechatPayFailed:(id)args {
    NSString *title = @"服务预订支付失败";
    [self popToRootVCWithTip:title];
    return nil;
}
@end
