//
//  AYOrderCommonDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderCommonDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYOrderCommonDelegate {
	NSDictionary *querydata;
	NSDictionary *service_info;
	NSMutableArray *order_times;
	
	BOOL isSetedDate;
	BOOL isExpend;
	
	NSNumber *setedDate;
	NSDictionary *setedTimes;
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
	service_info = [querydata objectForKey:kAYServiceArgsServiceInfo];
	order_times = [querydata objectForKey:@"order_times"];
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	NSDictionary *tmp = [service_info copy];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	((UITableViewCell*)cell).clipsToBounds = YES;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 90.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools garyBackgroundColor];
	NSString *titleStr = @"我的时间轴";
	UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:-15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(headView).offset(15);
		make.left.equalTo(headView).offset(65);
	}];
	
	CALayer *dotLayer = [CALayer layer];
	dotLayer.cornerRadius = 7.5f;
	dotLayer.bounds = CGRectMake(0, 0, 15, 15);
	dotLayer.position = CGPointMake(85, 70);
	dotLayer.backgroundColor = [Tools lightGreyColor].CGColor;
	[headView.layer addSublayer:dotLayer];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		
		NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
		if (service_cat.intValue == ServiceTypeCourse) {
			return;
		}
		else {
			NSNumber *note = [NSNumber numberWithInteger:indexPath.row];
			kAYDelegateSendNotify(self, @"setOrderTime:", &note)
		}
		
	}
}

@end
