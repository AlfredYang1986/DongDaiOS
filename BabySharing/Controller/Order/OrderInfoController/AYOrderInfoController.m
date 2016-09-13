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
    NSMutableArray *loading_status;
    
    UIImageView *orderImage;
    UILabel *orderTitle;
    UILabel *orderOwner;
    UILabel *orderLoc;
    
    NSDictionary *service_info;
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
            id date = [args objectForKey:@"order_date"];
            id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderInfo"];
            id<AYCommand> cmd_date = [cmd_recommend.commands objectForKey:@"setOrderDate:"];
            [cmd_date performWithResult:&date];
            
            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
            id<AYCommand> cmd_refresh = [view_table.commands objectForKey:@"refresh"];
            [cmd_refresh performWithResult:nil];
        }
        if ([args objectForKey:@"order_times"]) {
            id times = [args objectForKey:@"order_times"];
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
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [self.view addSubview:confirmBtn];
    [self.view bringSubviewToFront:confirmBtn];
    confirmBtn.backgroundColor = [Tools themeColor];
    [confirmBtn setTitle:@"申请预定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
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
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

//- (id)TimeOptionLayout:(UIView*)view {
//    CGFloat margin = 15.f;
//    view.frame = CGRectMake(margin, 64 + 100 + 10, SCREEN_WIDTH - margin * 2, view.frame.size.height);
//    view.backgroundColor = [UIColor whiteColor];
//    return nil;
//}
//
//- (id)PayOptionLayout:(UIView*)view {
//    view.frame = CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT - 264);
//    view.backgroundColor = [UIColor whiteColor];
//    return nil;
//}
//
//- (id)LoadingLayout:(UIView*)view {
//    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    view.hidden = YES;
//    return nil;
//}

#pragma mark -- actions
-(void)didConfirmBtnClick:(UIButton*)btn {
    
    NSDictionary* args = nil;
    CURRENUSER(args)
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushOrder"];
    
    id<AYViewBase> view_time =  [self.views objectForKey:@"TimeOption"];
    NSDictionary *dic_date = nil;
    id<AYCommand> query_cmd = [view_time.commands objectForKey:@"queryDateStartAndEnd:"];
    [query_cmd performWithResult:&dic_date];
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    [dic_push setValue:[args objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_push setValue:[[service_info objectForKey:@"images"] objectAtIndex:0] forKey:@"order_thumbs"];
    [dic_push setValue:dic_date forKey:@"order_date"];
    [dic_push setValue:[service_info objectForKey:@"title"] forKey:@"order_title"];
    [dic_push setValue:[service_info objectForKey:@"price"] forKey:@"price"];
    
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
    [dic setValue:@"order_set_times" forKey:kAYControllerChangeArgsKey];
    
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
