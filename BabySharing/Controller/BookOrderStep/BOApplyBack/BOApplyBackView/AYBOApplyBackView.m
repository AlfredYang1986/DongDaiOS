//
//  AYBOApplyBackView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYBOApplyBackView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"


@implementation AYBOApplyBackView {
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle


#pragma mark -- commands
- (void)postPerform {
	UIImageView *iconView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"checked_icon")];
	[self addSubview:iconView];
	[iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.centerX.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	
	UILabel *tipsLabel = [Tools creatUILabelWithText:@"申请已发送至服务方，请等待服务方处理" andTextColor:[Tools blackColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:tipsLabel];
	[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(iconView.mas_bottom).offset(25);
	}];
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


@end
