//
//  AYBOrderTimeController.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderTimeController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYModelFacade.h"
#import "AYBOrderTimeDefines.h"
#import "AYServTimesBtn.h"

@implementation AYBOrderTimeController {
	UIScrollView *scheduleView;
	UIView *markSepView;
//	NSInteger weekdaySep;
	
	NSMutableArray *offer_date_mutable;
	NSDictionary *service_info;
	
	NSInteger timesCount;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
		offer_date_mutable = [tmp objectForKey:kAYServiceArgsOfferDate];
		service_info = [tmp objectForKey:kAYServiceArgsServiceInfo];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (NSDictionary*)transTimeSpanWithDic:(NSDictionary*)dic_time andDate:(NSDate*)now andDay:(NSNumber*)day andweektoday:(NSInteger)weekday andMultiple:(NSInteger)multiple {
	
	NSTimeInterval nowSpan = now.timeIntervalSince1970;
	NSNumber *time_start = [dic_time objectForKey:kAYServiceArgsStart];
	NSNumber *time_end = [dic_time objectForKey:kAYServiceArgsEnd];
	
	// (weekday + x ) % 7 = "day"    x=?
	int lag;
	for (int i = 0; i < 8; ++i) {
		if ((weekday + i ) % 7 == day.intValue) {
			lag = i;
			break ;
		}
	}
	
	NSTimeInterval transDaySpan = nowSpan + (lag + multiple * 7) * 86400;
	NSDate *transDayDate = [NSDate dateWithTimeIntervalSince1970:transDaySpan];
	NSDateFormatter *form = [Tools creatDateFormatterWithString:@"yyyy-MM-dd"];
	NSString *transDayStr = [form stringFromDate:transDayDate];
	
	NSMutableString *tmp = [NSMutableString stringWithFormat:@"%@", time_start];
	[tmp insertString:@":" atIndex:tmp.length - 2];
	NSString *startTimeStr = [NSString stringWithFormat:@"%@ %@", transDayStr, tmp];
	
	tmp = [NSMutableString stringWithFormat:@"%@", time_end];
	[tmp insertString:@":" atIndex:tmp.length - 2];
	NSString *endTimeStr = [NSString stringWithFormat:@"%@ %@", transDayStr, tmp];
	
	NSDateFormatter *formTime = [Tools creatDateFormatterWithString:@"yyyy-MM-dd H:mm"];
	
	NSDate *startTimeDate = [formTime dateFromString:startTimeStr];
	NSDate *endTimeDate = [formTime dateFromString:endTimeStr];
	
	NSTimeInterval startTimeSpan = startTimeDate.timeIntervalSince1970;
	NSTimeInterval endTimeSpan = endTimeDate.timeIntervalSince1970;
	
	NSMutableDictionary *dic_timespan = [[NSMutableDictionary alloc]init];
	[dic_timespan setValue:[NSNumber numberWithDouble:startTimeSpan * 1000] forKey:kAYServiceArgsStart];
	[dic_timespan setValue:[NSNumber numberWithDouble:endTimeSpan * 1000] forKey:kAYServiceArgsEnd];
	
	return dic_timespan;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	
//	NSDate *nowDate = [NSDate date];
//	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//	[calendar setTimeZone: timeZone];
//	NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
//	NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
//	weekdaySep = theComponents.weekday - 1;
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Collection"];
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"BOrderTime"];
	id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
	
	id obj = (id)cmd_notify;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_notify;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderTimeItem"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name];
	
	[offer_date_mutable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//		NSNumber *index = [obj objectForKey:@"index"];
		NSArray *occrance = [obj objectForKey:kAYServiceArgsOccurance];
		[occrance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSNumber *is_select = [obj objectForKey:@"select_pow"];
			
			int compA = is_select.intValue;
			if (compA&1) {
				timesCount ++;
			}
			if (compA&2) {
				timesCount ++;
			}
			
		}];
	}];
	
	id tmp = [offer_date_mutable copy];
	kAYDelegatesSendMessage(@"BOrderTime", @"changeQueryData:", &tmp)
	
	scheduleView = [[UIScrollView alloc]init];
	scheduleView.showsVerticalScrollIndicator = NO;
	scheduleView.showsHorizontalScrollIndicator = NO;
	scheduleView.delegate = self;
