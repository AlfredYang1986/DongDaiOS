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

#define TABLE_VIEW_TOP_MARGIN   50

@implementation AYChatListController {
	
	NSArray* chatGroupArray_mine;
	NSArray* chatGroupArray_recommend;
	//    UIView *bkView;
	UIButton* actionView;
	CAShapeLayer *circleLayer;
	UIView *animationView;
	CGFloat radius;
	CGPathRef startPath;
	
	CALayer *scaleMaskLayer;
	
	UIViewController* homeVC;
	
	NSArray *conversations;
	
	UIView *view_loading;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		homeVC = [dic objectForKey:kAYControllerChangeArgsKey];
		
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
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.extendedLayoutIncludesOpaqueBars = NO;
	
	{
		id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
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

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {//todo: 聊天列表
	[super viewDidAppear:animated];
	
	if (!conversations) {
		
		id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
		id<AYCommand> cmd = [em.commands objectForKey:@"QueryEMSations"];
		
		NSDictionary *info = nil;
		CURRENUSER(info)
		
		id brige = [info objectForKey:@"user_id"];
		NSLog(@"michauxs -- %@", (NSArray*)brige);
		
		conversations = [(NSArray*)brige mutableCopy];
		//    NSArray *sastions = [(NSArray*)brige copy];
		
		[cmd performWithResult:&brige];
		
		id<AYDelegateBase> del = [self.delegates objectForKey:@"ChatList"];
		id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
		[cmd_change performWithResult:&brige];
		
		id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
		id<AYCommand> cmd_refresh = [view_content.commands objectForKey:@"refresh"];
		[cmd_refresh performWithResult:nil];
		
		brige = nil;
	}
	
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
	
	NSString *title = @"消息";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	id<AYViewBase> bar = (id<AYViewBase>)view;
	id<AYCommand> cmd_left_vis = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
	NSNumber* left_hidden = [NSNumber numberWithBool:YES];
	[cmd_left_vis performWithResult:&left_hidden];
	
	id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	[cmd_right_vis performWithResult:&right_hidden];
	
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, TABLE_VIEW_TOP_MARGIN, SCREEN_WIDTH, SCREEN_HEIGHT - TABLE_VIEW_TOP_MARGIN);
	view.backgroundColor = [UIColor whiteColor];
	return nil;
}

#pragma mark -- actions
- (void)loadNewData {
	id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
	id<AYCommand> cmd = [em.commands objectForKey:@"QueryEMSations"];
	
	NSDictionary *info = nil;
	CURRENUSER(info)
	
	id brige = [info objectForKey:@"user_id"];
	NSLog(@"michauxs -- %@", (NSArray*)brige);
	
	conversations = [(NSArray*)brige mutableCopy];
	
	[cmd performWithResult:&brige];
	
	id<AYDelegateBase> del = [self.delegates objectForKey:@"ChatList"];
	id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
	[cmd_change performWithResult:&brige];
	
	id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
	id<AYCommand> cmd_refresh = [view_content.commands objectForKey:@"refresh"];
	[cmd_refresh performWithResult:nil];
	
	[((UITableView*)view_content).mj_header endRefreshing];
}

#pragma mark -- notifies
- (id)scrollToRefresh {
	
	return nil;
}

@end
