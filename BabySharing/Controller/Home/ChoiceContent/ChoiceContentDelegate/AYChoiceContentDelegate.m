//
//  AYChoiceContentDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYChoiceContentDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

@implementation AYChoiceContentDelegate {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYViewBase> cell;
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.row == 0) {
//		return 285.f;
//	} else {
//	}
	return 370.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGPoint offset = scrollView.contentOffset;
	if (offset.y <= - 285.f) {
		offset.y = -285.f;
		scrollView.contentOffset = offset;
	}
	
	NSNumber *offset_y = [NSNumber numberWithFloat:scrollView.contentOffset.y];
	kAYDelegateSendNotify(self, @"scrollOffsetYNoyify:", &offset_y)
}

@end
