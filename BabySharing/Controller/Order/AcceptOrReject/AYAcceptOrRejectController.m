//
//  AYAcceptOrRejectController.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAcceptOrRejectController.h"
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

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@implementation AYAcceptOrRejectController {
    
    NSDictionary *order_info;
    
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
    self.view.backgroundColor = [Tools blackColor];
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
    
    UIButton *acceptBtn = [[UIButton alloc]init];
    [self.view addSubview:acceptBtn];
    acceptBtn.backgroundColor = [Tools themeColor];
    [acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
    acceptBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(order_detail.mas_bottom).offset(45);
        make.centerX.equalTo(self.view).offset(SCREEN_WIDTH * 0.25);
        make.size.mas_equalTo(CGSizeMake(145, 44));
    }];
    [acceptBtn addTarget:self action:@selector(didAcceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rejectBtn = [[UIButton alloc]init];
    [self.view addSubview:rejectBtn];
    rejectBtn.backgroundColor = [Tools blackColor];
    [rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    rejectBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rejectBtn.layer.borderWidth = 1.f;
    rejectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(order_detail.mas_bottom).offset(45);
        make.centerX.equalTo(self.view).offset(-SCREEN_WIDTH * 0.25);
        make.size.mas_equalTo(CGSizeMake(145, 44));
    }];
    [rejectBtn addTarget:self action:@selector(didRejectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dic_args = [order_info objectForKey:@"service"];
    NSNumber *unit_price = [dic_args objectForKey:@"price"];            //单价
    
    CGFloat sumPrice = 0;
    
    BOOL isLeave = ((NSNumber*)[dic_args objectForKey:@"allow_leave"]).boolValue;
    if (isLeave) {
        sumPrice += 40;
    }
    
    NSDictionary *dic_times = [order_info objectForKey:@"order_date"];
    double start = ((NSNumber*)[dic_times objectForKey:@"start"]).doubleValue;
    double end = ((NSNumber*)[dic_times objectForKey:@"end"]).doubleValue;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:start];
    NSString *order_dateStr = [format stringFromDate:today];
    
    NSDateFormatter *formatTimes = [[NSDateFormatter alloc] init];
    [formatTimes setDateFormat:@"HH:mm"];
//    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [formatTimes setTimeZone:timeZone];
    
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:start];
    NSString *startStr = [formatTimes stringFromDate:startTime];
    
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:end];
    NSString *endStr = [formatTimes stringFromDate:endTime];
    
    
    int startClock = [startStr substringToIndex:2].intValue;
    int endClock = [endStr substringToIndex:2].intValue;
    
    
    sumPrice = sumPrice + unit_price.floatValue * (endClock - startClock);
    
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
- (void)didAcceptBtnClick {
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateOrderInfo"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
    
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"status"];
    
    [cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        NSString *message = nil;
        if (success) {
            message = @"您已经接受订单，请及时处理!";
        } else {
            message = @"接受订单失败!请检查网络是否正常连接";
            NSLog(@"error with:%@",result);
        }
        [[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }];
}

- (void)didRejectBtnClick {
//    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
//    AYRemoteCallCommand *cmd_reject = [facade.commands objectForKey:@"RejectOrder"];
//    
//    NSDictionary* info = nil;
//    CURRENUSER(info)
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
//    [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
//    [dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
//    
//    [cmd_reject performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
//        if (success) {
//            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"have done rejected" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
//        } else {
//            
//        }
//    }];
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"RejectOrder");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[order_info objectForKey:@"order_id"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
}

#pragma mark -- notification
- (id)leftBtnSelected {
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
//    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    
//    id<AYCommand> cmd = POP;
//    [cmd performWithResult:&dic];
//    return nil;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = REVERSMODULE;
    [cmd performWithResult:&dic];
    return nil;
}

@end
