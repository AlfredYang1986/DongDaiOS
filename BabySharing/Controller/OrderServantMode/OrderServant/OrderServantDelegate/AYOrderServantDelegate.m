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
#import "AYControllerActionDefines.h"
#import "AYOrderTOPView.h"

#define TOPHEIGHT		155
#define HISTORYBTNHEIGHT		60

@implementation AYOrderServantDelegate {
	NSArray *querydata;
	
	AYOrderTOPView *TOPView;
	
	NSArray *funcNameArr;
//	NSArray *waitArrData;
//	NSArray *estabArrData;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	funcNameArr = @[/*@"showAppliListOrOne", @"showHistoryAppli",*/ @"showRemindMessage"];
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

- (id)changeQueryTodoData:(NSArray*)data {
	TOPView.userInteractionEnabled = data.count != 0;
	[TOPView setItemArgs:data];
	return nil;
}

#pragma mark -- table
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name ;
	id<AYViewBase> cell ;
	id args;
//	if (indexPath.row == 0) {
//		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TodoApplyCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
//		
//	} else if (indexPath.row == 1) {
//		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HistoryEnterCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
//	} else {
//	}
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"DayRemindCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	args = [querydata copy];
	kAYViewSendMessage(cell, @"setCellInfo:", &args)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.row == 0) {
//		return 110.f;
//	} else if (indexPath.row == 1) {
//		return 60.f;
//	} else {
//	}
	return 180.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc] init];
	headView.backgroundColor = [Tools whiteColor];
	
	TOPView = [[AYOrderTOPView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPHEIGHT) andMode:OrderModeServant];
	[headView addSubview:TOPView];
	TOPView.userInteractionEnabled = YES;
	[TOPView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTodoApplyAndBack)]];
	
	UIButton *readMoreBtn = [Tools creatUIButtonWithTitle:@"查看全部" andTitleColor:[Tools themeColor] andFontSize:15.f andBackgroundColor:nil];
	[headView addSubview:readMoreBtn];
	[readMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(TOPView).offset(-20);
		make.top.equalTo(TOPView).offset(10);
		make.size.mas_equalTo(CGSizeMake(70, 30));
	}];
//	[readMoreBtn addTarget:self action:@selector(didReadMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
	readMoreBtn.hidden  = YES;
	
	UIButton *historyBtn = [Tools creatUIButtonWithTitle:@"查看历史记录" andTitleColor:[Tools themeColor] andFontSize:15.f andBackgroundColor:nil];
	historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[historyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,20, 0, 0)];
	[headView addSubview:historyBtn];
	[historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(headView);
		make.top.equalTo(TOPView.mas_bottom).offset(0);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, HISTORYBTNHEIGHT));
	}];
	[historyBtn addTarget:self action:@selector(didHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[Tools creatCALayerWithFrame:CGRectMake(0, HISTORYBTNHEIGHT - 0.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:historyBtn];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (TOPHEIGHT + HISTORYBTNHEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *funcName = [funcNameArr objectAtIndex:indexPath.row];
	kAYDelegateSendNotify(self, funcName, nil)
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return querydata.count != 0;
}

#pragma mark -- actions
- (void)showTodoApplyAndBack {
	kAYDelegateSendNotify(self, @"showAppliListOrOne", nil)
}

- (void)didHistoryBtnClick {
	kAYDelegateSendNotify(self, @"showHistoryAppli", nil)
}

//- (void)didReadMoreBtnClick {
//	kAYDelegateSendNotify(self, @"showMoreAppli", nil)
//}

#pragma mark -- scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"%f",scrollView.contentOffset.y);
//	if (scrollView.contentOffset.y <= 0) {
//		scrollView.bounces = NO;
//		
//		NSLog(@"禁止下拉");
//	}
//	else if (scrollView.contentOffset.y >= 0){
//			scrollView.bounces = YES;
//			NSLog(@"允许上拉");
//	}
	
	CGPoint offset = scrollView.contentOffset;
	if (offset.y >= 0) {
		offset.y = 0;
	}
	scrollView.contentOffset = offset;
}


@end
