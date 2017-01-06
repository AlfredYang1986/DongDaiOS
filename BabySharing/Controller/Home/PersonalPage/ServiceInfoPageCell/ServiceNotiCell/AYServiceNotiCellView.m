//
//  AYServiceNotiCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceNotiCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYServiceNotiCellView {
	UILabel *tipsTitleLabel;
	UILabel *allowLabel;
	UILabel *otherWordLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		CGFloat margin = 0;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		tipsTitleLabel = [Tools creatUILabelWithText:@"《 服务守则 》" andTextColor:[Tools blackColor] andFontSize:-15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self).offset(30);
		}];
		
		allowLabel = [Tools creatUILabelWithText:@"·  Is Allow leave" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:allowLabel];
		[allowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
		}];
		
		otherWordLabel = [Tools creatUILabelWithText:@"·  Other Words" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		otherWordLabel.numberOfLines = 0;
		[self addSubview:otherWordLabel];
		[otherWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(allowLabel);
			make.right.equalTo(self).offset(-15);
			make.top.equalTo(allowLabel.mas_bottom).offset(12);
			make.bottom.equalTo(self).offset(-20);
		}];
//		otherWordLabel.hidden = YES;
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"ServiceNotiCell", @"ServiceNotiCell");
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
- (void)didDetailBtnClick {
	kAYViewSendNotify(self, @"showServiceOfferDate", nil)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	
	NSDictionary *service_info = args;
	
	NSString *leaveStr = @"·  不需要家长陪同";
	NSNumber *isAllow = [service_info objectForKey:kAYServiceArgsAllowLeave];
	if (isAllow.boolValue) {
		leaveStr = @"·  需要家长陪同";
	}
	allowLabel.text = leaveStr;
	
	NSString *otherWords = [service_info objectForKey:kAYServiceArgsNotice];
	if (!otherWords || [otherWords isEqualToString:@""]) {
		[allowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.bottom.equalTo(self).offset(-30);
		}];
		
		otherWordLabel.hidden = YES;
	} else {
		
		NSString *noticeStr = [NSString stringWithFormat:@"·  %@", otherWords];
		if ([noticeStr containsString:@"\n"]) {
			noticeStr = [noticeStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\n·  "];
		}
		otherWordLabel.text = noticeStr;
	}
	
	return nil;
}

@end