//	scheduleView.bounces = NO;
	[self.view addSubview:scheduleView];
	[scheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(64);
		make.left.equalTo(self.view).offset(15);
		make.right.equalTo(self.view).offset(0);
		make.bottom.equalTo(self.view).offset(-49);
//		make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 15, -49, 0));
	}];
	
	markSepView = [[UIView alloc]init];
	[self.view addSubview:markSepView];
	[markSepView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.top.equalTo(self.view).offset(104);
		make.size.mas_equalTo(CGSizeMake(15, itemMargin * 8 + 40 +20));
	}];
	
	for (int i = 0; i < 9; ++i) {
		UILabel *itemLabel = [Tools creatUILabelWithText:[NSString stringWithFormat:@"%d", 6+2*i] andTextColor:[Tools garyColor] andFontSize:10.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[markSepView addSubview:itemLabel];
		[itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(markSepView.mas_left).offset(15*0.5);
			make.top.equalTo(markSepView.mas_top).offset(itemMargin * i);
		}];
		
		[Tools creatCALayerWithFrame:CGRectMake(0, AdjustFiltVertical + itemMargin * i + 40, SCREEN_WIDTH - 15, 0.5) andColor:[Tools garyLineColor] inSuperView:scheduleView];
		
	}
	
	scheduleView.contentSize = CGSizeMake(SCREEN_WIDTH - 15, itemMargin * 8 + 40 +20); //+20 margin
	UIView *collectionView = (UIView*)view_notify;
	[scheduleView addSubview:collectionView];
	
	[self setNavTitleWithIndex:0];
	
	UIButton *certainBtn = [Tools creatUIButtonWithTitle:@"申请预订" andTitleColor:[Tools whiteColor] andFontSize:318.f andBackgroundColor:[Tools themeColor]];
	[self.view addSubview:certainBtn];
	[certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
	}];
	[certainBtn addTarget:self action:@selector(didCertainBtnnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)setNavTitleWithIndex:(int)index {
	
	NSDate *now = [NSDate date];
	NSDateFormatter *form = [Tools creatDateFormatterWithString:@"MM月dd日"];
	NSString *nowStr = [form stringFromDate:now];
	
	NSString *title;
	if (index == 0) {
		NSTimeInterval sevenAfter = now.timeIntervalSince1970 + 86400 * 6;
		NSDate *afterDate = [NSDate dateWithTimeIntervalSince1970:sevenAfter];
		NSString *afterStr = [form stringFromDate:afterDate];
		
		title  = [NSString stringWithFormat:@"%@-%@",nowStr, afterStr];
		
	} else if (index == 1) {
		NSTimeInterval eightAfter = now.timeIntervalSince1970 + 86400 * 7;
		NSDate *eightAfterDate = [NSDate dateWithTimeIntervalSince1970:eightAfter];
		NSString *eightAfterStr = [form stringFromDate:eightAfterDate];
		
		NSTimeInterval fourTeenAfter = now.timeIntervalSince1970 + 86400 * 13;
		NSDate *fourTeenDate = [NSDate dateWithTimeIntervalSince1970:fourTeenAfter];
		NSString *fourTeenStr = [form stringFromDate:fourTeenDate];
		
		title  = [NSString stringWithFormat:@"%@-%@",eightAfterStr, fourTeenStr];
	}
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage *left = IMGRESOURCE(@"content_close");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	return nil;
}

- (id)CollectionLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15, itemMargin * 8 + 20);
	view.backgroundColor = [UIColor clearColor];
	((UICollectionView*)view).pagingEnabled = YES;
	((UICollectionView*)view).bounces = NO;
	return nil;
}

