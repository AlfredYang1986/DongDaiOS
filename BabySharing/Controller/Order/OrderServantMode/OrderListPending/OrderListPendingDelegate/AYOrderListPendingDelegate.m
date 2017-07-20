//
//  AYOrderListPendingDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 18/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderListPendingDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemindDateHeaderView.h"

@implementation AYOrderListPendingDelegate {
	NSArray *querydata;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

#pragma mark -- commands
- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

- (id)changeQueryData:(id)info {
	querydata = info;
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return querydata.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return querydata.count;
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderListPendingCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	id tmp = [querydata objectAtIndex:indexPath.section];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	static NSString *IDD = @"AYRemindDateHeaderView";
	AYRemindDateHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:IDD];
	if (!headView) {
		headView = [[AYRemindDateHeaderView alloc] initWithReuseIdentifier:IDD];
	}
	headView.cellInfo = [querydata objectAtIndex:section];
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		
		return 50.f;
		
	} else {
		return 50.f;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//	{
	//		address = "Beijing Haidian Driving School Registration Office (Dongsheng Student Accommodation Unit Southwest)";
	//		cans = "-1";
	//		"cans_cat" = 0;
	//		end = 1494637200000;
	//		"order_id" = 5ec0d0e954acebfecbc617eab87d08c8;
	//		"order_thumbs" = "EAC8BAE9-46FB-4054-94E0-70B32E2C82E1";
	//		"order_title" = "Sunfei' Service";
	//		owner =     {
	//			"screen_name" = Singer;
	//			"screen_photo" = "A25F3F2C-9619-484D-8EB6-B7B187BA4F9A";
	//		};
	//		reserve1 = "";
	//		"service_cat" = 1;
	//		"service_id" = 4b99af39a03c518f794f4f1ff799f66c;
	//		start = 1494633600000;
	//		user =     {
	//			"screen_name" = "\U827e\U4f26\U4e36\U7c73\U4fee\U65af";
	//			"screen_photo" = "3B958915-E9D8-4D36-B995-A98C907EFEA0";
	//		};
	//	}
//	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
//	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//	
//	NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
//	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
//	
//	id<AYCommand> cmd_push = PUSH;
//	[cmd_push performWithResult:&dic];
	
	id tmp = [NSNumber numberWithInteger:indexPath.row];
	kAYViewSendNotify(self, @"didSelectedRow:", &tmp)
}

@end
