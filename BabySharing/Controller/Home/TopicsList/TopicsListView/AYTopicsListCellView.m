//
//  AYTopicsListCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTopicsListCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYTopicsListCellView {
	UIImageView *imageView;
	UILabel *topicTitle;
	UILabel *topicCount;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		imageView = [[UIImageView alloc]init];
		imageView.backgroundColor = [Tools randomColor];
		[Tools setViewBorder:imageView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[self addSubview: imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 160));
		}];
		
		topicTitle = [Tools creatUILabelWithText:@"# Topics' title #" andTextColor:[Tools whiteColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:topicTitle];
		[topicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(imageView).offset(-30);
			make.centerX.equalTo(self);
		}];
		
		topicCount = [Tools creatUILabelWithText:@"Topics' count" andTextColor:[Tools RGB127GaryColor] andFontSize:11.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:topicCount withRadius:10.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools borderAlphaColor]];
		[self addSubview:topicCount];
		[topicCount sizeToFit];
		[topicCount mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(topicTitle.mas_bottom).offset(10);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(topicCount.bounds.size.width + 20, 20));
		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"TopicsListCell", @"TopicsListCell");
	
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


#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	return nil;
}

@end
