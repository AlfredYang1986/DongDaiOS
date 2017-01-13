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

@implementation AYOrderServantController {
	UILabel *noticeNews;
	NSArray *order_info;
	NSArray *result_status_ready;
	NSArray *order_past;
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
	
	UIView *newsBoardView = [[UIView alloc]init];
	newsBoardView.backgroundColor = [Tools whiteColor];
	newsBoardView.layer.shadowColor = [Tools garyColor].CGColor;
	newsBoardView.layer.shadowOffset = CGSizeMake(0, 0);
	newsBoardView.layer.shadowOpacity = 0.5f;
	[self.view addSubview:newsBoardView];
	[newsBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.view).offset(30);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 95));
	}];
	
	UILabel *title = [Tools creatUILabelWithText:@"待办日程：" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[newsBoardView addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(newsBoardView).offset(15);
		make.top.equalTo(newsBoardView).offset(20);
	}];

	
	noticeNews = [Tools creatUILabelWithText:@"暂时没有待处理的日程" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[newsBoardView addSubview:noticeNews];
	[noticeNews mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(title);
		make.top.equalTo(title.mas_bottom).offset(18);
	}];
	noticeNews.userInteractionEnabled = YES;
	[noticeNews addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didNoticeLabelTap)]];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderServant"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OSEstabCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	NSDictionary *tmp = [order_info copy];
	kAYDelegatesSendMessage(@"OrderListNews:", @"changeQueryData:", &tmp)
	
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self loadNewData];
	
	UIButton *historyBtn  = [Tools creatUIButtonWithTitle:@"查看历史记录" andTitleColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
//	historyBtn.layer.shadowColor = [Tools garyColor].CGColor;
//	historyBtn.layer.shadowOffset = CGSizeMake(0, -0.5);
//	historyBtn.layer.shadowOpacity = 0.4f;
	[Tools creatCALayerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:historyBtn];
	[self.view addSubview:historyBtn];
	[historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.bottom.equalTo(self.view).offset(-49);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
	}];
	[historyBtn addTarget:self action:@selector(didHistoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
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
	view.frame = CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_HEIGHT - 140 - 49 - 49); //5 margin
	return nil;
}

#pragma mark -- actions
- (void)loadNewData {
	NSDictionary* info = nil;
	CURRENUSER(info)
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOwnOrders"];
	NSMutableDictionary *dic_query = [info mutableCopy];
	
	NSMutableDictionary *dic_conditon = [[NSMutableDictionary alloc]init];
	[dic_conditon setValue:[info objectForKey:@"user_id"] forKey:@"owner_id"];
	
	[dic_query setValue:[dic_conditon copy] forKey:@"condition"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *resultArr = [result objectForKey:@"result"];
			
			NSPredicate *pred_ready = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusPaid];
			result_status_ready = [resultArr filteredArrayUsingPredicate:pred_ready];
			noticeNews.text = [NSString stringWithFormat:@"您有 %d个待处理订单", (int)result_status_ready.count];
			
			NSPredicate *pred_confirm = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusConfirm];
			NSArray *result_status_confirm = [resultArr filteredArrayUsingPredicate:pred_confirm];
			id tmp = result_status_confirm;
			kAYDelegatesSendMessage(@"OrderServant", @"changeQueryData:", &tmp)
			
			id<AYViewBase> view_past = [self.views objectForKey:@"Table"];
			id<AYCommand> refresh_2 = [view_past.commands objectForKey:@"refresh"];
			[refresh_2 performWithResult:nil];
			
			NSPredicate *pred_done = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusDone];
			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusReject];
			NSPredicate *pred_past = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_done, pred_reject, pred_confirm]];
			order_past = [resultArr filteredArrayUsingPredicate:pred_past];
			
		}else {
			NSLog(@"query orders error: %@",result);
		}
		
		id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
		[((UITableView*)view_future).mj_header endRefreshing];
	}];
	
}

- (void)didNoticeLabelTap {
	
}

- (void)didHistoryBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServantHistory");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[order_past copy] forKey:kAYControllerChangeArgsKey];
	
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

@end
