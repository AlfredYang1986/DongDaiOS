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
//	UIScrollView *scheduleView;
	
	UILabel *dayLabel;
	UILabel *todaySignLabel;
	UILabel *selectedSignLabel;
	UIView *abledSignView;
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
	
	dayLabel = [Tools creatUILabelWithText:@"Null" andTextColor:[Tools themeColor] andFontSize:316.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:dayLabel];
	[dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.centerY.equalTo(self);
	}];
	
	todaySignLabel = [Tools creatUILabelWithText:@"今天" andTextColor:[Tools themeColor] andFontSize:8.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:todaySignLabel];
	[todaySignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.bottom.equalTo(dayLabel.mas_top);
	}];
	todaySignLabel.hidden = YES;
	
	selectedSignLabel = [Tools creatUILabelWithText:@"已选" andTextColor:[Tools themeColor] andFontSize:8.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:selectedSignLabel];
	[selectedSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(dayLabel.mas_bottom);
	}];
	selectedSignLabel.hidden = YES;
	
	abledSignView = [UIView new];
	abledSignView.backgroundColor = [Tools themeColor];
	abledSignView.layer.cornerRadius = 2.5f;
	abledSignView.clipsToBounds = YES;
	[self addSubview:abledSignView];
	[abledSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.centerY.equalTo(selectedSignLabel);
		make.size.mas_equalTo(CGSizeMake(5, 5));
	}];
	abledSignView.hidden = YES;
	
	UIView *BgView = [[UIView alloc] init];
	UIView *circleView = [[UIView alloc] init];
	[BgView addSubview:circleView];
	[Tools setViewBorder:circleView withRadius:15 andBorderWidth:0.5f andBorderColor:[Tools themeColor] andBackground:nil];
	[circleView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(BgView);
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	self.selectedBackgroundView = BgView;
	
	//	[self setUpReuseCell];
}

- (void)setDay:(int)day {
	_day = day;
	dayLabel.text = [NSString stringWithFormat:@"%d", day];
}

- (void)setInitStates {
	_isEnAbled = NO;
	dayLabel.textColor = [Tools garyColor];
	abledSignView.hidden = YES;
	selectedSignLabel.hidden = YES;
	todaySignLabel.hidden = YES;
}

- (void)setTodatStates {
	dayLabel.textColor = [Tools themeColor];
	todaySignLabel.hidden = NO;
	abledSignView.hidden = NO;
}

- (void)setIsEnAbled:(BOOL)isEnAbled {
	_isEnAbled = isEnAbled;
	dayLabel.textColor = [Tools themeColor];
	abledSignView.hidden = NO;
}

- (void)setIsSelectedItem:(BOOL)isSelectedItem {
	_isSelectedItem = isSelectedItem;
	dayLabel.textColor = [Tools themeColor];
	abledSignView.hidden = YES;
	selectedSignLabel.hidden = NO;
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
	
	return nil;
}

- (void)setItem_data:(NSDictionary *)item_data {
	
	
}

@end
