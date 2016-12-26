//
//  AYServiceDescCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceDescCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYServiceDescCellView {
	
	UILabel *tipsTitleLabel;
	UILabel *courseLengthLabel;
	UILabel *serviceDescLabel;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.clipsToBounds = YES;
		
		tipsTitleLabel = [Tools creatUILabelWithText:@"Section Head" andTextColor:[Tools blackColor] andFontSize:-15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self).offset(30);
		}];
		
		courseLengthLabel = [Tools creatUILabelWithText:@"Lection Length" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewRadius:courseLengthLabel withRadius:12.5f andBorderWidth:0 andBorderColor:nil andBackground:[Tools garyBackgroundColor]];
		[self addSubview:courseLengthLabel];
		[courseLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.size.mas_equalTo(CGSizeMake(140, 25));
		}];
		
		serviceDescLabel = [Tools creatUILabelWithText:@"Service Description" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		serviceDescLabel.numberOfLines = 0;
		[self addSubview:serviceDescLabel];
		[serviceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(65);
			make.left.equalTo(self).offset(15);
			make.right.equalTo(self).offset(-15);
			make.bottom.equalTo(self).offset(-30);
		}];
		
		CGFloat margin = 0;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
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
	id<AYViewBase> cell = VIEW(@"ServiceOwnerInfoCell", @"ServiceOwnerInfoCell");
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
- (void)didOwnerPhotoClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"OneProfile");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	service_info = (NSDictionary*)args;
	
	NSString *descStr = [service_info objectForKey:kAYServiceArgsDescription];
	serviceDescLabel.text = descStr;
	
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	switch (service_cat.intValue) {
	case ServiceTypeCourse:
	{
		tipsTitleLabel.text = @"课程描述";
		NSNumber *course_length = [service_info objectForKey:kAYServiceArgsCourseduration];
		courseLengthLabel.text = [NSString stringWithFormat:@"课程时长%@分钟", course_length];
		
	}
		break;
	case ServiceTypeLookAfter:
	{
		tipsTitleLabel.text = @"服务描述";
		courseLengthLabel.hidden = YES;
		[serviceDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.left.equalTo(self).offset(15);
			make.right.equalTo(self).offset(-15);
			make.bottom.equalTo(self).offset(-30);
		}];
	}
		break;
			
  default:
			break;
	}
	
	
	return nil;
}

@end
