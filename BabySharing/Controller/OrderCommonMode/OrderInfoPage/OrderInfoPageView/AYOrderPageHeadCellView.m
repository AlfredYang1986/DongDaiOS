//
//  AYOrderInfoPageCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderPageHeadCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYOrderPageTimeView.h"

@implementation AYOrderPageHeadCellView {
	
//	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *orderNoLabel;
	UILabel *addressLabel;
	UILabel *sumPriceLabel;
	UILabel *unitPriceLabel;
	
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
//		[Tools creatCALayerWithFrame:CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
//		photoIcon = [[UIImageView alloc]init];
//		photoIcon.image = IMGRESOURCE(@"default_user");
//		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
//		photoIcon.layer.cornerRadius = 22.5;
//		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
//		photoIcon.layer.borderWidth = 2.f;
//		photoIcon.clipsToBounds = YES;
//		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
//		[self addSubview:photoIcon];
//		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(self).offset(20);
//			make.top.equalTo(self).offset(20);
//			make.size.mas_equalTo(CGSizeMake(45, 45));
//		}];
		//	photoIcon.userInteractionEnabled = YES;
		//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		titleLabel = [Tools creatUILabelWithText:@"Servant's Service With Theme" andTextColor:[Tools blackColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(self).offset(15);
		}];
		
		orderNoLabel = [Tools creatUILabelWithText:@"Order NO" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:orderNoLabel];
		[orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
		}];
		
		/*******************************/
		
		unitPriceLabel = [Tools creatUILabelWithText:@"$100 * 1 Uint" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:unitPriceLabel];
		[unitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.bottom.equalTo(self.mas_bottom).offset(-15);
		}];
		
		sumPriceLabel = [Tools creatUILabelWithText:@"$100" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:sumPriceLabel];
		[sumPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(unitPriceLabel);
			make.bottom.equalTo(unitPriceLabel.mas_top).offset(-10);
		}];
		
		UILabel *priceTitle = [Tools creatUILabelWithText:@"价格" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:priceTitle];
		[priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.centerY.equalTo(sumPriceLabel);
		}];
		
		addressLabel = [Tools creatUILabelWithText:@"01-01 00:00-00:00" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.bottom.equalTo(sumPriceLabel.mas_top).offset(-50);
		}];
		
		UIView *line_btm = [[UIView alloc]init];
		line_btm.backgroundColor = [Tools garyLineColor];
		[self addSubview:line_btm];
		[line_btm mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
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
	id<AYViewBase> cell = VIEW(@"OrderPageHeadCell", @"OrderPageHeadCell");
	
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
	service_info = [order_info objectForKey:@"service"];
	
	NSString *unitCat = @"UNIT";
	NSNumber *leastTimesOrHours = @1;
	
	NSString *ownerName = [service_info objectForKey:kAYServiceArgsScreenName];
	NSArray *options_title_cans;
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	NSNumber *cans_cat = [service_info objectForKey:kAYServiceArgsCourseCat];
	
	if (service_cat.intValue == ServiceTypeLookAfter) {
		unitCat = @"小时";
		
		NSNumber *tmp = [service_info objectForKey:kAYServiceArgsLeastHours];
		if (![tmp isEqualToNumber:@0]) {
			leastTimesOrHours = tmp;
		}
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
		
		NSNumber *tmp = [service_info objectForKey:kAYServiceArgsLeastTimes];
		if (![tmp isEqualToNumber:@0]) {
			leastTimesOrHours = tmp;
		}
		
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
	} else {
		
		NSLog(@"---null---");
		titleLabel.text = @"该服务类型待调整";
	}
	
	NSNumber *price = [order_info objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%@", price];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@", price];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	sumPriceLabel.attributedText = attributedText;
	
	unitPriceLabel.text = [NSString stringWithFormat:@"¥100／%@*%@", unitCat, leastTimesOrHours];
	
	id order_date = [order_info objectForKey:@"order_date"];
	if ( [order_date isKindOfClass:[NSArray class]]) {
		
	} else /*if ( [tmp isKindOfClass:[NSDictionary class]]) */{
		
	}
	
	return nil;
}

@end
