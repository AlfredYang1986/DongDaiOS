//
//  AYOTMHistoryCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 9/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOTMHistoryCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOTMHistoryCellView {
	
	UILabel *mouthLabel;
	UILabel *dayLabel;
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *dateLabel;
	UILabel *positionLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
//		self.backgroundColor = [UIColor clearColor];
//		[Tools creatCALayerWithFrame:CGRectMake(85, 0, 1, 90) andColor:[Tools lightGreyColor] inSuperView:self];
		
		CGFloat marginLeft = 65.f;
		UIView *leftLineView = [[UIView alloc] init];
		leftLineView.backgroundColor = [Tools garyLineColor];
		[self addSubview:leftLineView];
		[leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(marginLeft);
			make.top.equalTo(self);
			make.bottom.equalTo(self);
			make.width.mas_equalTo(1);
		}];
		
		UIView *pointSignView = [UIView new];
		[Tools setViewBorder:pointSignView withRadius:5.f andBorderWidth:0.f andBorderColor:nil andBackground:[Tools garyLineColor]];
		[self addSubview:pointSignView];
		[pointSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(leftLineView);
			make.top.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		mouthLabel = [Tools creatUILabelWithText:@"01月" andTextColor:[Tools garyColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:mouthLabel];
		[mouthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(marginLeft * 0.5);
			make.top.equalTo(self);
		}];
		
		dayLabel = [Tools creatUILabelWithText:@"01" andTextColor:[Tools blackColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:dayLabel];
		[dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(mouthLabel.mas_bottom).offset(3);
			make.centerX.equalTo(mouthLabel);
		}];
		
		UIImageView *bgView = [[UIImageView alloc] init];
		UIImage *bg = IMGRESOURCE(@"otm_history_bg");
		bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(20, 15, 10, 10) resizingMode:UIImageResizingModeStretch];
		bgView.image = bg;
		[self addSubview:bgView];
		[bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 75, 25, 20));
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
			make.right.equalTo(bgView).offset(-15);
			make.top.equalTo(bgView).offset(15);
			make.size.mas_equalTo(CGSizeMake(photoImageWidth, photoImageWidth));
		}];
		
		titleLabel = [Tools creatUILabelWithText:@"service title" andTextColor:[Tools whiteColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.left.equalTo(bgView).offset(20);
		}];
		
		UIImageView *olockIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"timeflow_icon_olock")];
		[self addSubview:olockIcon];
		[olockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bgView).offset(20);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		dateLabel = [Tools creatUILabelWithText:@"00:00 - 00:00" andTextColor:[Tools whiteColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		dateLabel.numberOfLines = 0;
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(olockIcon).offset(0);
			make.left.equalTo(bgView).offset(35);
		}];
		
		UIImageView *positionIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"position")];
		[self addSubview:positionIcon];
		[positionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(olockIcon);
			make.top.equalTo(olockIcon.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		positionLabel = [Tools creatUILabelWithText:@"service position address info" andTextColor:[Tools whiteColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:positionLabel];
		[positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(positionIcon);
			make.left.equalTo(dateLabel);
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
	id<AYViewBase> cell = VIEW(@"OTMHistoryCell", @"OTMHistoryCell");
	
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
//	{
//		address = "Beijing Haidian Driving School Registration Office (Dongsheng Student Accommodation Unit Southwest)";
//		cans = "-1";
//		"cans_cat" = 0;
//		end = 1494637200000;
//		"order_id" = 5ec0d0e954acebfecbc617eab87d08c8;
//		"order_thumbs" = "EAC8BAE9-46FB-4054-94E0-70B32E2C82E1";
//		"order_title" = "Sunfei' Service";
//		owner =     {
//			"screen_name" = Singer;
//			"screen_photo" = "A25F3F2C-9619-484D-8EB6-B7B187BA4F9A";
//		};
//		reserve1 = "";
//		"service_cat" = 1;
//		"service_id" = 4b99af39a03c518f794f4f1ff799f66c;
//		start = 1494633600000;
//		user =     {
//			"screen_name" = "\U827e\U4f26\U4e36\U7c73\U4fee\U65af";
//			"screen_photo" = "3B958915-E9D8-4D36-B995-A98C907EFEA0";
//		};
//	}
	
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
	
	NSDateFormatter *formatterM = [Tools creatDateFormatterWithString:@"MM月"];
	NSString *mouthStr = [formatterM stringFromDate:startDate];
	mouthLabel.text = mouthStr;
	
	NSDateFormatter *formatterD = [Tools creatDateFormatterWithString:@"dd"];
	NSString *dayStr = [formatterD stringFromDate:startDate];
	dayLabel.text = dayStr;
	
	NSDateFormatter *formatterTime = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSString *startStr = [formatterTime stringFromDate:startDate];
	NSString *endStr = [formatterTime stringFromDate:endDate];
	dateLabel.text = [NSString stringWithFormat:@"%@ - %@", startStr, endStr];
	
	return nil;
}

@end
