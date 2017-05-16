//
//  AYOrderCommonController.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderCommonController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYOrderTOPView.h"
#import <objc/runtime.h>

#define TOPHEIGHT		165

@implementation AYOrderCommonController {
	
//	UILabel *leastNews;
	AYOrderTOPView *TOPView;
	
	NSArray *remindArr;
	
	NSArray *result_status_fb;
	NSArray *OrderOfAll;
	NSTimeInterval queryTimespan;
	NSInteger skipCount;
	
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSString* method_name = [dic objectForKey:kAYControllerChangeArgsKey];
		
		SEL sel = NSSelectorFromString(method_name);
		Method m = class_getInstanceMethod([self class], sel);
		if (m) {
			IMP imp = method_getImplementation(m);
			id (*func)(id, SEL, ...) = imp;
			func(self, sel);
		}
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	skipCount = 0;
	queryTimespan = [NSDate date].timeIntervalSince1970 * 1000;
	
	/****************************************/
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	[self.view bringSubviewToFront:tableView];
	/****************************************/
	
	UIButton *allNewsBtn  = [Tools creatUIButtonWithTitle:@"全部订单" andTitleColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil];
	[self.view addSubview:allNewsBtn];
	[allNewsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.view.mas_top).offset(42);
		make.right.equalTo(self.view).offset(-20);
		make.size.mas_equalTo(CGSizeMake(70, 30));
	}];
	[allNewsBtn addTarget:self action:@selector(didAllNewsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	TOPView = [[AYOrderTOPView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, TOPHEIGHT) andMode:OrderModeCommon];
	[self.view addSubview:TOPView];
	TOPView.userInteractionEnabled = YES;
	[TOPView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAppliFeedback)]];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderCommon"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self loadNewData];
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
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
	view.frame = CGRectMake(0, kStatusAndNavBarH+TOPHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH-TOPHEIGHT - kTabBarH);
	//预设高度
//	((UITableView*)view).estimatedRowHeight = 120;
//	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
	return nil;
}

#pragma mark -- actions
- (void)showAppliFeedback {
	id<AYCommand> des;
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	
	if (result_status_fb.count == 1 ) {
		des = DEFAULTCONTROLLER(@"OrderInfoPage");
		[dic setValue:[result_status_fb firstObject] forKey:kAYControllerChangeArgsKey];
	} else {
		des = DEFAULTCONTROLLER(@"AppliFBList");
		[dic setValue:[result_status_fb copy] forKey:kAYControllerChangeArgsKey];
	}
	
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
//	return nil;
}

- (void)didAllNewsBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderListNews");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[OrderOfAll copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	
}

#pragma mark -- actions
- (void)loadNewData { //queryReminds
	
	[self queryOrders];
	
	NSDictionary* info = nil;
	CURRENUSER(info)
	NSMutableDictionary *dic_query = [[NSMutableDictionary alloc] initWithDictionary:info];
	NSDictionary *condition = @{@"order_user_id":[info objectForKey:@"user_id"], @"status":[NSNumber numberWithInt:OrderStatusPaid], @"only_history":[NSNumber numberWithInt:1]};
	[dic_query setValue:condition forKey:@"condition"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryRemind"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			remindArr = [result copy];
			id tmp = [result copy];
			kAYDelegatesSendMessage(@"OrderCommon", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		}
	}];
}

- (id)queryOrders {
	
	NSDictionary *info;
	CURRENUSER(info)
	
	NSMutableDictionary *dic_query = [[NSMutableDictionary alloc] initWithDictionary:info];
//	[dic_query setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
	NSDictionary *condition = @{@"order_user_id":[info objectForKey:@"user_id"]};
	[dic_query setValue:condition forKey:@"condition"];
	
	[dic_query setValue:[NSNumber numberWithDouble:queryTimespan] forKey:@"date"];
	[dic_query setValue:[NSNumber numberWithInteger:skipCount] forKey:@"skin"];
	[dic_query setValue:[NSNumber numberWithInt:20] forKey:@"take"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrders"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSArray *resultArr = [result objectForKey:@"result"];
			OrderOfAll = [resultArr copy];
			
			NSPredicate *pred_accept = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusAccepted];
			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusReject];
			NSPredicate *pred_fb = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_accept, pred_reject]];
			result_status_fb = [resultArr filteredArrayUsingPredicate:pred_fb];
			
			TOPView.userInteractionEnabled = result_status_fb.count != 0;
			[TOPView setItemArgs:result_status_fb];
			
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
		[((UITableView*)view_future).mj_header endRefreshing];
		
	}];
	
	return nil;
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

- (id)didSelectedRow:(NSDictionary*)args {
	
	NSDictionary *dic_remind = [args objectForKey:@"info"];
	NSDictionary* info = nil;
	CURRENUSER(info)
	
	NSNumber *type = [args objectForKey:@"type"];
	if (type.integerValue == 1) {
		
		NSMutableDictionary *dic_query = [info mutableCopy];
		NSDictionary *condition = @{kAYOrderArgsID:[dic_remind objectForKey:kAYOrderArgsID]};
		[dic_query setValue:condition forKey:@"condition"];
		
		id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
		AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrders"];
		[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				id tmp = [[result objectForKey:@"result"] firstObject];
				
				id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
				NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
				[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
				[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
				[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
				[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
				id<AYCommand> cmd_push = PUSH;
				[cmd_push performWithResult:&dic];
			} else {
				NSString *title = @"请改善网络环境并重试";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
		
	} else {
		
		NSMutableDictionary *dic_query = [info mutableCopy];
		[dic_query setValue:[dic_remind objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
		
		id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
		AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryServiceDetail"];
		[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				id tmp = [result objectForKey:@"result"];
				
				id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
				NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
				[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
				[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
				[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
				[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
				
				id<AYCommand> cmd_push = PUSH;
				[cmd_push performWithResult:&dic];
				
			} else {
				NSString *title = @"请改善网络环境并重试";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	
	return nil;
}

@end
