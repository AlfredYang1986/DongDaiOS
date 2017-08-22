//
//  AYHomeSortNurseryCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeSortNurseryCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYHomeSortNurseryCellView {
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		CGFloat margin = 20.f;
		
		UIView *dailyBgView = [[UIView alloc] init];
		dailyBgView.backgroundColor = [Tools whiteColor];
		[Tools setShadowOfView:dailyBgView withViewRadius:4.f andColor:[Tools colorWithRED:240 GREEN:176 BLUE:58 ALPHA:1.f] andOffset:CGSizeMake(0, 3) andOpacity:0.3f andShadowRadius:3.f];
		[self addSubview:dailyBgView];
		[dailyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(margin);
			make.top.equalTo(self).offset(10);
			make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - margin*2 - 15)/2, 95));
		}];
		
		UIImageView *nurseryDailySignView = [[UIImageView alloc] init];
		nurseryDailySignView.tag = 0;
		nurseryDailySignView.image = IMGRESOURCE(@"home_sort_nursary_daily");
		[Tools setViewBorder:nurseryDailySignView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[self addSubview:nurseryDailySignView];
		[nurseryDailySignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(margin);
			make.top.equalTo(self).offset(10);
			make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - margin*2 - 15)/2, 95));
		}];
		
		UIView *afterclassBgView = [[UIView alloc] init];
		afterclassBgView.backgroundColor = [Tools whiteColor];
		[Tools setShadowOfView:afterclassBgView withViewRadius:4.f andColor:[Tools colorWithRED:78 GREEN:128 BLUE:238 ALPHA:1.f] andOffset:CGSizeMake(0, 3) andOpacity:0.3f andShadowRadius:3.f];
		[self addSubview:afterclassBgView];
		[afterclassBgView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-margin);
			make.top.equalTo(self).offset(10);
			make.size.equalTo(nurseryDailySignView);
		}];
		
		UIImageView *nurseryAfterClassSignView = [[UIImageView alloc] init];
		nurseryAfterClassSignView.tag = 1;
		[Tools setViewBorder:nurseryAfterClassSignView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		nurseryAfterClassSignView.image = IMGRESOURCE(@"home_sort_nursary_afterclass");
		[self addSubview:nurseryAfterClassSignView];
		[nurseryAfterClassSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-margin);
			make.top.equalTo(self).offset(10);
			make.size.equalTo(nurseryDailySignView);
		}];
		
		nurseryDailySignView.userInteractionEnabled = nurseryAfterClassSignView.userInteractionEnabled = YES;
		[nurseryDailySignView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didNursarySignTap:)]];
		[nurseryAfterClassSignView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didNursarySignTap:)]];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"HomeSortNurseryCell", @"HomeSortNurseryCell");
	
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

#pragma mark -- actions
- (void)didNursarySignTap:(UITapGestureRecognizer*)tap {
	UIView *tapView = tap.view;
	NSNumber *tag = [NSNumber numberWithInteger:tapView.tag];
	kAYViewSendNotify(self, @"didNursarySortTapAtIndex:", &tag)
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	
	
	
	return nil;
}

@end
