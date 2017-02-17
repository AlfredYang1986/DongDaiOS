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

@implementation AYOrderCommonController {
	
	UILabel *leastNews;
	
	NSArray *result_status_ready;
	NSArray *result_status_confirm;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
		
		id tmp = [args copy];
		kAYDelegatesSendMessage(@"BOrderMain", @"changeQueryData:", &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	/****************************************/
//	[Tools creatCALayerWithFrame:CGRectMake(85, SCREEN_HEIGHT * 0.5, 1.f, SCREEN_HEIGHT * 0.5 - 49) andColor:[Tools lightGreyColor] inSuperView:self.view];
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	[self.view bringSubviewToFront:tableView];
	/****************************************/
	
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
	
	UILabel *title = [Tools creatUILabelWithText:@"最近提醒" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[newsBoardView addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(newsBoardView).offset(15);
		make.top.equalTo(newsBoardView).offset(20);
	}];
	
//	UIButton *allNewsBtn  = [Tools creatUIButtonWithTitle:@"全部动态" andTitleColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil];
//	[newsBoardView addSubview:allNewsBtn];
//	[allNewsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerY.equalTo(title);
//		make.right.equalTo(newsBoardView).offset(-15);
//		make.size.mas_equalTo(CGSizeMake(70, 30));
//	}];
//	[allNewsBtn addTarget:self action:@selector(didAllNewsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	leastNews = [Tools creatUILabelWithText:@"暂时没有新的日程" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[newsBoardView addSubview:leastNews];
	[leastNews mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(title);
		make.top.equalTo(title.mas_bottom).offset(18);
	}];
	leastNews.userInteractionEnabled = YES;
	[leastNews addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLeastNewsTap)]];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderCommon"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self loadNewData];
	
//	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OSEstabCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
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
	view.backgroundColor = [UIColor clearColor];
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
	view.frame = CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_HEIGHT - 140 - 49);
	return nil;
}

#pragma mark -- actions
- (void)didLeastNewsTap {
	id<AYCommand> des;
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	
	if (result_status_ready.count == 1 && result_status_ready.count != 0) {
		des = DEFAULTCONTROLLER(@"OrderInfoPage");
		[dic setValue:[result_status_ready firstObject] forKey:kAYControllerChangeArgsKey];
//		des = DEFAULTCONTROLLER(@"OrderListNews");
//		[dic setValue:[result_status_ready copy] forKey:kAYControllerChangeArgsKey];
	} else {
		des = DEFAULTCONTROLLER(@"OrderListNews");
		[dic setValue:[result_status_ready copy] forKey:kAYControllerChangeArgsKey];
	}
	
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

- (void)didAllNewsBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderListNews");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:result_status_ready forKey:@"wait"];
	[tmp setValue:result_status_confirm forKey:@"confirm"];
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	
}

#pragma mark -- actions
- (void)loadNewData {
	NSDictionary *info;
	CURRENUSER(info)
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryApplyOrders"];
	NSMutableDictionary *dic_query = [info mutableCopy];
	
	NSMutableDictionary *dic_conditon = [[NSMutableDictionary alloc]init];
	[dic_conditon setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
	
	[dic_query setValue:[dic_conditon copy] forKey:@"condition"];
	
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *resultArr = [result objectForKey:@"result"];
			
//			NSPredicate *pred_done = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusDone];
//			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusReject];
//			NSArray *result_status_done = [resultArr filteredArrayUsingPredicate:pred_done];
//			NSArray *result_status_reject = [resultArr filteredArrayUsingPredicate:pred_reject];
//			
//			NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
//			[tmpArr addObjectsFromArray:result_status_done];
//			[tmpArr addObjectsFromArray:result_status_reject];
			
			/*****************************/
			
			NSPredicate *pred_ready = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusPaid];
			NSPredicate *pred_confirm = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusConfirm];
			result_status_ready = [resultArr filteredArrayUsingPredicate:pred_ready];
			result_status_confirm = [resultArr filteredArrayUsingPredicate:pred_confirm];
			
			if (result_status_ready.count == 0) {
				leastNews.text = @"暂时没有待处理的日程";
				leastNews.textColor = [Tools garyColor];
				leastNews.userInteractionEnabled = NO;
			} else {
				
				leastNews.text = [NSString stringWithFormat:@"您有 %d个待处理订单", (int)result_status_ready.count];
				leastNews.textColor = [Tools themeColor];
				leastNews.userInteractionEnabled = YES;
			}
			
			id tmp = [result_status_confirm copy];
			kAYDelegatesSendMessage(@"OrderCommon", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			
		} else {
			NSLog(@"query orders error: %@",result);
		}
		
		id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
		[((UITableView*)view_future).mj_header endRefreshing];
		
	}];
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
