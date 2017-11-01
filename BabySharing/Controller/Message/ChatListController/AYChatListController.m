//
//  AYMessageListController.m
//  BabySharing
//
//  Created by Alfred Yang on 27/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYChatListController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYGroupListCellDefines.h"
#import "MJRefresh.h"

#define TABLE_VIEW_TOP_MARGIN   35

@implementation AYChatListController {
	
	NSArray *conversations;
	
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
		NSDictionary* dic_push = [dic copy];
		id<AYCommand> cmd = PUSH;
		[cmd performWithResult:&dic_push];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.extendedLayoutIncludesOpaqueBars = NO;
	
	{
		id<AYViewBase> view_content = [self.views objectForKey:kAYTableView];
		id<AYDelegateBase> del = [self.delegates objectForKey:@"ChatList"];
		id<AYCommand> cmd_datasource = [view_content.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_content.commands objectForKey:@"registerDelegate:"];
		
		id obj = (id)del;
		[cmd_datasource performWithResult:&obj];
		obj = (id)del;
		[cmd_delegate performWithResult:&obj];
		
		id<AYCommand> cmd_cell = [view_content.commands objectForKey:@"registerCellWithClass:"];
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ChatListCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_cell performWithResult:&class_name];
		
		UITableView *tableView = (UITableView*)view_content;
//        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
		
		tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
		// Enter the refresh status immediately
//        [tableView.mj_header beginRefreshing];
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self loadNewData];
}

- (void)viewDidAppear:(BOOL)animated {//todo: 聊天列表
	[super viewDidAppear:animated];
	
//	if (!conversations) {
//			[self loadNewData];
//	}
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)TableLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, TABLE_VIEW_TOP_MARGIN, SCREEN_WIDTH, SCREEN_HEIGHT - TABLE_VIEW_TOP_MARGIN);
	view.backgroundColor = [UIColor whiteColor];
	
	((UITableView*)view).estimatedRowHeight = 100;
	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
	
	return nil;
}

#pragma mark -- actions
- (void)loadNewData {
	id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
	id<AYCommand> cmd = [em.commands objectForKey:@"QueryEMSations"];
	
	NSDictionary *info = nil;
	CURRENUSER(info)
	id brige = [info objectForKey:@"user_id"];
	[cmd performWithResult:&brige];
	
	NSLog(@"michauxs -- %@", (NSArray*)brige);
	conversations = [(NSArray*)brige mutableCopy];
	
	kAYDelegatesSendMessage(@"ChatList", kAYDelegateChangeDataMessage, &brige)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
	[((UITableView*)view_content).mj_header endRefreshing];
	
}

#pragma mark -- notifies
- (id)EMReceiveMessage:(id)args {
	NSLog(@"receive message success");
	UIViewController* vc = [Tools activityViewController];
	if (vc == self) {
		[self loadNewData];
	}
	return nil;
}

- (id)scrollToRefresh {
	
	return nil;
}

@end
