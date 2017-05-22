//
//  AYServiceCalendarCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceCalendarCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYServiceCalendarCellView {
    UILabel *tipsTitleLabel;
	UILabel *timeLabel;
	UILabel *moreScheduleLabel;
	UILabel *moreLabel;
	
	NSDictionary *service_info;
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
        
        tipsTitleLabel = [Tools creatUILabelWithText:@"Section Head" andTextColor:[Tools blackColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self).offset(30);
			make.bottom.equalTo(self).offset(-85);
		}];
		
		timeLabel = [Tools creatUILabelWithText:@"最近可预定时间" andTextColor:[Tools blackColor] andFontSize:15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		timeLabel.numberOfLines = 0;
		[self addSubview:timeLabel];
		[timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
		}];
		
		moreLabel = [Tools creatUILabelWithText:@"没有可预定时间" andTextColor:[Tools themeColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
		[self addSubview:moreLabel];
		[moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(timeLabel);
			make.right.equalTo(self).offset(-15);
		}];
		moreLabel.userInteractionEnabled = YES;
		[moreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didMoreLabelTap)]];
		
//		UIImageView *access = [[UIImageView alloc]init];
//		[self addSubview:access];
//		access.image = IMGRESOURCE(@"plan_time_icon");
//		[access mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.right.equalTo(self).offset(-20);
//			make.centerY.equalTo(moreLabel);
//			make.size.mas_equalTo(CGSizeMake(15, 15));
//		}];
		
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
    id<AYViewBase> cell = VIEW(@"ServiceCalendarCell", @"ServiceCalendarCell");
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
- (void)didMoreLabelTap {
    kAYViewSendNotify(self, @"showServiceOfferDate", nil)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	service_info = args;
	
	NSDate *nowDate = [NSDate date];
	NSTimeInterval nowSpan = nowDate.timeIntervalSince1970;
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
	[calendar setTimeZone: timeZone];
	NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
	NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
	NSInteger sepNumb = theComponents.weekday - 1; 		//sep
	
	NSArray *tms = [service_info objectForKey:kAYServiceArgsTimes];
	
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	if (service_cat.intValue == ServiceTypeNursery) {
		tipsTitleLabel.text = @"看顾时间";
		
		for (int i = 0; i < 30; ++i) {
			long comp = (nowSpan + OneDayTimeInterval * i) * 1000;
			NSPredicate *pred_start = [NSPredicate predicateWithFormat:@"SELF.%@<%ld", @"startdate", comp];
			NSPredicate *pred_end = [NSPredicate predicateWithFormat:@"SELF.%@>%ld", @"startdate", comp];
			NSPredicate *pred_between = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_start, pred_end]];
			NSArray *result_contains = [tms filteredArrayUsingPredicate:pred_between];
			BOOL isComp = NO;
			for (NSDictionary *dic_tm in result_contains) {
				int startHours = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartHours]).intValue;
				if (startHours != 1) {
					NSNumber *stratNumb = [dic_tm objectForKey:kAYServiceArgsStartHours];
					NSNumber *endNumb = [dic_tm objectForKey:kAYServiceArgsEndHours];
					NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
					[timesStr insertString:@":" atIndex:2];
					[timesStr insertString:@":" atIndex:8];
	
//					NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
					NSTimeInterval nextSpan = comp * 0.001;
					NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:nextSpan];
					NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
					NSString *dateStrPer = [formatter stringFromDate:ableDate];
	
					timeLabel.text = [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
					isComp = YES;
					break;
				}
			}
			if (isComp) {
				break;
			}
		}
		
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		tipsTitleLabel.text = @"课程时间";
		
		for (int i = 0; i < 7; ++i) {
			NSInteger compWeekday  = (sepNumb + i) % 7;
			BOOL isBreak = NO;
			for (NSDictionary *dic_tm in tms) {
				//			NSNumber *pattern = [dic_tm objectForKey:kAYServiceArgsPattern];
				NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
				NSTimeInterval enddate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
				NSDateComponents *startComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:startdate]];
				NSInteger startWeekday = startComponents.weekday - 1;
				if (compWeekday == startWeekday && (nowSpan < enddate)) {
					NSNumber *stratNumb = [dic_tm objectForKey:kAYServiceArgsStartHours];
					NSNumber *endNumb = [dic_tm objectForKey:kAYServiceArgsEndHours];
					NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
					[timesStr insertString:@":" atIndex:2];
					[timesStr insertString:@":" atIndex:8];
					
					NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
					NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:startdate];
					NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
					NSString *dateStrPer = [formatter stringFromDate:ableDate];
					
					timeLabel.text = [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
					isBreak = YES;
					break;
				}
			}
			if (isBreak) {
				break;
			}
		}
		
		
	} else {
		tipsTitleLabel.text = @"服务类型待调整";
	}
	
	
