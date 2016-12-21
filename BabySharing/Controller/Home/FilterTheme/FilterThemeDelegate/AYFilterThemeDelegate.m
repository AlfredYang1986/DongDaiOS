//
//  AYFilterThemeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFilterThemeDelegate.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"
#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

#define TableViewHeadHeight		55.f
#define TableViewCellHeight		45.f

@implementation AYFilterThemeDelegate {
	NSArray *titleArr_course;
	NSArray *titleArr_lookafter;
	
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	titleArr_course = kAY_service_options_title_course;
	titleArr_lookafter = kAY_service_options_title_lookafter;
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
//	if ([args isKindOfClass:[NSArray class]]) {
//		
//		query_data = [NSArray arrayWithArray:args];
//	} else if ([args isKindOfClass:[NSDictionary class]]) {
//		
//		dic_location = args;
//	} else if ([args isEqualToString:@"remove"]) {
//		
//		dic_location = nil;
//	}
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return titleArr_course.count;
	} else {
		return titleArr_lookafter.count;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"FilterThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	cell.controller = self.controller;
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	if (indexPath.section == 0) {
		[tmp setValue:[titleArr_course objectAtIndex:indexPath.row] forKey:@"title"];
	} else {
		[tmp setValue:[titleArr_lookafter objectAtIndex:indexPath.row] forKey:@"title"];
	}
	[tmp setValue:[NSNumber numberWithInteger:indexPath.section] forKey:kAYServiceArgsServiceCat];
	[tmp setValue:[NSNumber numberWithInteger:indexPath.row] forKey:kAYServiceArgsTheme];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	UILabel *titleLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools blackColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.centerY.equalTo(headView);
	}];
	
	if (section == 0) {
		titleLabel.text = @"课程";
	} else {
		titleLabel.text = @"看顾服务";
	}
	
	CALayer *sepLayer = [CALayer layer];
	CGFloat margin = 10;
	sepLayer.frame = CGRectMake(margin, TableViewHeadHeight - 10.5, SCREEN_WIDTH - margin * 2, 0.5);
	sepLayer.backgroundColor = [Tools garyLineColor].CGColor;
	[headView.layer addSublayer:sepLayer];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return TableViewHeadHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return TableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark -- actions
- (void)didReLocationBtnClick {
	
	kAYDelegateSendNotify(self, @"reLocationAction", nil)
	
}

@end
