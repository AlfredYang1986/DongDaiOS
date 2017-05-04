//
//  AYOrderInfoPageDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoPageDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYOrderInfoPageDelegate {
	NSDictionary *querydata;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name;
	id<AYViewBase> cell;
	
	if (indexPath.row == 0) {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
	} else if (indexPath.row == 1) {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OPPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
	} else {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	}
	
	id tmp = [querydata copy];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		id tmp = [querydata objectForKey:@"order_date"];
		if ( [tmp isKindOfClass:[NSDictionary class]]) {
			return 120 /*+ 90*/ + 20 + 85;
		} else /*if ( [tmp isKindOfClass:[NSArray class]]) */{
			return 120 /*+ 90*/ + 20 + 85 * (((NSArray*)tmp).count == 0 ? 1 : ((NSArray*)tmp).count);
		}
	}
	else if (indexPath.row == 1) {
		return 90.f;
	}
	else {
		return 110.f;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	id tmp = [estabArrData objectAtIndex:indexPath.row];
	
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

@end
