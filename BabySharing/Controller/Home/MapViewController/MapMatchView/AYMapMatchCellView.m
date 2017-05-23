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
	
	priceLabel = [Tools creatUILabelWithText:@"¥Price/Unit" andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:priceLabel];
	[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(5);
	}];
	
	timeLine00 = [Tools creatUILabelWithText:@"最近可预订时间" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
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
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	
	NSString* photo_name = [[service_info objectForKey:@"images"] objectAtIndex:0];
	[coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, photo_name]]
					  placeholderImage:IMGRESOURCE(@"default_image")];
	
	NSString *screen_photo = [service_info objectForKey:kAYServiceArgsScreenPhoto];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, screen_photo]]
					 placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	NSString *unitCat;
	NSNumber *leastTimesOrHours;
	if (service_cat.intValue == ServiceTypeNursery) {
		unitCat = @"小时";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastHours];
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		unitCat = @"次";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastTimes];
	} else {
		unitCat = @"单价";
		leastTimesOrHours = @1;
	}
	
	NSString *userName = [service_info objectForKey:kAYServiceArgsScreenName];
	NSString *compName = [Tools serviceCompleteNameFromSKUWith:service_info];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@", userName, compName];
	
	NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%@", price];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
	
	NSDate *nowDate = [NSDate date];
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:nil];
	NSString *todayDateStr = [formatter stringFromDate:nowDate];
	NSTimeInterval todayInterval = [formatter dateFromString:todayDateStr].timeIntervalSince1970;
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
	[calendar setTimeZone: timeZone];
	
	NSArray *tms = [service_info objectForKey:kAYServiceArgsTimes];
	NSString *ableDateStr;
	for (int i = 0; i < 30; ++i) {		//查找30天之内，30天之后还没有的 应该也不能算最近了
		NSTimeInterval compInterval = todayInterval + OneDayTimeInterval * i;
		BOOL isBreak = NO;
		for (NSDictionary *dic_tm in tms) {
			NSNumber *pattern = [dic_tm objectForKey:kAYServiceArgsPattern];
			NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
			NSTimeInterval enddate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
			int startHours = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartHours]).intValue;		//startHours==1 用于标记当天时间不可用
			
			if (pattern.intValue == TMPatternTypeDaily) {
				if (compInterval < enddate+OneDayTimeInterval-1 && startHours != 1) { 		//enddate+OneDayTimeInterval-1 :结束那天的最后一秒时间戳
					ableDateStr = [self ableDateStringWithTM:dic_tm andTimeInterval:compInterval];
					isBreak = YES;
					break;
				}
			}
			else if (pattern.intValue == TMPatternTypeWeekly) {
				NSDateComponents *cellComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:compInterval]];
				int compWeekday = (int)cellComponents.weekday - 1;
				NSDateComponents *startComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:startdate]];
				int startWeekday = (int)startComponents.weekday - 1;
				if (compWeekday == startWeekday && (compInterval < enddate+OneDayTimeInterval-1 || enddate == -0.001) && startHours != 1) {
					ableDateStr = [self ableDateStringWithTM:dic_tm andTimeInterval:compInterval];
					isBreak = YES;
					break;
				}
			}
			else if (pattern.intValue == TMPatternTypeOnce) {
				if ((startdate <= compInterval) && (startdate + OneDayTimeInterval -1 > compInterval) && startHours != 1) {
					ableDateStr = [self ableDateStringWithTM:dic_tm andTimeInterval:compInterval];
					isBreak = YES;
					break;
				}
			}
			else {
				
			}
		} //forin status
		
		if (isBreak) {
			if (ableDateStr) {
				timeLine00.text = ableDateStr;
			}
			break;
		}
	}
	
}

- (NSString *)ableDateStringWithTM:(NSDictionary*)dic_tm andTimeInterval:(NSTimeInterval)interval {
//	NSNumber *stratNumb = [dic_tm objectForKey:kAYServiceArgsStartHours];
//	NSNumber *endNumb = [dic_tm objectForKey:kAYServiceArgsEndHours];
//	NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
//	[timesStr insertString:@":" atIndex:2];
//	[timesStr insertString:@":" atIndex:8];
	
	NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:interval];
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
	NSString *dateStrPer = [formatter stringFromDate:ableDate];
	return dateStrPer;
//	return [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
	
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
