//
//  AYHomeSortCourseCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeSortCourseCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYHomeSortCourseCellView {
	NSArray *titleArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	titleArr = @[@"美术", @"音乐", @"舞蹈", @"舞台艺术", @"球类运动", @"武术", @"竞技运动", @"形体", @"STEAM", @"自然科学", @"潜能开发"];
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		titleArr = @[@"美术", @"音乐", @"舞蹈", @"舞台艺术", @"球类运动", @"武术", @"竞技运动", @"形体", @"STEAM", @"自然科学", @"潜能开发"];
		NSArray *sort_name_s = @[
								@"draw",
								@"music",
								@"dnace",
								@"drama",
								@"ball",
								@"kungfu",
								@"athletics",
								@"yoga",
								@"steam",
								@"science",
								@"brain",];
		
		CGFloat marginLeft = 20.f;
		CGFloat marginBetween = 15.f;
		CGFloat marginTop = 10.f;
		CGFloat itemWidth = (SCREEN_WIDTH - marginLeft*2 - marginBetween)/2;
		CGFloat itemHeight = 96.f;
		
		for (int i = 0; i < sort_name_s.count; ++i) {
			int low = i%2;
			int row = i/2;
			
			UIImageView *courseSignView = [[UIImageView alloc]init];
			NSString *imageName = [NSString stringWithFormat:@"home_sort_course_%@", [sort_name_s objectAtIndex:i]];
			courseSignView.image = IMGRESOURCE(imageName);
			[Tools setViewBorder:courseSignView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
			
			courseSignView.tag = i;
			courseSignView.userInteractionEnabled = YES;
			[courseSignView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSignViewTap:)]];
			
			[self addSubview:courseSignView];
			[courseSignView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self).offset(marginLeft + (itemWidth+marginBetween)*low);
				make.top.equalTo(self).offset(marginTop + (itemHeight+marginBetween)*row);
				make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
			}];
		}
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"HomeSortCourseCell", @"HomeSortCourseCell");
	
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
- (void)didSignViewTap:(UITapGestureRecognizer*)tap {
	UIView *tapView = tap.view;
//	NSNumber *index = [NSNumber numberWithInteger:tapView.tag];
	NSString *tmp = [titleArr objectAtIndex:tapView.tag];
	kAYViewSendNotify(self, @"didCourseSortTapAtIndex:", &tmp)
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	
	
	return nil;
}

@end
