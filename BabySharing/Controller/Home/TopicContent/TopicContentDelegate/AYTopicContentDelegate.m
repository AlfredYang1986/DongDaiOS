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
	NSArray *cellNameArr;
	NSString *album_desc;
	BOOL isExpend;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	cellNameArr = @[@"AYTopicDescCellView", @"AYTopicContentCellView"];
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
	NSArray *service_data = [args objectForKey:kAYServiceArgsInfo];
	if (service_data) {
		queryData = service_data;
	}
	
	NSString *desc = [args objectForKey:@"desc"];
	if (desc) {
		album_desc = desc;
	}
	return nil;
}

- (id)TransfromExpend:(NSNumber*)args {
	isExpend = !isExpend;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return queryData.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [cellNameArr objectAtIndex:indexPath.row == 0 ? 0 : 1];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = self.controller;
	
	if (indexPath.row == 0) {
		NSDictionary *dic_desc = @{@"is_expend":[NSNumber numberWithBool:isExpend], @"desc":album_desc};
		id tmp = [dic_desc copy];
		[(UITableViewCell*)cell performMethod:@"setCellInfo:" withResult:&tmp];
	} else {
		id tmp = [queryData objectAtIndex:indexPath.row - 1];
		if (tmp) {
			[(UITableViewCell*)cell performMethod:@"setCellInfo:" withResult:&tmp];
		}
	}
	return (UITableViewCell*)cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return 390;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return;
	}
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:[queryData objectAtIndex:indexPath.row - 1] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
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
