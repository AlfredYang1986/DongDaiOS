//
//  AYOrderListNewsDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 11/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderListNewsDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

#import "AYNoContentCell.h"

@implementation AYOrderListNewsDelegate {
	NSArray *querydata;
	
//	NSArray *waitArrData;
//	NSArray *estabArrData;
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
//	waitArrData = [querydata objectForKey:@"wait"];
//	estabArrData = [querydata objectForKey:@"confirm"];
	return nil;
}

#pragma mark -- table
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
//	if (section == 0) {
//		return waitArrData.count;
//	} else {
//	}
	return querydata.count == 0 ? 1 : querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name;
	id<AYViewBase> cell;
	id tmp ;
//	if (indexPath.section == 0) {
//		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OSWaitCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//		tmp = [waitArrData objectAtIndex:indexPath.row];
//		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
//		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
//		
//		cell.controller = self.controller;
//		((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
//		((UITableViewCell*)cell).clipsToBounds = YES;
//		return (UITableViewCell*)cell;
//		
//	} else {
//		
//	}
	if (querydata.count == 0) {
		AYNoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NONewsCell"];
		if (!cell) {
			cell = [[AYNoContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NONewsCell"];
		}
		cell.titleStr = @"您没有新的动态";
		return cell;
	} else {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OSEstabCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		tmp = [querydata objectAtIndex:indexPath.row];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		
		cell.controller = self.controller;
		((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
		((UITableViewCell*)cell).clipsToBounds = YES;
		return (UITableViewCell*)cell;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 160.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools garyBackgroundColor];
	headView.clipsToBounds = YES;
	NSString *titleStr = @"最近提醒：";
	
	UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:-15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		
	} else {
		
	}
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( querydata.count == 0) {
		return NO;
	} else {
		return YES;
	}
}

@end
