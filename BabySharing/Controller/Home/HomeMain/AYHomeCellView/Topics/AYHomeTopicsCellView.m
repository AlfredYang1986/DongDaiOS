//
//  AYHomeTopicsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeTopicsCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

@implementation AYHomeTopicsCellView {
	UIImageView *imageView00;
	UIImageView *imageView01;
	
	UILabel *topicTitle00;
	UILabel *topicTitle01;
	
	UILabel *topicCount00;
	UILabel *topicCount01;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		UILabel *titleLabel = [Tools creatUILabelWithText:@"Least Topics" andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(10);
		}];
		
		UIButton *moreBtn = [Tools creatUIButtonWithTitle:@"More" andTitleColor:[Tools RGB153GaryColor] andFontSize:13.f andBackgroundColor:nil];
		[moreBtn addTarget:self action:@selector(didTopicsMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:moreBtn];
		[moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(60, 20));
		}];
		
		imageView00 = [[UIImageView alloc]init];
		imageView00.backgroundColor = [UIColor orangeColor];
		[Tools setViewBorder:imageView00 withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[self addSubview: imageView00];
		[imageView00 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(titleLabel.mas_bottom).offset(20);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 85));
		}];
		
		topicTitle00 = [Tools creatUILabelWithText:@"#Topics' title#" andTextColor:[Tools whiteColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:topicTitle00];
		[topicTitle00 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(imageView00).offset(10);
			make.centerX.equalTo(self);
		}];
		
		topicCount00 = [Tools creatUILabelWithText:@"Topics' count" andTextColor:[Tools RGB127GaryColor] andFontSize:11.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:topicCount00 withRadius:10.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools borderAlphaColor]];
		[self addSubview:topicCount00];
		[topicCount00 sizeToFit];
		[topicCount00 mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(topicTitle00.mas_bottom).offset(10);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(topicCount00.bounds.size.width + 20, 20));
		}];
		
		
		imageView01 = [[UIImageView alloc]init];
		imageView01.backgroundColor = [UIColor orangeColor];
		[Tools setViewBorder:imageView01 withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[self addSubview: imageView01];
		[imageView01 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(imageView00.mas_bottom).offset(10);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 85));
		}];
		
		topicTitle01 = [Tools creatUILabelWithText:@"Topics' title" andTextColor:[Tools whiteColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:topicTitle01];
		[topicTitle01 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(imageView01).offset(10);
			make.centerX.equalTo(self);
		}];
		
		topicCount01 = [Tools creatUILabelWithText:@"Topics' count" andTextColor:[Tools RGB127GaryColor] andFontSize:11.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:topicCount01 withRadius:10.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools borderAlphaColor]];
		[self addSubview:topicCount01];
		[topicCount01 sizeToFit];
		[topicCount01 mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(topicTitle01.mas_bottom).offset(10);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(topicCount00.bounds.size.width + 20, 20));
		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"HomeTopicsCell", @"HomeTopicsCell");
	
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
- (void)didTopicsMoreBtnClick {
	kAYViewSendNotify(self, @"didTopicsMoreBtnClick", nil)
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	return nil;
}

@end
