//
//  AYBOrderTimeItemView.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderTimeItemView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"
#import "AYServTimesBtn.h"
#import "AYBOrderTimeDefines.h"

@implementation AYBOrderTimeItemView {
	
	NSInteger weekdaySep;
	UIScrollView *scheduleView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	{
		NSDate *nowDate = [NSDate date];
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
		[calendar setTimeZone: timeZone];
		NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
		NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
		weekdaySep = theComponents.weekday - 1;
		
		NSArray *weekdayTitle = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
		for (int i = 0; i < weekdayTitle.count; ++i) {
			UILabel *itemLabel = [Tools creatUILabelWithText:[weekdayTitle objectAtIndex:(weekdaySep + i) % 7] andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
			[self addSubview:itemLabel];
			[itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(self.mas_top).offset(20);
				make.centerX.equalTo(self.mas_left).offset(itemWidth*0.5 + itemWidth * i);
			}];
		}
	}
	
	//	[self setUpReuseCell];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (void)setServiceData:(NSArray *)serviceData {
	
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"BOrderTimeItem", @"BOrderTimeItem");
	
	NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
	for (NSString* name in cell.commands.allKeys) {
		AYViewCommand* cmd = [cell.commands objectForKey:name];
		AYViewCommand* c = [[AYViewCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_commands setValue:c forKey:name];
	}
	self.commands = [arr_commands copy];
	
	NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
	for (NSString* name in cell.notifies.allKeys) {
		AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
		AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_notifies setValue:c forKey:name];
	}
	self.notifies = [arr_notifies copy];
}

#pragma mark -- actions
- (void)didTimesBtnClick:(UIButton*)btn {
	
	btn.selected = !btn.selected;
	
	NSDictionary *times = ((AYServTimesBtn*)btn).dic_times;
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]initWithDictionary:times];
	[tmp setValue:[NSNumber numberWithInt:(int)btn.tag] forKey:@"weekday"];
	[tmp setValue:[NSNumber numberWithInteger:_multiple] forKey:@"multiple"];
	[tmp setValue:btn forKey:@"btn"];
	_didTouchUpInSubBtn(tmp);
}

#pragma mark -- messages
- (id)setCellInfo:(NSArray*)dic_args {
	_item_data = dic_args;
	
	return nil;
}

- (void)setItem_data:(NSArray *)item_data {
	
	for (int i = 0; i < 7; ++i) {
		NSInteger weekday_offer_date = (weekdaySep + i) % 7;
		NSPredicate *pred_contains = [NSPredicate predicateWithFormat:@"SELF.day=%d",weekday_offer_date];
		NSArray *result_contains = [item_data filteredArrayUsingPredicate:pred_contains];
		if (result_contains.count != 0) {
			
			NSDictionary *dic_day = [result_contains firstObject];
//			NSNumber *note = [dic_day objectForKey:kAYServiceArgsWeekday];
			CGFloat offsetX = itemWidth * i;
			NSArray *timesArr = [dic_day objectForKey:kAYServiceArgsOccurance];
			for (NSDictionary *times in timesArr) {
				
				AYServTimesBtn *timesBtn = [[AYServTimesBtn alloc]initWithOffsetX:offsetX andTimesDic:times];
				[self addSubview:timesBtn];
				timesBtn.tag = i;
				timesBtn.dic_times = times;
				[timesBtn addTarget:self action:@selector(didTimesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			}
		}
	} //for end
	
}

@end
