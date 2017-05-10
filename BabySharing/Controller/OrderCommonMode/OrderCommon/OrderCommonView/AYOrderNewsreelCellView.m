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

@implementation AYOrderNewsreelCellView {
	
	UILabel *dateLabel;
	
	UIView *pointSignView;
	UILabel *titleLabel;
	UIImageView *photoIcon;
	
	UIImageView *startTimeIcon;
	UILabel *startTimeLabel;
	UIImageView *endTimeIcon;
	UILabel *endTimeLabel;
	
	UIImageView *positionIcon;
	UILabel *positionLabel;
	
	/*****/
	UIImageView *remindOlockIcon;
	UILabel *remindLabel;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		CGFloat marginLeft = 65.f;
		UIView *leftLineView = [[UIView alloc] init];
		
		leftLineView.backgroundColor = [Tools garyLineColor];
		[self addSubview:leftLineView];
		[leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(marginLeft);
			make.top.equalTo(self).offset(10);
			make.bottom.equalTo(self);
			make.width.mas_equalTo(1);
		}];
		
		pointSignView = [UIView new];
		[Tools setViewBorder:pointSignView withRadius:5.f andBorderWidth:0.f andBorderColor:nil andBackground:[Tools garyLineColor]];
		[self addSubview:pointSignView];
		[pointSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(leftLineView);
			make.top.equalTo(leftLineView);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		dateLabel = [Tools creatUILabelWithText:@"Today" andTextColor:[Tools blackColor] andFontSize:318.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(marginLeft * 0.5);
			make.centerY.equalTo(pointSignView);
		}];
		
		titleLabel = [Tools creatUILabelWithText:@"service title" andTextColor:[Tools blackColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(marginLeft+15);
			make.centerY.equalTo(pointSignView);
		}];
		
		CGFloat photoImageWidth = 45.f;
		photoIcon = [[UIImageView alloc]init];
		photoIcon.image = IMGRESOURCE(@"default_user");
		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
		photoIcon.layer.cornerRadius = 2.f;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 1.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-40);
			make.top.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(photoImageWidth, photoImageWidth));
		}];
		
		remindOlockIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_olock")];
		[self addSubview:remindOlockIcon];
		[remindOlockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(pointSignView.mas_bottom).offset(15);
			make.centerX.equalTo(pointSignView);
			make.size.mas_equalTo(CGSizeMake(15, 15));
		}];
		remindLabel = [Tools creatUILabelWithText:@"Remind message" andTextColor:[Tools themeColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:remindLabel];
		[remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(remindOlockIcon);
			make.left.equalTo(titleLabel);
		}];
		
		startTimeIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_time")];
		[self addSubview:startTimeIcon];
		[startTimeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(remindOlockIcon.mas_bottom).offset(15);
			make.centerX.equalTo(pointSignView);
			make.size.mas_equalTo(CGSizeMake(15, 15));
		}];
		startTimeLabel = [Tools creatUILabelWithText:@"00:00 Start Olcok" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:startTimeLabel];
		[startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(startTimeIcon);
			make.left.equalTo(titleLabel);
		}];
		
		endTimeIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_time")];
		[self addSubview:endTimeIcon];
		[endTimeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(startTimeIcon.mas_bottom).offset(15);
			make.centerX.equalTo(pointSignView);
			make.size.mas_equalTo(CGSizeMake(15, 15));
		}];
		endTimeLabel = [Tools creatUILabelWithText:@"00:00 End Olcok" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:endTimeLabel];
		[endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(endTimeIcon);
			make.left.equalTo(titleLabel);
		}];
		
		positionIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_position")];
		[self addSubview:positionIcon];
		[positionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(pointSignView);
			make.top.equalTo(endTimeIcon.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
		}];
		positionLabel = [Tools creatUILabelWithText:@"service position address info" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		positionLabel.numberOfLines = 0;
		[self addSubview:positionLabel];
		[positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(positionIcon.mas_centerY).offset(-10);
			make.left.equalTo(titleLabel);
			make.right.equalTo(photoIcon);
		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
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
- (id)setCellInfo:(id)args {
	
	NSDictionary *order_info = (NSDictionary*)args;
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	
	NSString *photo_name = [[order_info objectForKey:@"owner"] objectForKey:kAYServiceArgsScreenPhoto];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, photo_name]]
				 placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSString *compName = [Tools serviceCompleteNameFromSKUWith:order_info];
	NSString *userName = [[order_info objectForKey:@"owner"] objectForKey:kAYServiceArgsScreenName];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@", userName, compName];
	
	NSString *addrStr = [order_info objectForKey:@"address"];
	positionLabel.text = addrStr;
	
	
	NSTimeInterval start = ((NSNumber*)[order_info objectForKey:@"start"]).longValue * 0.001;
	NSTimeInterval end = ((NSNumber*)[order_info objectForKey:@"end"]).longValue * 0.001;
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
	
	NSDateFormatter *formatterTime = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSString *startStr = [formatterTime stringFromDate:startDate];
	NSString *endStr = [formatterTime stringFromDate:endDate];
	startTimeLabel.text = [NSString stringWithFormat:@"%@ 开始时间", startStr];
	endTimeLabel.text = [NSString stringWithFormat:@"%@ 结束时间", endStr];
	
	remindLabel.text = @"课程即将开始，请合理安排日程";
	
	return nil;
}

@end
