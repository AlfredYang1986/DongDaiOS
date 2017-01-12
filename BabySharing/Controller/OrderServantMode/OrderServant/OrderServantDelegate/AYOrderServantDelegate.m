//
//  AYOrderServantDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 12/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderServantDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYOrderServantDelegate {
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

- (id)changeQueryData:(id)info {
	estabArrData = info;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return estabArrData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OSEstabCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	id tmp = [estabArrData objectAtIndex:indexPath.row];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	((UITableViewCell*)cell).clipsToBounds = YES;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 160.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools garyBackgroundColor];
	NSString *titleStr = @"您的时间轴：";
	
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