//	NSArray *offer_date = [service_info objectForKey:kAYServiceArgsOfferDate];
//	for (int i = 0; i < 7; ++i) {
//		
//		NSInteger weekday_offer_date = (sepNumb + i) % 7;
//		NSPredicate *pred_contains = [NSPredicate predicateWithFormat:@"SELF.day=%d",weekday_offer_date];
//		NSArray *result_contains = [offer_date filteredArrayUsingPredicate:pred_contains];
//		if (result_contains.count != 0) {
//			
//			NSDictionary *tmp = [result_contains firstObject];
//			NSNumber *note = [tmp objectForKey:@"day"];
//			if (note) {
//				NSTimeInterval ableTimeSpan = nowSpan + 86400 * i;
//				for (NSDictionary *dic_tm in tms) {
//					NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
//					NSTimeInterval enddate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
//					if (ableTimeSpan >= startdate && (ableTimeSpan <= enddate || enddate == 0.001)) {
//						
//					}
//				}
//				
//				NSDictionary *dic_time = [[tmp objectForKey:kAYServiceArgsOccurance] firstObject];
//				NSNumber *stratNumb = [dic_time objectForKey:kAYServiceArgsStart];
//				NSNumber *endNumb = [dic_time objectForKey:kAYServiceArgsEnd];
//				NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
//				[timesStr insertString:@":" atIndex:2];
//				[timesStr insertString:@":" atIndex:8];
//				
//				//				NSTimeInterval nowSpan = nowDate.timeIntervalSince1970;
//				//				NSTimeInterval ableTimeSpan = nowSpan + 86400 * (i + 1);
//				NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:ableTimeSpan];
//				NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
//				NSString *dateStrPer = [formatter stringFromDate:ableDate];
//				
//				timeLabel.text = [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
//				break;
//			}
//		}
//		
//	}
	
//	for (NSDictionary *dic_tm in tms) {
//		NSNumber *pattern = [dic_tm objectForKey:kAYServiceArgsPattern];
//		double start = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
//		double end = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
//		int startHours = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartHours]).intValue;
//		
//		if (pattern.intValue == TMPatternTypeDaily) {
//			
//		}
//		else if (pattern.intValue == TMPatternTypeWeekly) {
//			NSDateComponents *startComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:start]];
//			int startWeekday = (int)startComponents.weekday - 1;
//			if (sepNumb == startWeekday && nowSpan < end ) {
//				NSNumber *stratNumb = [dic_tm objectForKey:kAYServiceArgsStartHours];
//				NSNumber *endNumb = [dic_tm objectForKey:kAYServiceArgsEndHours];
//				NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
//				[timesStr insertString:@":" atIndex:2];
//				[timesStr insertString:@":" atIndex:8];
//				
//				NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
//				NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:startdate];
//				NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
//				NSString *dateStrPer = [formatter stringFromDate:ableDate];
//				
//				timeLabel.text = [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
//				break;
//			}
//		}
//		else if (pattern.intValue == TMPatternTypeOnce) {
//			if ((start >= nowSpan) && (start < nowSpan + OneDayTimeInterval -1) ) {
//				if (startHours == 1) {
//					
//				} else {
//					
//				}
//				break;
//			}
//		}
//		else {
//			
//		}
//	} //forin status
	
//	NSTimeInterval timeHandle = MAXFLOAT;
//	NSDictionary *dic_handle;
//	for (NSDictionary *dic_t in tms) {
//		NSTimeInterval startdate = ((NSNumber*)[dic_t objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
//		NSTimeInterval enddate = ((NSNumber*)[dic_t objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
//		if (nowSpan >= startdate && (nowSpan <= enddate || enddate == 0.001)) {
//			if (startdate < timeHandle && startdate >= nowSpan) {	//more nearly from today
//				timeHandle = startdate;
//				dic_handle = dic_t;
//			}
//		}
//	}
//	if (dic_handle) {
//		NSNumber *stratNumb = [dic_handle objectForKey:kAYServiceArgsStartHours];
//		NSNumber *endNumb = [dic_handle objectForKey:kAYServiceArgsEndHours];
//		NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
//		[timesStr insertString:@":" atIndex:2];
//		[timesStr insertString:@":" atIndex:8];
//		
//		NSTimeInterval startdate = ((NSNumber*)[dic_handle objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
//		NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:startdate];
//		NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
//		NSString *dateStrPer = [formatter stringFromDate:ableDate];
//		
//		timeLabel.text = [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
//	}
	
	
	if ([timeLabel.text isEqualToString:@"最近可预定时间"]) {
		moreLabel.userInteractionEnabled = NO;
	} else
		moreLabel.text = @"查看可预定时间";
	
    return nil;
}

@end
