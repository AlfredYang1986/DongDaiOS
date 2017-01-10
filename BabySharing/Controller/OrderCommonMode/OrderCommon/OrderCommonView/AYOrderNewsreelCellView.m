//
//  AYOrderNewsreelCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderNewsreelCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "InsetsLabel.h"
#import "OBShapedButton.h"

@implementation AYOrderNewsreelCellView {
	
	UILabel *titleLabel;
	UILabel *positionLabel;
	UILabel *dateLabel;
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		[Tools creatCALayerWithFrame:CGRectMake(85, 0, 1, 90) andColor:[Tools lightGreyColor] inSuperView:self];
		
		dateLabel = [Tools creatUILabelWithText:@"01/10\nEEEE" andTextColor:[Tools blackColor] andFontSize:-15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		dateLabel.numberOfLines = 0;
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(85*0.5);
			make.centerY.equalTo(self);
		}];
		
		UIImageView *payWayIcon = [UIImageView new];
		payWayIcon.image = IMGRESOURCE(@"wechat");
		[self addSubview:payWayIcon];
		[payWayIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			//            make.top.equalTo(titleLabel.mas_bottom).offset(20);
			make.centerX.equalTo(self.mas_left).offset(85);
			make.top.equalTo(self).offset(25);
			make.size.mas_equalTo(CGSizeMake(15, 15));
		}];
		
		titleLabel = [Tools creatUILabelWithText:@"service title" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(payWayIcon);
			make.left.equalTo(payWayIcon.mas_right).offset(15);
		}];
		
		UIImageView *signView = [UIImageView new];
		signView.image = IMGRESOURCE(@"checked_icon");
		[self addSubview:signView];
		[signView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(payWayIcon);
			make.top.equalTo(payWayIcon.mas_bottom).offset(12);
			make.size.mas_equalTo(CGSizeMake(15, 15));
		}];
		
		positionLabel = [Tools creatUILabelWithText:@"service position" andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:positionLabel];
		[positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(signView);
			make.left.equalTo(signView.mas_right).offset(15);
		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"OrderNewsreelCell", @"OrderNewsreelCell");
	
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
- (id)setCellInfo:(NSDictionary*)dic_args {
	
	return nil;
}

@end
