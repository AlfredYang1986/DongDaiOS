//
//  AYHomeCollectDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 31/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeAroundDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "AYNoContentCell.h"
#import "AYHomeAroundNoAuthCell.h"

@implementation AYHomeAroundDelegate {
	NSArray *querydata;
	BOOL isAuthLocation;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (id)changeQueryData:(id)args {
	querydata = args;
	return nil;
}

- (id)changeLocationAuthData:(id)args {
	isAuthLocation = ((NSNumber*)args).boolValue;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = querydata.count;
	return count == 0 ? 1 : count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!isAuthLocation) {
		NSString *identifier = @"AYHomeAroundNoAuthCell";
		AYHomeAroundNoAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		if (!cell) {
			cell = [[AYHomeAroundNoAuthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		}
		return cell;
	} else {
		if (querydata.count == 0) {
			NSString *identifier = @"HomeAroundNOContentCell";
			AYNoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
			if (!cell) {
				cell = [[AYNoContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
			}
			[cell setTitleStr:@"附近暂无可用服务"];
			return cell;
		}
		else {
			
			NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeAroundCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
			id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
			
			id tmp = [querydata objectAtIndex:indexPath.row];
			kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
			
			cell.controller = self.controller;
			((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
			return (UITableViewCell*)cell;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!isAuthLocation) {
		return 300.f;
	} else
		return 130.f;
}

@end
