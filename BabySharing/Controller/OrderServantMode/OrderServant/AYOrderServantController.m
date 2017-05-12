//
//  AYOrderServantController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderServantController.h"
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

#define TOPHEIGHT		155
#define HISTORYBTNHEIGHT		60

@implementation AYOrderServantController {
//	UILabel *noticeNews;
	AYOrderTOPView *TOPView;
	
	NSArray *remindArr;
	NSArray *result_status_posted;
	NSArray *result_status_paid_cancel;
	NSArray *result_status_past;
	
	NSTimeInterval queryTimespan;
	NSInteger skipCount;
	
	NSTimeInterval queryTimespanRemind;
	NSInteger skipCountRemind;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	skipCount = skipCountRemind = 0;
	queryTimespan = queryTimespanRemind = [NSDate date].timeIntervalSince1970 * 1000;
	
	TOPView = [[AYOrderTOPView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, TOPHEIGHT) andMode:OrderModeServant];
	[self.view addSubview:TOPView];
	TOPView.userInteractionEnabled = YES;
	[TOPView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTodoApplyAndBack)]];
	
	UIButton *readMoreBtn = [Tools creatUIButtonWithTitle:@"查看全部" andTitleColor:[Tools themeColor] andFontSize:15.f andBackgroundColor:nil];
	[self.view addSubview:readMoreBtn];
	[readMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(TOPView).offset(-20);
		make.top.equalTo(TOPView).offset(10);
		make.size.mas_equalTo(CGSizeMake(70, 30));
	}];
	[readMoreBtn addTarget:self action:@selector(didReadMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *historyBtn = [Tools creatUIButtonWithTitle:@"查看历史记录" andTitleColor:[Tools themeColor] andFontSize:15.f andBackgroundColor:nil];
	historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[historyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,20, 0, 0)];
	[self.view addSubview:historyBtn];
	[historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(TOPView.mas_bottom).offset(0);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, HISTORYBTNHEIGHT));
	}];
	[historyBtn addTarget:self action:@selector(didHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[Tools creatCALayerWithFrame:CGRectMake(0, HISTORYBTNHEIGHT - 0.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:historyBtn];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderServant"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TodoApplyCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HistoryEnterCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"DayRemindCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self loadNewData];
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 40+TOPHEIGHT+HISTORYBTNHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - kTabBarH - TOPHEIGHT - HISTORYBTNHEIGHT);
	return nil;
}

#pragma mark -- actions
- (void)didHistoryBtnClick {
	[self showHistoryAppli];
}
- (void)didReadMoreBtnClick {
	[self showMoreAppli];
}

- (void)loadNewData {
	[self queryOrders];
	
	
	NSDictionary* info = nil;
	CURRENUSER(info)
	NSMutableDictionary *dic_query = [info mutableCopy];
//	[dic_query setValue:[info objectForKey:@"user_id"] forKey:@"owner_id"];
	NSDictionary *condition = @{kAYCommArgsOwnerID:[info objectForKey:@"user_id"], @"status":[NSNumber numberWithInt:OrderStatusPaid]};
	[dic_query setValue:condition forKey:@"condition"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryRemind"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			remindArr = [result copy];
			id tmp = [result copy];
			kAYDelegatesSendMessage(@"OrderServant", @"changeQueryData:", &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		}
	}];
}

- (void)queryOrders {
	NSDictionary* info = nil;
	CURRENUSER(info)
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrders"];
	
	NSMutableDictionary *dic_query = [info mutableCopy];
//	[dic_query setValue:[info objectForKey:@"user_id"] forKey:@"owner_id"];
	NSDictionary *condition = @{kAYCommArgsOwnerID:[info objectForKey:@"user_id"]};
	[dic_query setValue:condition forKey:@"condition"];
	
	[dic_query setValue:[NSNumber numberWithDouble:queryTimespan] forKey:@"date"];
	[dic_query setValue:[NSNumber numberWithInteger:skipCount] forKey:@"skin"];
	[dic_query setValue:[NSNumber numberWithInt:20] forKey:@"take"];
	
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *resultArr = [result objectForKey:@"result"];
			queryTimespan = ((NSNumber*)[result objectForKey:@"date"]).doubleValue;
			
			NSPredicate *pred_ready = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusPosted];
			result_status_posted = [resultArr filteredArrayUsingPredicate:pred_ready];
			[TOPView setItemArgs:result_status_posted];
			
			NSPredicate *pred_paid = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusPaid];
			NSPredicate *pred_cancel = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusCancel];
			NSPredicate *pred_fb = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_paid, pred_cancel]];
			result_status_paid_cancel = [resultArr filteredArrayUsingPredicate:pred_fb];
			
			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusReject];
			NSPredicate *pred_done = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusDone];
			NSPredicate *pred_past = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_reject, pred_cancel, pred_done, pred_paid]];
			result_status_past = [resultArr filteredArrayUsingPredicate:pred_past];
			
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
		[((UITableView*)view_future).mj_header endRefreshing];
	}];
	
}

- (void)showTodoApplyAndBack {
	
	id<AYCommand> des;
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	
	if (result_status_posted.count == 1 ) {
		des = DEFAULTCONTROLLER(@"OrderInfoPage");
		[dic setValue:[result_status_posted firstObject] forKey:kAYControllerChangeArgsKey];
	}
	else if (result_status_posted.count > 1) {
		des = DEFAULTCONTROLLER(@"MoreAppli");
		NSDictionary *tmp = @{@"todo":result_status_posted, @"feedback":result_status_paid_cancel};
		[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	}
	
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

- (void)didHistoryBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServantHistory");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[result_status_past copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
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

- (id)showLeastOneAppli {
	
	return nil;
}

- (id)showMoreAppli {
	id<AYCommand> des = DEFAULTCONTROLLER(@"MoreAppli");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSDictionary *tmp = @{@"todo":result_status_posted, @"feedback":result_status_paid_cancel};
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

- (id)showHistoryAppli {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServantHistory");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:result_status_past forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

- (id)showRemindMessage {
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderListPending");
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:remindArr forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

@end
