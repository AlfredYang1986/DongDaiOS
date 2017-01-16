//
//  AYOrderPageContactCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 16/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderPageContactCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOrderPageContactCellView {
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *stateLabel;
	UILabel *orderNoLabel;
	UILabel *dateLabel;
	
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		//		[Tools creatCALayerWithFrame:CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		photoIcon = [[UIImageView alloc]init];
		photoIcon.image = IMGRESOURCE(@"default_user");
		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
		photoIcon.layer.cornerRadius = 22.5;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 2.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(20);
			make.size.mas_equalTo(CGSizeMake(45, 45));
		}];
		//	photoIcon.userInteractionEnabled = YES;
		//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		titleLabel = [Tools creatUILabelWithText:@"Servant's Service With Theme" andTextColor:[Tools blackColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(photoIcon.mas_right).offset(10);
			make.top.equalTo(photoIcon);
		}];
		
		//		stateLabel = [Tools creatUILabelWithText:@"Order state" andTextColor:[Tools blackColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		//		[self addSubview:stateLabel];
		//		[stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		//			make.centerY.equalTo(titleLabel);
		//			make.right.equalTo(self).offset(-20);
		//		}];
		
		//		orderNoLabel = [Tools creatUILabelWithText:@"Order NO" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		//		[self addSubview:orderNoLabel];
		//		[orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		//			make.left.equalTo(titleLabel);
		//			make.top.equalTo(titleLabel.mas_bottom).offset(10);
		//		}];
		
		dateLabel = [Tools creatUILabelWithText:@"01-01 00:00-00:00" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
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
	id<AYViewBase> cell = VIEW(@"OrderInfoPageCell", @"OrderInfoPageCell");
	
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
	
	NSString *photo_name = [order_info objectForKey:@"screen_photo"];
	if (photo_name) {
		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
		NSString *pre = cmd.route;
		[photoIcon sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
					 placeholderImage:IMGRESOURCE(@"default_user")];
	}
	
	NSString *titleStr = [NSString stringWithFormat:@"%@ · %@", [order_info objectForKey:@"screen_name"], [[order_info objectForKey:@"service"] objectForKey:@"title"]];
	if (titleStr && ![titleStr isEqualToString:@""]) {
		titleLabel.text = titleStr;
	}
	
	NSDictionary *order_date = [args objectForKey:@"order_date"];
	NSTimeInterval start = ((NSNumber*)[order_date objectForKey:@"start"]).longValue;
	NSTimeInterval end = ((NSNumber*)[order_date objectForKey:@"end"]).longValue;
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start * 0.001];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end * 0.001];
	
	NSDateFormatter *formatterDay = [[NSDateFormatter alloc]init];
	[formatterDay setDateFormat:@"MM月dd日"];
	NSString *dayStr = [formatterDay stringFromDate:startDate];
	
	NSDateFormatter *formatterTime = [[NSDateFormatter alloc]init];
	[formatterTime setDateFormat:@"HH:mm"];
	NSString *startStr = [formatterTime stringFromDate:startDate];
	NSString *endStr = [formatterTime stringFromDate:endDate];
	
	dateLabel.text = [NSString stringWithFormat:@"%@, %@ - %@", dayStr, startStr, endStr];
	
	stateLabel.textColor = [Tools garyColor];
	stateLabel.text = @"待处理";
	
	return nil;
}

@end
