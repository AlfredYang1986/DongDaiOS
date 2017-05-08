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

#define TOPHEIGHT		165

@implementation AYOrderCommonController {
	
//	UILabel *leastNews;
	AYOrderTOPView *TOPView;
	
	NSArray *result_status_fb;
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
	
//	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"AppliFBCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
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
	view.frame = CGRectMake(0, kStatusAndNavBarH+TOPHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH-TOPHEIGHT);
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
	
//	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
//	[tmp setValue:result_status_ready forKey:@"wait"];
//	[tmp setValue:result_status_confirm forKey:@"confirm"];
//	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
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
			NSPredicate *pred_accept = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusAccepted];
			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusReject];
			NSPredicate *pred_fb = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_accept, pred_reject]];
			result_status_fb = [resultArr filteredArrayUsingPredicate:pred_fb];
			
			[TOPView setItemArgs:result_status_fb];
			
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
