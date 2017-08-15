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
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OPPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"UnSubsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
//	NSMutableDictionary *dic_query = [Tools getBaseRemoteData];
//	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[[order_info objectForKey:kAYOrderArgsSelf] objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
//	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
//	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrderDetail"];
//	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//		if (success) {
//			
//		} else {
//			NSString *title = @"请改善网络环境并重试";
//			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//		}
//	}];
	
	id tmp = [order_info copy];
	kAYDelegatesSendMessage(@"OrderInfoPage", @"changeQueryData:", &tmp)
	
	UIView *BTMView = [UIView new];
	BTMView.backgroundColor = [Tools whiteColor];
	[self.view addSubview:BTMView];
	
	OrderStatus status = ((NSNumber*)[order_info objectForKey:@"status"]).intValue;
	AYViewController* compare = DEFAULTCONTROLLER(@"TabBarService");
	BOOL isNap = [self.tabBarController isKindOfClass:[compare class]];
	if (isNap) {
		
		if (status == OrderStatusPosted) {
			
			CGFloat btmView_height = 64.f;
			BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - btmView_height, SCREEN_WIDTH, btmView_height);
			
			UIButton *rejectBtn  = [Tools creatUIButtonWithTitle:@"拒绝" andTitleColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil];
			[Tools setViewBorder:rejectBtn withRadius:0 andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:nil];
			[BTMView addSubview:rejectBtn];
			[rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(BTMView).offset(20);
				make.centerY.equalTo(BTMView);
				make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60) * 0.5, 40));
			}];
			[rejectBtn addTarget:self action:@selector(didRejectBtnClick) forControlEvents:UIControlEventTouchUpInside];
			
			UIButton *acceptBtn  = [Tools creatUIButtonWithTitle:@"接受" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools themeColor]];
			[BTMView addSubview:acceptBtn];
			[acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
				make.right.equalTo(BTMView).offset(-20);
				make.centerY.equalTo(BTMView);
				make.size.equalTo(rejectBtn);
			}];
			[acceptBtn addTarget:self action:@selector(didAcceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
		}
		else if (status == OrderStatusCancel) {
			
			BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - kTabBarH, SCREEN_WIDTH, kTabBarH);
			
			NSString *resonStr = [NSString stringWithFormat:@"RESON:%@", [order_info objectForKey:kAYOrderArgsFurtherMessage]];
			UILabel *tipsLabel = [Tools creatUILabelWithText:resonStr andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
			[BTMView addSubview:tipsLabel];
			[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(BTMView).offset(20);
				make.centerY.equalTo(BTMView);
			}];
		}
		else {
			BTMView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
		}
		
	} else {	//用户方
		
		if (status == OrderStatusAccepted) {
			CGFloat btmView_height = 49.f;
			BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - btmView_height, SCREEN_WIDTH, btmView_height);
			
			UIButton *gotoPayBtn = [Tools creatUIButtonWithTitle:@"去支付" andTitleColor:[Tools whiteColor] andFontSize:314.f andBackgroundColor:[Tools themeColor]];
			[BTMView addSubview:gotoPayBtn];
			[gotoPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(BTMView);
				make.centerX.equalTo(BTMView);
				make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kTabBarH));
			}];
			[gotoPayBtn addTarget:self action:@selector(didGoPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
			
			UIButton *cancelBtn = [Tools creatUIButtonWithTitle:@"取消预订申请" andTitleColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
			[BTMView addSubview:cancelBtn];
			[cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(gotoPayBtn.mas_top);
				make.centerX.equalTo(BTMView);
				make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kTabBarH));
			}];
			[cancelBtn addTarget:self action:@selector(didCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
			cancelBtn.hidden = YES;
		}
		else if (status == OrderStatusCancel) {
			
			BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - kTabBarH, SCREEN_WIDTH, kTabBarH);
			
			NSString *resonStr = [NSString stringWithFormat:@"取消原因:%@", [order_info objectForKey:kAYOrderArgsFurtherMessage]];
			UILabel *tipsLabel = [Tools creatUILabelWithText:resonStr andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
			[BTMView addSubview:tipsLabel];
			[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(BTMView).offset(20);
				make.centerY.equalTo(BTMView);
			}];
		}
		else {
			BTMView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
		}
	}
	
	//最后添线
	[Tools creatCALayerWithFrame:CGRectMake(0,  0, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:BTMView];
	
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	[view_table mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(kStatusAndNavBarH);
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.bottom.equalTo(BTMView.mas_top);
	}];
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
//	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - btmViewHeight);
	return nil;
}

#pragma mark -- Common actions
- (void)didGoPayBtnClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"PAYPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:order_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic];
}

- (void)didCancelBtnClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"UnSubsPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:order_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic];
}

#pragma mark -- Servant actions
- (void)didRejectBtnClick {
	NSDictionary *user;
	CURRENUSER(user);
	
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_status = [[NSMutableDictionary alloc] init];
	[dic_status setValue:[NSNumber numberWithInt:OrderStatusReject] forKey:kAYOrderArgsStatus];
	[dic setValue:dic_status forKey:kAYOrderArgsSelf];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd_reject = [facade.commands objectForKey:@"RejectOrder"];
	[cmd_reject performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSString *title = @"订单已拒绝";
//			[self popToRootVCWithTip:title];
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"RemoteBack");
			NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
			[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
			[dic setValue:@{@"FBType":@"FBTypeRejectOrder", kAYCommArgsTips:title} forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd_push = PUSH;
			[cmd_push performWithResult:&dic];
			
		} else {
			NSString *message = @"拒绝订单申请失败!\n请检查网络是否正常连接";
			AYShowBtmAlertView(message, BtmAlertViewTypeHideWithTimer)
		}
	}];
}

- (void)didAcceptBtnClick {
	NSDictionary *user;
	CURRENUSER(user);
	
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_status = [[NSMutableDictionary alloc] init];
	[dic_status setValue:[NSNumber numberWithInt:OrderStatusAccepted] forKey:kAYOrderArgsStatus];
	[dic setValue:dic_status forKey:kAYOrderArgsSelf];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"AcceptOrder"];
	[cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		NSString *message = nil;
		if (success) {
			message = @"订单已接受";
//			[self popToRootVCWithTip:message];
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"RemoteBack");
			NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
			[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
			[dic setValue:@{@"FBType":@"FBTypeAcceptOrder", kAYCommArgsTips:message} forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd_push = PUSH;
			[cmd_push performWithResult:&dic];
			
		} else {
			message = @"接受订单申请失败!\n请检查网络是否正常连接";
			AYShowBtmAlertView(message, BtmAlertViewTypeHideWithTimer)
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
	
	AYViewController* des = DEFAULTCONTROLLER(@"SingleChat");
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

- (id)unsubsOrder {
	[self didCancelBtnClick];
	return nil;
}

@end
