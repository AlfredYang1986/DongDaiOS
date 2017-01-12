//
//  AYOrderInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 28/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderMainController.h"
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

@implementation AYBOrderMainController {
	
	NSDictionary *order_info;
	
    NSDictionary *service_info;
	NSMutableArray *order_times;
	NSArray *initialTimeData;
	NSDictionary *setedTimes;
	
	int edit_note;
	NSString* order_id;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        order_info = [dic objectForKey:kAYControllerChangeArgsKey];
		service_info = [order_info objectForKey:kAYServiceArgsServiceInfo];
//		order_times = [[order_info objectForKey:@"order_times"] mutableCopy];
		order_times = [order_info objectForKey:@"order_times"];
		initialTimeData = [order_times copy];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
		[order_times replaceObjectAtIndex:edit_note withObject:args];
		
//		id tmp = [order_info copy];
//		kAYDelegatesSendMessage(@"BOrderMain", @"changeQueryData:", &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BOrderMain"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    /****************************************/
    id<AYCommand> cmd_head = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* head_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&head_class];
    
    NSString* date_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&date_class];
    
    NSString* price_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&price_class];
    
    NSString* payway_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&payway_class];
    
    id<AYCommand> change_data = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
    NSDictionary *tmp = [order_info copy];
    [change_data performWithResult:&tmp];
    
//    id<AYCommand> cmd_nib = [view_table.commands objectForKey:@"registerCellWithNib:"];
//    NSString* nib_contact_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//    [cmd_nib performWithResult:&nib_contact_name];
//    /****************************************/
    
    UIButton *aplyBtn = [Tools creatUIButtonWithTitle:@"去支付" andTitleColor:[Tools whiteColor] andFontSize:-16.f andBackgroundColor:[Tools themeColor]];
    [self.view addSubview:aplyBtn];
    [aplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
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
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
    NSString *title = @"确认信息";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    return nil;
}

#pragma mark -- actions
- (void)didAplyBtnClick:(UIButton*)btn {
	
	id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
	id<AYCommand> cmd_login = [f.commands objectForKey:@"IsInstalledWechat"];
	NSNumber *IsInstalledWechat = [NSNumber numberWithBool:NO];
	[cmd_login performWithResult:&IsInstalledWechat];
	if (!IsInstalledWechat.boolValue) {
		NSString *title = @"暂仅支持微信支付！";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return;
	}
	
	CGFloat sumPrice = 0;
	NSString *unitCat = @"UNIT";
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	__block int count_times = 0;
	
	if (service_cat.intValue == ServiceTypeLookAfter) {
		
		unitCat = @"小时";
		[order_times enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			NSNumber *start = [obj objectForKey:kAYServiceArgsStart];
			NSNumber *end = [obj objectForKey:kAYServiceArgsEnd];
			
			double duration = end.doubleValue * 0.001 - start.doubleValue * 0.001 ;
			count_times += (duration / 60 / 60);
		}];
		
	} else if (service_cat.intValue == ServiceTypeCourse) {
		unitCat = @"次";
		count_times = (int)order_times.count;
	} else {
		
	}
	
	NSNumber *unit_price = [service_info objectForKey:kAYServiceArgsPrice];
	sumPrice += (unit_price.floatValue * count_times) * 100;
#ifdef SANDBOX
	sumPrice = 1.f;
#endif
	
	NSDictionary *dic_date = [order_times firstObject];
	NSDictionary* args = nil;
	CURRENUSER(args)
	
	NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	[dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:@"owner_id"];
	[dic_push setValue:[args objectForKey:@"user_id"] forKey:@"user_id"];
	[dic_push setValue:[[service_info objectForKey:@"images"] objectAtIndex:0] forKey:@"order_thumbs"];
	[dic_push setValue:dic_date forKey:@"order_date"];
	[dic_push setValue:[service_info objectForKey:@"title"] forKey:@"order_title"];
	[dic_push setValue:[NSNumber numberWithFloat:sumPrice] forKey:@"total_fee"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushOrder"];
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
- (void)BtmAlertOtherBtnClick {
	NSLog(@"didOtherBtnClick");
	[super BtmAlertOtherBtnClick];
	
	[super tabBarVCSelectIndex:2];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	id<AYCommand> dest = DEFAULTCONTROLLER(@"BOrderTime");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd = POPTODEST;
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

- (id)setOrderTime:(NSNumber*)index {
	
	edit_note = index.intValue;
	
    id<AYCommand> des = DEFAULTCONTROLLER(@"OrderTimes");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_times = [[NSMutableDictionary alloc]init];
    [dic_times setValue:[order_times objectAtIndex:edit_note] forKey:@"order_time"];
    [dic_times setValue:[initialTimeData objectAtIndex:edit_note] forKey:@"initail"];
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
    id<AYDelegateBase> cmd_delegate = [self.delegates objectForKey:@"BOrderMain"];
    id<AYCommand> cmd_animation = [cmd_delegate.commands objectForKey:@"TransfromExpend"];
    [cmd_animation performWithResult:nil];
    
    [table_view beginUpdates];
    [table_view endUpdates];
    
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
	[dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	[dic setValue:[service_info objectForKey:@"owner_id"] forKey:@"owner_id"];
	[dic setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
	
	[cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			NSString *title = @"服务预订成功,去日程查看";
			//            [self popToRootVCWithTip:title];
			AYShowBtmAlertView(title, BtmAlertViewTypeWitnBtn)
			
		} else {
			NSString *title = @"当前网络太慢,服务预订发生错误,请联系客服!";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
	return nil;
}

- (id)WechatPayFailed:(id)args {
	NSString *title = @"微信支付失败\n请改善网络环境并重试";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	return nil;
}

@end