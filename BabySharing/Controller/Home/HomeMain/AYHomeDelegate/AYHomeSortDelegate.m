//
//  AYHomeSortDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeSortDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

@implementation AYHomeSortDelegate {
	NSArray *sectionTitleArr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	sectionTitleArr = @[@"看顾", @"课程"];
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
	
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYViewBase> cell;
	if (indexPath.section == 0) {
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeSortNurseryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	} else {
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeSortCourseCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	}
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 120.f;
	} else {
//		(count/2 + (count%2 == 0 ? 0 : 1)) * (96+15) + 10 + 20
		return 10 + 6 * (96+15) + 20;
	}
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [UIView new];
	headView.backgroundColor = [Tools whiteColor];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:[sectionTitleArr objectAtIndex:section] andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.bottom.equalTo(headView).offset(-8);
	}];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	if (section == 0) {
//	} else
//		return 48.f;
	return 68.f;
}

@end
