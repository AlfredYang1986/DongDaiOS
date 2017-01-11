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

@implementation AYOrderListNewsDelegate {
	NSDictionary *querydata;
	
	NSArray *waitArrData;
	NSArray *estabArrData;
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

- (id)changeQueryData:(NSDictionary*)info {
	querydata = info;
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 0) {
		return 2;
	} else {
		return 4;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name;
	id tmp ;
	if (indexPath.section == 0) {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OSWaitCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		tmp = [waitArrData objectAtIndex:indexPath.row];
		
	} else {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OSEstabCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		tmp = [estabArrData objectAtIndex:indexPath.row];
		
	}
	
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	((UITableViewCell*)cell).clipsToBounds = YES;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	if (indexPath.section == 0) {
		return 100.f;
	} else {
		
		return 160.f;
	}
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools garyBackgroundColor];
	NSString *titleStr ;
	
	if (section == 0) {
		titleStr = @"等待服务者接单：";
	} else {
		titleStr = @"全部动态";
	}
	
	UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:-15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	
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
	if (indexPath.section == 0) {
		
	} else {
		
	}
}

@end
