//
//  AYBOTimeTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 25/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYBOTimeTableDelegate.h"

@implementation AYBOTimeTableDelegate {
	NSArray *querydata;
	ServiceType service_type;
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

- (id)setDelegateType:(id)args {
	service_type = ((NSNumber*)args).intValue;
	return nil;
}

- (id)changeQueryData:(id)args {
	querydata = (NSArray*)args;
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (service_type == ServiceTypeCourse) {
		return querydata.count;
//		return 3;
	} else
		return querydata.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name;
	id<AYViewBase> cell;
	if (service_type == ServiceTypeCourse) {
		class_name = @"AYOTMCourseCellView";
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		id tmp = [querydata objectAtIndex:indexPath.section];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		
	} else {
			if (indexPath.section == querydata.count) {
			class_name = @"AYAddOTimeCellView";
			cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
			
		} else {
			class_name = @"AYOTMNurseCellView";
			cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
			
			id tmp = [querydata objectAtIndex:indexPath.section];
			kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		}
	}
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (service_type == ServiceTypeCourse) {
		return 85.f;
	} else
		return 65.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (service_type == ServiceTypeNursery) {
		NSNumber *row = [NSNumber numberWithInteger:indexPath.section];
		kAYDelegateSendNotify(self, @"cellShowPickerView:", &row)
	} else {
		NSIndexPath *row = indexPath;
		kAYDelegateSendNotify(self, @"didClickTheCellRow:", &row)
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (service_type == ServiceTypeNursery) {
		return 6.f;
	} else if (service_type == ServiceTypeCourse && section == 0) {
		return 6.f;
	} else
		return 0.001f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [UIView new];
	headView.backgroundColor = [Tools garyBackgroundColor];
		
//	if (service_type == ServiceTypeCourse && section == 0) {
//		UIView *libgView = [[UIView alloc] init];
//		libgView.backgroundColor = [Tools themeColor];
//		[headView addSubview:libgView];
//		[libgView mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.centerX.equalTo(headView.mas_left).offset(27);
//			make.top.equalTo(headView);
//			make.width.mas_equalTo(1.5);
//			make.height.mas_equalTo(6.f);
//		}];
//	}
	
	return headView;
}

//左划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == querydata.count || service_type == ServiceTypeCourse) {
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
//	@"         "
	UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"  删除  " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		NSNumber *row = [NSNumber numberWithInteger:indexPath.section];
		kAYDelegateSendNotify(self, @"cellDeleteFromTable:", &row)
	}];
	
//	view.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
//	view.layer.backgroundColor = [UIColor clearColor].CGColor;
//	rowAction.backgroundColor = [UIColor colorWithPatternImage:IMGRESOURCE(@"cell_delete")];
	rowAction.backgroundColor = [Tools themeColor];
	return @[rowAction];
}

@end
