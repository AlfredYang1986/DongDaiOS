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
#import "AYPServsCellView.h"

@implementation AYMapMatchCellView {
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *priceLabel;
//	UITableView *servTableView;
	
	UIImageView *coverImage;
	UILabel *timeLine00;
	UILabel *moreTips;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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
	
	UIImageView *bgView= [[UIImageView alloc]init];
	UIImage *bgImg = IMGRESOURCE(@"map_match_bg");
	bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 100, 10, 10) resizingMode:UIImageResizingModeStretch];
	bgView.image = bgImg;
	[self addSubview:bgView];
	[bgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
	}];
	
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
		make.left.equalTo(self).offset(47.5);
		make.top.equalTo(self).offset(10);
		make.size.mas_equalTo(CGSizeMake(45, 45));
	}];
//	photoIcon.userInteractionEnabled = YES;
//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
	
	titleLabel = [Tools creatUILabelWithText:@"服务妈妈的主题服务" andTextColor:[Tools blackColor] andFontSize:317.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(35);
		make.top.equalTo(photoIcon.mas_bottom).offset(20);
	}];
	
	priceLabel = [Tools creatUILabelWithText:@"周日，00:00 - 00:00" andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:priceLabel];
	[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(5);
	}];
	
	timeLine00 = [Tools creatUILabelWithText:@"周日，00:00 - 00:00" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:timeLine00];
	[timeLine00 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(priceLabel.mas_bottom).offset(15);
	}];
	
	moreTips = [Tools creatUILabelWithText:@"更多时间" andTextColor:[Tools themeColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:moreTips];
	[moreTips mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(timeLine00);
		make.top.equalTo(timeLine00.mas_bottom).offset(10);
	}];
	
	coverImage = [[UIImageView alloc]init];
	coverImage.image = IMGRESOURCE(@"theme_image");
	coverImage.contentMode = UIViewContentModeScaleAspectFill;
	coverImage.clipsToBounds = YES;
	[self addSubview:coverImage];
	[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(moreTips);
		make.right.equalTo(self).offset(-35);
		make.size.mas_equalTo(CGSizeMake(92, 62));
	}];
	
//	servTableView = [[UITableView alloc]init];
//	servTableView.delegate = self;
//	servTableView.dataSource = self;
//	servTableView.showsVerticalScrollIndicator = NO;
//	servTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//	[self addSubview:servTableView];
//	[servTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerX.equalTo(self);
//		make.top.equalTo(titleLabel.mas_bottom).offset(15);
//		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 70, 160));
//	}];
//	
//	[servTableView registerClass:NSClassFromString(@"AYPServsCellView") forCellReuseIdentifier:@"AYPServsCellView"];
	
//	[self setUpReuseCell];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (void)setService_info:(NSDictionary *)service_info {
	_service_info = service_info;
	NSString* photo_name = [[service_info objectForKey:@"images"] objectAtIndex:0];
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	if (photo_name) {
		
		[coverImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
					  placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
	NSString *screen_photo = [service_info objectForKey:kAYServiceArgsScreenPhoto];
	if (screen_photo) {
		
		[photoIcon sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:screen_photo]]
					 placeholderImage:IMGRESOURCE(@"default_user")];
	}
	
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
	} else {
		
		NSLog(@"---null---");
		unitCat = @"单价";
		leastTimesOrHours = @1;
		titleLabel.text = @"该服务类型待调整";
	}
	
	NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%@", price];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
	NSDate *nowDate = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
	[calendar setTimeZone: timeZone];
	NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
	NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
	NSInteger sepNumb = theComponents.weekday;
	
	NSArray *offer_date = [service_info objectForKey:kAYServiceArgsOfferDate];
	for (int i = 0; i < 7; ++i) {
		
		NSInteger weekday_offer_date = (sepNumb - 1 + i + 1) % 7;
		NSPredicate *pred_contains = [NSPredicate predicateWithFormat:@"SELF.day=%d",weekday_offer_date];
		NSArray *result_contains = [offer_date filteredArrayUsingPredicate:pred_contains];
		if (result_contains.count != 0) {
			
			NSDictionary *tmp = [result_contains firstObject];
			NSNumber *note = [tmp objectForKey:@"day"];
			if (note) {
				NSDictionary *dic_time = [[tmp objectForKey:kAYServiceArgsOccurance] firstObject];
				NSNumber *stratNumb = [dic_time objectForKey:kAYServiceArgsStart];
				NSNumber *endNumb = [dic_time objectForKey:kAYServiceArgsEnd];
				NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
				[timesStr insertString:@":" atIndex:2];
				[timesStr insertString:@":" atIndex:8];
				
				NSTimeInterval nowSpan = nowDate.timeIntervalSince1970;
				NSTimeInterval ableTimeSpan = nowSpan + 86400 * (i + 1);
				NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:ableTimeSpan];
				NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
				NSString *dateStrPer = [formatter stringFromDate:ableDate];
				
				timeLine00.text = [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
				break;
			}
		}
		
	}
	
}

//- (void)setServiceData:(NSArray *)serviceData {
//	_serviceData = serviceData;
//}

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

#pragma mark -- actions


#pragma mark -- messages
- (id)setCellInfo:(NSArray*)dic_args {
//	_serviceData = dic_args;
	
	return nil;
}

#pragma mark -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return _serviceData.count;
	return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *indentfier = @"AYPServsCellView";
	AYPServsCellView *cell  = [tableView dequeueReusableCellWithIdentifier:indentfier];
	
	NSDictionary *tmp = [[NSDictionary alloc]init];
	cell.service_info = tmp;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	_didTouchUpInSubCell = ^(NSDictionary* service_info){
//		
//	};
	NSDictionary *tmp;
	_didTouchUpInSubCell(tmp);
}

@end
