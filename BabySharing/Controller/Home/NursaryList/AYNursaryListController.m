//
//  AYNursaryListController.m
//  BabySharing
//
//  Created by Alfred Yang on 2/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYNursaryListController.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"


@implementation AYNursaryListController {
	
	NSMutableArray *serviceData;
	NSInteger skipedCount;
	NSNumber *timeIntervalNode;
	
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		
		if ([backArgs isKindOfClass:[NSString class]]) {
			//			NSString *title = (NSString*)backArgs;
			//			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		else if ([backArgs isKindOfClass:[NSDictionary class]]) {
			NSString *key = [backArgs objectForKey:@"key"];
			if ([key isEqualToString:@"is_change_collect"]) {
				id service_info = [backArgs objectForKey:@"args"];
				NSString *service_id = [service_info objectForKey:kAYServiceArgsID];
				
				NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
				NSArray *result = [serviceData filteredArrayUsingPredicate:pre_id];
				if (result.count == 1) {
					NSInteger index = [serviceData indexOfObject:result.firstObject];
					[serviceData removeObject:result.firstObject];
					id tmp = [serviceData copy];
					kAYDelegatesSendMessage(@"NursaryList", kAYDelegateChangeDataMessage, &tmp)
					UITableView *view_table = [self.views objectForKey:kAYTableView];
					[view_table deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
					
				}
			}
			
		}
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	serviceData = [NSMutableArray array];
	
	id<AYViewBase> view_table = [self.views objectForKey:kAYTableView];
	id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
	
	id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"NursaryList"];
	
	id obj = (id)cmd_collect;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_collect;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name = @"AYNursaryListCellView";
	[cmd_search performWithResult:&class_name];
	
	UITableView *tableView = (UITableView*)view_table;
	tableView.mj_header = [MXSRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	[self loadNewData];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	NSString *title = @"看顾";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* left_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &left_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH , SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
	return nil;
}

#pragma mark -- actions
- (void)loadNewData {
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData:user];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:@"看顾" forKey:kAYServiceArgsCategoryInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			timeIntervalNode = [result objectForKey:kAYCommArgsRemoteDate];
			NSArray *data = [result objectForKey:@"services"];
			serviceData = [data mutableCopy];
			kAYDelegatesSendMessage(@"NursaryList", @"changeQueryData:", &data)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		}
		else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_table = [self.views objectForKey:kAYTableView];
		[((UITableView*)view_table).mj_header endRefreshing];
	}];
}

- (void)loadMoreData {
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData:user];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:@"看顾" forKey:kAYServiceArgsCategoryInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_search setValue:timeIntervalNode forKey:kAYCommArgsRemoteDate];
	[dic_search setValue:[NSNumber numberWithInteger:serviceData.count] forKey:kAYCommArgsRemoteDataSkip];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSArray *data = [result objectForKey:@"services"];
			if (data.count == 0) {
				NSString *title = @"别扯啦，没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			} else {
				[serviceData addObjectsFromArray:data];
				id tmp = [serviceData copy];
				kAYDelegatesSendMessage(@"NursaryList", @"changeQueryData:", &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			}
		}
		else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_table = [self.views objectForKey:kAYTableView];
		[((UITableView*)view_table).mj_footer endRefreshing];
	}];
}


- (id)ownerIconTap:(id)args {
	return nil;
}

#pragma mark -- notifies
- (id)willCollectWithRow:(id)args {
	
	NSString *service_id = [args objectForKey:kAYServiceArgsID];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
//	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
//	NSArray *result_pred = [serviceData filteredArrayUsingPredicate:pre_id];
//	if (result_pred.count != 1) {
//		return nil;
//	}
//	id service_data = result_pred.firstObject;
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData:user];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:service_id forKey:kAYServiceArgsID];
	[dic_collect setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic setValue:dic_collect forKey:@"collections"];
	
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] initWithDictionary:dic_collect];
	[dic setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	if (!likeBtn.selected) {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = YES;
			} else {
				NSString *title = @"收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	} else {
		
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = NO;
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
		
	}
	return nil;
}

- (id)leftBtnSelected {
	NSLog(@"pop view controller");
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

@end

