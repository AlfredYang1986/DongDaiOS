//
//  AYMapMatchCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapMatchCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

@implementation AYMapMatchCellView {
	
	UIImageView *coverImage;
	UILabel *titleLabel;
	UIImageView *photoIcon;
	
	UILabel *priceLabel;
	UILabel *capacityLabel;
	
	UIImageView *positionImage;
	UILabel *addressLabel;
	
	UIButton *likeBtn;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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
	
	UIImage *bgImg = IMGRESOURCE(@"message_bg_one");
	bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 10, 10) resizingMode:UIImageResizingModeStretch];
	
	UIView *tView = [[UIView alloc]init];
	tView.backgroundColor = [Tools colorWithRED:(arc4random()%255) GREEN:(arc4random()%255) BLUE:(arc4random()%255) ALPHA:1.f];
	[self addSubview:tView];
	[tView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 240));
	}];
	
//	[self setUpReuseCell];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"MapMatchCell", @"MapMatchCell");
	
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
- (void)ownerIconTap:(UITapGestureRecognizer*)tap {
	
	AYViewController* des = DEFAULTCONTROLLER(@"OneProfile");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	service_info = dic_args;
	
	NSString* photo_name = [[service_info objectForKey:@"images"] objectAtIndex:0];
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	[coverImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
				  placeholderImage:IMGRESOURCE(@"default_image")];
	
	NSString *screen_photo = [service_info objectForKey:kAYServiceArgsScreenPhoto];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:screen_photo]]
				 placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSString *unitCat;
	NSNumber *leastTimesOrHours;
	
	NSString *ownerName = [service_info objectForKey:kAYServiceArgsScreenName];
	NSArray *options_title_cans;
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	NSNumber *cans_cat = [service_info objectForKey:kAYServiceArgsCourseCat];
	
	if (service_cat.intValue == ServiceTypeLookAfter) {
		unitCat = @"小时";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastHours];
		
		options_title_cans = kAY_service_options_title_lookafter;
		//服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			titleLabel.text = @"该服务主题待调整";
		} else {
			NSString *themeStr = options_title_cans[cans_cat.integerValue];
			titleLabel.text = [NSString stringWithFormat:@"%@的%@", ownerName,themeStr];
		}
		
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		unitCat = @"次";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastTimes];
		
		NSString *servCatStr = @"课程";
		options_title_cans = kAY_service_options_title_course;
		NSNumber *cans = [service_info objectForKey:kAYServiceArgsCourseSign];
		//服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			titleLabel.text = @"该服务主题待调整";
		}
		else {
			
			NSString *costomStr = [service_info objectForKey:kAYServiceArgsCourseCoustom];
			if (costomStr && ![costomStr isEqualToString:@""]) {
				titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", ownerName, costomStr, servCatStr];
				
			} else {
				NSArray *courseTitleOfAll = kAY_service_course_title_ofall;
				NSArray *signTitleArr = [courseTitleOfAll objectAtIndex:cans_cat.integerValue];
				if (cans.integerValue < signTitleArr.count) {
					NSString *courseSignStr = [signTitleArr objectAtIndex:cans.integerValue];
					titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", ownerName, courseSignStr, servCatStr];
				} else {
					titleLabel.text = @"该服务主题待调整";
				}
			}//是否自定义课程标签判断end
		}
	}
	
	NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%@", price];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
	capacityLabel.text = [NSString stringWithFormat:@"最少预定%@%@", leastTimesOrHours, unitCat];
	[capacityLabel sizeToFit];
	[capacityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(priceLabel.mas_right).offset(8);
		make.centerY.equalTo(priceLabel);
		make.size.mas_equalTo(CGSizeMake(capacityLabel.bounds.size.width + 8, capacityLabel.bounds.size.height + 4));
	}];
	
	addressLabel.text = [service_info objectForKey:kAYServiceArgsAddress];
	
	NSNumber *iscollect = [service_info objectForKey:@"iscollect"];
	likeBtn.selected = iscollect.boolValue;
	
	return nil;
}

@end