#pragma mark -- actions
- (void)didCertainBtnnClick {
	
	NSDictionary* user = nil;
	CURRENPROFILE(user);
	NSString *user_id = [user objectForKey:@"user_id"];
	NSString *owner_id = [service_info objectForKey:@"owner_id"];
	if ([user_id isEqualToString:owner_id]) {
		
		NSString *title = @"该服务是您自己发布";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return;
	}
	
	NSInteger leastTimes = ((NSNumber*)[service_info objectForKey:kAYServiceArgsLeastTimes]).integerValue;
	if (timesCount < leastTimes) {
		NSString *title = [NSString stringWithFormat:@"该服务最少预定%d次",(int)leastTimes];
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return;
	}
	
	NSMutableArray *orderTimeSpans = [NSMutableArray array];
	NSDate *nowDate = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
	[calendar setTimeZone: timeZone];
	NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
	NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
	NSInteger weekdaySep = theComponents.weekday - 1;
	
	[offer_date_mutable enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSNumber *day = [obj objectForKey:kAYServiceArgsWeekday];
		NSArray *occrance = [obj objectForKey:kAYServiceArgsOccurance];
		[occrance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSNumber *select_pow = [obj objectForKey:@"select_pow"];
			int compA = select_pow.intValue;
			if (compA&1) {
				NSDictionary *tmpSpan = [self transTimeSpanWithDic:obj andDate:nowDate andDay:day andweektoday:weekdaySep andMultiple:0];
				[orderTimeSpans addObject:tmpSpan];
			}
			if (compA&2) {
				NSDictionary *tmpSpan = [self transTimeSpanWithDic:obj andDate:nowDate andDay:day andweektoday:weekdaySep andMultiple:1];
				[orderTimeSpans addObject:tmpSpan];
			}
		}];
	}];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:orderTimeSpans forKey:@"order_times"];
	[tmp setValue:[service_info copy] forKey:kAYServiceArgsServiceInfo];
	
	/**
	 * 2. check profile has_phone, if not, go confirmNoConsumer
	 */
	if (((NSNumber*)[user objectForKey:@"has_phone"]).boolValue) {
		
		id<AYCommand> des = DEFAULTCONTROLLER(@"BOrderMain");
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd_show_module = PUSH;
		[cmd_show_module performWithResult:&dic];
		
	} else {
		id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmPhoneNoConsumer");
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd_show_module = PUSH;
		[cmd_show_module performWithResult:&dic];
	}
	
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:offer_date_mutable forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	id<AYCommand> cmd = REVERSMODULE;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)scrollOffsetX:(NSNumber*)args {
	
	int index= args.floatValue / (SCREEN_WIDTH - 15);
	[self setNavTitleWithIndex:index];
	return nil;
}

- (id)transTimesInfo:(id)args {
	
	UIButton *btn = [args objectForKey:@"btn"];
	
	NSNumber *multiple = [args objectForKey:@"multiple"];
	NSNumber *weekday = [args objectForKey:@"weekday"];
	NSNumber *time_start = [args objectForKey:kAYServiceArgsStart];
//	NSNumber *time_end = [args objectForKey:kAYServiceArgsEnd];
	
	NSPredicate *pred_contains = [NSPredicate predicateWithFormat:@"SELF.day=%d",weekday.intValue];
	NSArray *resultArr = [offer_date_mutable filteredArrayUsingPredicate:pred_contains];
	NSDictionary *dic_day = [resultArr firstObject];
	
	NSArray *occurance = [dic_day objectForKey:kAYServiceArgsOccurance];
	__block NSDictionary *dic_times;
	[occurance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([[obj objectForKey:kAYServiceArgsStart] isEqualToNumber:time_start]) {
			dic_times = obj;
		}
	}];
	NSNumber *seleted = [dic_times objectForKey:@"select_pow"];
	int note = seleted.intValue;
	int powArgs = pow(2, multiple.intValue);
	
	if (btn.selected) {
		timesCount ++;
		if (!(note&powArgs)) {
			note = note + powArgs;
		}
	} else {
		timesCount --;
		if (note&powArgs) {
			note = note - powArgs;
		}
	}
	[dic_times setValue:[NSNumber numberWithInt:note] forKey:@"select_pow"];
//	[dic_day setValue:[NSNumber numberWithInt:note] forKey:@"index"];
	
	NSLog(@"%@", offer_date_mutable);
	NSLog(@"%ld", timesCount);
	NSLog(@"----------");
	
	return nil;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGFloat offset = scrollView.contentOffset.y;
	[markSepView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.top.equalTo(self.view).offset(104 - offset);
		make.size.mas_equalTo(CGSizeMake(15, itemMargin * 8 + 40 +20));
	}];
}

@end
