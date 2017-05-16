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
#import "AYControllerActionDefines.h"
#import "AYNoContentCell.h"

typedef enum : NSUInteger {
	PageToService = 0,
	PageToOrder = 1
} PageTo;

@implementation AYOrderCommonDelegate {
	
	NSArray *querydata;
	
	NSTimeInterval nowNode;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	nowNode = [NSDate date].timeIntervalSince1970;
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
	return querydata.count == 0 ? 1 :querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	if (querydata.count == 0) {
		AYNoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NONewsCell"];
		if (!cell) {
			cell = [[AYNoContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NONewsCell"];
		}
		cell.titleStr = @"您目前还没有日程记录";
		return cell;
	}
	else {
		
		NSString* class_name ;
		id<AYViewBase> cell ;
		if ([self isTodayRemindWithIndex:indexPath.row]) {
			class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
			cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		} else {
			class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
			cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		}
		
		NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		
		cell.controller = self.controller;
		((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
		return (UITableViewCell*)cell;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self isTodayRemindWithIndex:indexPath.row]) {
		return 190.f;
	} else
		return 140.f;
}

- (BOOL)isTodayRemindWithIndex:(NSInteger)index {
	if (querydata.count != 0) {
		
		NSDictionary *index_args = [querydata objectAtIndex:index];
		double start = ((NSNumber*)[index_args objectForKey:kAYServiceArgsStart]).doubleValue * 0.001;
		
		NSDateFormatter *formatter = [Tools creatDateFormatterWithString:nil];
		NSString *startStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:start]];
		NSString *nowStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowNode]];
		//	double end = ((NSNumber*)[index_args objectForKey:kAYServiceArgsEnd]).doubleValue * 0.001;
		return  [startStr isEqualToString:nowStr];
	} else
		return NO;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc] init];
	headView.backgroundColor = [Tools whiteColor];
	
	NSString *titleStr = @"日程";
	UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:625.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	
//	if (section == 0) {
//		UILabel *countlabel = [Tools creatUILabelWithText:@"9+" andTextColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:[UIColor redColor] andTextAlignment:NSTextAlignmentCenter];
//		[Tools setViewBorder:countlabel withRadius:10.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
//		[headView addSubview:countlabel];
//		[countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(titleLabel.mas_right).offset(5);
//			make.top.equalTo(titleLabel).offset(-2);
//			make.size.mas_equalTo(CGSizeMake(20, 20));
//		}];
//	} else {
//		titleLabel.text = @"日程";
//	}
//	
//	CGFloat margin = 10.f;
//	[Tools creatCALayerWithFrame:CGRectMake(margin, 54.5f, SCREEN_WIDTH - margin*2, 0.5) andColor:[Tools garyLineColor] inSuperView:headView];
	
//	UIButton *readMoreBtn = [Tools creatUIButtonWithTitle:@"查看全部" andTitleColor:[Tools themeColor] andFontSize:15.f andBackgroundColor:nil];
//	[headView addSubview:readMoreBtn];
//	[readMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.right.equalTo(headView).offset(-20);
//		make.centerY.equalTo(headView);
//		make.size.mas_equalTo(CGSizeMake(70, 30));
//	}];
//	[readMoreBtn addTarget:self action:@selector(didReadMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 55.f;
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//	return NO;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	PageTo to = [self isTodayRemindWithIndex:indexPath.row] ? PageToOrder : PageToService;
	NSDictionary *tmp = @{@"info":[querydata objectAtIndex:indexPath.row], @"type":[NSNumber numberWithInteger:to]};
	kAYViewSendNotify(self, @"didSelectedRow:", &tmp)
}

@end
