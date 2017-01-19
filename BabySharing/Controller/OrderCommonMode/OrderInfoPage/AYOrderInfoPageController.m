//
//  AYOrderInfoPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoPageController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#define btmViewHeight			64

@implementation AYOrderInfoPageController {
	
	NSDictionary *order_info;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		order_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderInfoPage"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	id tmp = [order_info copy];
	kAYDelegatesSendMessage(@"OrderInfoPage", @"changeQueryData:", &tmp)
	
	
	OrderStatus status = ((NSNumber*)[order_info objectForKey:@"status"]).intValue;
	AYViewController* compare = DEFAULTCONTROLLER(@"TabBarService");
	BOOL isNap = [self.tabBarController isKindOfClass:[compare class]];
	if (isNap) {
		
		if (status == OrderStatusPaid) {
			
			[Tools creatCALayerWithFrame:CGRectMake(0, SCREEN_HEIGHT - btmViewHeight, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
			UIButton *rejectBtn  = [Tools creatUIButtonWithTitle:@"拒绝" andTitleColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil];
			[Tools setViewBorder:rejectBtn withRadius:0 andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:nil];
			[self.view addSubview:rejectBtn];
			[rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view.mas_left).offset(SCREEN_WIDTH * 0.25);
				make.centerY.equalTo(self.view.mas_bottom).offset(-btmViewHeight*0.5);
				make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60) * 0.5, 40));
			}];
			[rejectBtn addTarget:self action:@selector(didRejectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			
			UIButton *acceptBtn  = [Tools creatUIButtonWithTitle:@"接受" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools themeColor]];
			[self.view addSubview:acceptBtn];
			[acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view.mas_right).offset(-SCREEN_WIDTH * 0.25);
				make.centerY.equalTo(rejectBtn);
				make.size.equalTo(rejectBtn);
			}];
			[acceptBtn addTarget:self action:@selector(didAcceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
		}
		
	} else {
		
//		NSString *tipsStr;
//		switch (status) {
//			case OrderStatusPaid:{
//				tipsStr = @"您的订单正等待处理";
//			}
//			break;
//			case OrderStatusConfirm:{
//				tipsStr = @"";
//			}
//			default:
//				tipsStr = @"";
//			break;
//		}
		if (status == OrderStatusPaid) {
			
			[Tools creatCALayerWithFrame:CGRectMake(0, SCREEN_HEIGHT - btmViewHeight, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
			UILabel *tipsLabel = [Tools creatUILabelWithText:@"您的订单正等待处理" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
			[self.view addSubview:tipsLabel];
			[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view);
				make.centerY.equalTo(self.view.mas_bottom).offset(-btmViewHeight * 0.5);
			}];
		}
	}
	
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
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	view.backgroundColor = [UIColor clearColor];
	//	NSString *title = @"确认信息";
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	
	//	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - btmViewHeight);
	return nil;
}

#pragma mark -- actions
- (void)didRejectBtnClick:(UIButton*)btn {
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_reject = [facade.commands objectForKey:@"RejectOrder"];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
	[dic setValue:[order_info objectForKey:@"user_id"] forKey:@"user_id"];
	[dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
	[dic setValue:[order_info objectForKey:@"owner_id"] forKey:@"owner_id"];
	[dic setValue:[order_info objectForKey:@"service_id"] forKey:@"service_id"];
//	[dic setValue:seasonOfTextView.text forKey:@"further_message"];
	
	[cmd_reject performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSString *title = @"已拒绝日程";
			[self popToRootVCWithTip:title];
		} else {
			
		}
	}];
}

- (void)didAcceptBtnClick {
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"AcceptOrder"];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	[dic setValue:[order_info objectForKey:@"user_id"] forKey:@"user_id"];
	[dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
	[dic setValue:[order_info objectForKey:@"owner_id"] forKey:@"owner_id"];
	[dic setValue:[order_info objectForKey:@"service_id"] forKey:@"service_id"];
	
	[cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		NSString *message = nil;
		if (success) {
			message = @"您已经接受订单，请及时处理!";
			[self popToRootVCWithTip:message];
		} else {
			message = @"接受订单失败!\n请检查网络是否正常连接";
			NSLog(@"error with:%@",result);
			[[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
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

- (void)popToDestVCWithTip:(NSString*)tip {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderCommon");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:tip forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POPTODEST;
	[cmd performWithResult:&dic];
	
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

- (id)didContactBtnClick {
	
	AYViewController* des = DEFAULTCONTROLLER(@"GroupChat");
	//    id<AYCommand> des = DEFAULTCONTROLLER(@"GroupList");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_chat = [[NSMutableDictionary alloc]init];
	[dic_chat setValue:[order_info objectForKey:@"owner_id"] forKey:@"owner_id"];
	
	NSDictionary* info = nil;
	CURRENUSER(info)
	NSString *user_id = [info objectForKey:@"user_id"];
	NSString *order_user_id = [order_info objectForKey:@"user_id"];
	NSString *order_owner_id = [order_info objectForKey:@"owner_id"];
	
	if ([user_id isEqualToString:order_owner_id]) {     //我发的服务
		[dic_chat setValue:order_user_id forKey:@"owner_id"];
	} else {
		[dic_chat setValue:order_owner_id forKey:@"owner_id"];
	}
	
	[dic setValue:dic_chat forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

@end
