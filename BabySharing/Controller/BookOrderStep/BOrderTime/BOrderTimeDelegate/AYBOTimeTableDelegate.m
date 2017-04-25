//
//  AYBOTimeTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 25/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYBOTimeTableDelegate.h"

@implementation AYBOTimeTableDelegate {
	NSArray *timesArr;
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
	timesArr = (NSArray*)args;
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return timesArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name;
	id<AYViewBase> cell;
	
	if (indexPath.section == timesArr.count) {
		class_name = @"AYAddOTimeCellView";
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
	} else {
		class_name = @"AYSELOTimeCellView";
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
		id tmp = [timesArr objectAtIndex:indexPath.section];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	}
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSNumber *row = [NSNumber numberWithInteger:indexPath.section];
	kAYDelegateSendNotify(self, @"cellShowPickerView:", &row)
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 6.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [UIView new];
	headView.backgroundColor = [Tools garyBackgroundColor];
	return headView;
}

//左划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == timesArr.count) {
		return NO;
	} else
		return YES;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	NSNumber *row = [NSNumber numberWithInteger:indexPath.section];
	kAYDelegateSendNotify(self, @"cellDeleteFromTable:", &row)
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"         " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		NSNumber *row = [NSNumber numberWithInteger:indexPath.section];
		kAYDelegateSendNotify(self, @"cellDeleteFromTable:", &row)
	}];
	
	UIImage *image = IMGRESOURCE(@"cell_delete");
//	view.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
//	view.layer.backgroundColor = [UIColor clearColor].CGColor;
	rowAction.backgroundColor = [UIColor colorWithCGColor:(__bridge CGColorRef _Nonnull)(image)];
	return @[rowAction];
}

@end
