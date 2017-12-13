//
//  AYTopicContentDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTopicContentDelegate.h"

@implementation AYTopicContentDelegate {
	NSArray *queryData;
	
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
	queryData = (NSArray*)args;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return queryData.count;
	return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = @"AYHomeServPerCellView";
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = self.controller;
	
	id tmp = [queryData objectAtIndex:indexPath.row];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return HOMECOMMONCELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGFloat offset_y = scrollView.contentOffset.y;
	
	NSNumber *tmp = [NSNumber numberWithFloat:offset_y];
	kAYDelegateSendNotify(self, @"scrollViewDidScroll:", &tmp)
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
}

#pragma mark -- actions

@end
