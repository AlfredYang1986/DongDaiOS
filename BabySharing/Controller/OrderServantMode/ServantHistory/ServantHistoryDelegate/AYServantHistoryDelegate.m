//
//  AYServantHistoryDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServantHistoryDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

#define headViewHeight		50

@implementation AYServantHistoryDelegate {
	NSArray *querydata;
	
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
	querydata = info;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return querydata.count;
	return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServantHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
//	id tmp = [querydata objectAtIndex:indexPath.row];
//	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 120.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	NSString *titleStr = @"历史记录";
	
	UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:625.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(10, headViewHeight - 0.5, SCREEN_WIDTH - 10*2, 0.5) andColor:[Tools garyLineColor] inSuperView:headView];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		
		return headViewHeight;
		
	} else {
		return 50.f;
	}
}

#import "AYControllerActionDefines.h"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	
	//	NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
	//	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

@end
