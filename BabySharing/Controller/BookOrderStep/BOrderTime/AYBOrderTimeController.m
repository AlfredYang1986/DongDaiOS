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
	
//	NSMutableArray *offer_date_mutable;
	NSDictionary *service_info;
	NSInteger timesCount;
	/******/
	UILabel *dateShowLabel;
	UIButton *certainBtn;
	
	NSInteger creatOrUpdateNote;
	NSMutableArray *timesArr;
	NSMutableDictionary *otmSet;
	
	NSIndexPath *indexPathHandle;
	NSNumber *timeSpanhandle;
	
	NSNumber *serviceType;
	
	NSArray *serviceTMs;
	NSMutableArray *tms_mutable;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
//		offer_date_mutable = [tmp objectForKey:kAYServiceArgsOfferDate];
		service_info = [tmp objectForKey:kAYServiceArgsServiceInfo];
		serviceType = [service_info objectForKey:kAYServiceArgsServiceCat];
		serviceTMs = [service_info objectForKey:kAYServiceArgsTimes];
		
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
	for (int i = 0; ; ++i) {
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
	[self preferredStatusBarStyle];
	
	timesArr = [NSMutableArray array];
	if (!otmSet) {
		otmSet = [[NSMutableDictionary alloc] init];
	}
	
	dateShowLabel = [Tools creatUILabelWithText:@"选择日期" andTextColor:[Tools whiteColor] andFontSize:13.f andBackgroundColor:[Tools themeColor] andTextAlignment:NSTextAlignmentCenter];
	[self.view addSubview:dateShowLabel];
	[dateShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.view).offset(kStatusAndNavBarH);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
	}];
	
	NSArray *weekdayTitle = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	for (int i = 0; i < weekdayTitle.count; ++i) {
		UILabel *itemLabel = [Tools creatUILabelWithText:[weekdayTitle objectAtIndex:i] andTextColor:[Tools blackColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self.view addSubview:itemLabel];
		[itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(dateShowLabel.mas_bottom).offset(20);
			make.centerX.equalTo(self.view.mas_left).offset(itemWidth*0.5 + itemWidth * i);
		}];
	}
	
	{
		id<AYViewBase> view_collection= [self.views objectForKey:@"CollectionVer"];
		id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"BOrderTime"];
		id<AYCommand> cmd_datasource = [view_collection.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_collection.commands objectForKey:@"registerDelegate:"];
		
		id obj = (id)cmd_notify;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_notify;
		[cmd_delegate performWithResult:&obj];
		
		id<AYCommand> cmd_cell = [view_collection.commands objectForKey:@"registerCellWithClass:"];
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderTimeItem"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_cell performWithResult:&class_name];
		[(UICollectionView*)view_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYDayCollectionHeader"];
		
//		[offer_date_mutable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//			
//			NSArray *occrance = [obj objectForKey:kAYServiceArgsOccurance];
//			[occrance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//				NSNumber *is_select = [obj objectForKey:@"select_pow"];
//				
//				int compA = is_select.intValue;
//				if (compA&1) {
//					timesCount ++;
//				}
//				if (compA&2) {
//					timesCount ++;
//				}
//				
//			}];
//		}];
//		id tmp = [offer_date_mutable copy];
//		kAYDelegatesSendMessage(@"BOrderTime", kAYDelegateChangeDataMessage, &tmp)
	}
	
	{
		id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
		id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
		
		id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServiceTimesPick"];
		
		id obj = (id)cmd_recommend;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_recommend;
		[cmd_delegate performWithResult:&obj];
	}
	{
		id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
		id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"BOTimeTable"];
		
		id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
		
		id obj = (id)cmd_notify;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_notify;
		[cmd_delegate performWithResult:&obj];
		
		id<AYCommand> cmd_class = [view_table.commands objectForKey:@"registerCellWithClass:"];
		NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"AddOTimeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_class performWithResult:&cell_name];
		cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMNurseCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_class performWithResult:&cell_name];
		cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMCourseCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_class performWithResult:&cell_name];
		
		id t = [serviceType copy];
		kAYDelegatesSendMessage(@"BOTimeTable", @"setDelegateType:", &t)
	}
	
	certainBtn = [Tools creatUIButtonWithTitle:@"申请预订" andTitleColor:[Tools whiteColor] andFontSize:318.f andBackgroundColor:[Tools disableBackgroundColor]];
	[self.view addSubview:certainBtn];
	[certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kBotButtonH));
	}];
	[certainBtn addTarget:self action:@selector(didCertainBtnnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIView* picker = [self.views objectForKey:@"Picker"];
	[self.view bringSubviewToFront:picker];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_scroll_center = [cmd_recommend.commands objectForKey:@"scrollToCenterWithOffset:"];
	NSNumber *offset = [NSNumber numberWithInt:6];
	[cmd_scroll_center performWithResult:&offset];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	view.backgroundColor = [Tools themeColor];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	view.backgroundColor = [Tools themeColor];
	
	UIImage *left = IMGRESOURCE(@"bar_left_white");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSString *title = @"可预约时间";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIColor *color = [Tools whiteColor];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleColorMessage, &color)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	return nil;
}

- (id)CollectionVerLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40, SCREEN_WIDTH - screenPadding * 2, SCREEN_HEIGHT - kStatusAndNavBarH - 40 - 40 - kBotButtonH);
	view.backgroundColor = [UIColor clearColor];
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.backgroundColor = [Tools garyBackgroundColor];
	view.frame = CGRectMake(0, SCREEN_HEIGHT - kBotButtonH, SCREEN_WIDTH, 0);
		
	if (serviceType.intValue == ServiceTypeCourse) {
		UIView *libgView = [[UIView alloc] init];
		libgView.backgroundColor = [Tools themeColor];
		[view addSubview:libgView];
		[libgView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(view.mas_left).offset(27);
			make.top.equalTo(view);
			make.width.mas_equalTo(1.5);
			make.height.mas_equalTo(736);
		}];
		[view sendSubviewToBack:libgView];
	}
	return nil;
}

- (id)PickerLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
	return nil;
}

#pragma mark -- actions
- (void)didCertainBtnnClick {
	
	NSDictionary* user = nil;
	CURRENPROFILE(user);
	NSString *user_id = [user objectForKey:@"user_id"];
	NSString *owner_id = [service_info objectForKey:@"owner_id"];
	if ([user_id isEqualToString:owner_id]) {
		NSString *title = @"您不能预订自己发布的服务";
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
//	NSDate *nowDate = [NSDate date];
//	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//	[calendar setTimeZone: timeZone];
//	NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
//	NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
//	NSInteger weekdaySep = theComponents.weekday - 1;
//	
//	[offer_date_mutable enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//		NSNumber *day = [obj objectForKey:kAYServiceArgsWeekday];
//		NSArray *occrance = [obj objectForKey:kAYServiceArgsOccurance];
//		[occrance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//			NSNumber *select_pow = [obj objectForKey:@"select_pow"];
//			int compA = select_pow.intValue;
//			if (compA&1) {
//				NSDictionary *tmpSpan = [self transTimeSpanWithDic:obj andDate:nowDate andDay:day andweektoday:weekdaySep andMultiple:0];
//				[orderTimeSpans addObject:tmpSpan];
//			}
//			if (compA&2) {
//				NSDictionary *tmpSpan = [self transTimeSpanWithDic:obj andDate:nowDate andDay:day andweektoday:weekdaySep andMultiple:1];
//				[orderTimeSpans addObject:tmpSpan];
//			}
//		}];
//	}];
	
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

- (void)setTipTitleWithInterval:(NSTimeInterval)interval {
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日"];
	NSString *title = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
	dateShowLabel.text = title;
}

- (void)checkCertainBtnStates {
	
	//1.判断当前handle中的数据是否可以相应下一步
	//2.判断之前handle中是否有数据 需要保存
	if (serviceType.intValue == ServiceTypeCourse) {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.is_selected=%@", @1];
		NSArray *result = [timesArr filteredArrayUsingPredicate:pred];
		if (result.count == 0) {
			certainBtn.backgroundColor = [Tools disableBackgroundColor];
			certainBtn.enabled = NO;
			[otmSet removeObjectForKey:timeSpanhandle.stringValue];
		} else {
			certainBtn.backgroundColor = [Tools themeColor];
			certainBtn.enabled = YES;
		}
	} else {
		if (timesArr.count == 0) {
			certainBtn.backgroundColor = [Tools disableBackgroundColor];
			certainBtn.enabled = NO;
			[otmSet removeObjectForKey:timeSpanhandle.stringValue];
		} else {
			certainBtn.backgroundColor = [Tools themeColor];
			certainBtn.enabled = YES;
		}
	}
	
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//	[dic setValue:offer_date_mutable forKey:kAYControllerChangeArgsKey];
	
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

- (id)didSelectItemAtIndexPath:(id)args {
	
	//整合数据
	if (timeSpanhandle && timesArr.count != 0) {
		[otmSet setValue:[timesArr mutableCopy] forKey:timeSpanhandle.stringValue];
	}
	
	timeSpanhandle = [args objectForKey:@"interval"];
	timesArr = [otmSet objectForKey:timeSpanhandle.stringValue];
	if (!timesArr) {
		timesArr = [NSMutableArray array];
		if (serviceType.intValue == ServiceTypeCourse) {
			for (NSDictionary *dic_tm in serviceTMs) {
				NSNumber *s = [dic_tm objectForKey:kAYServiceArgsStartDate];
				NSNumber *e = [dic_tm objectForKey:kAYServiceArgsEndDate];
				if (s.doubleValue*0.001 <= timeSpanhandle.doubleValue + OneDayTimeInterval - 1 && e.doubleValue > timeSpanhandle.doubleValue) {
					NSMutableDictionary *dic_op = [[NSMutableDictionary alloc] init];
					[dic_op setValue:[dic_tm objectForKey:kAYServiceArgsStartHours] forKey:kAYServiceArgsStartHours];
					[dic_op setValue:[dic_tm objectForKey:kAYServiceArgsEndHours] forKey:kAYServiceArgsEndHours];
					[dic_op setValue:[NSNumber numberWithBool:NO] forKey:@"is_selected"];
					[timesArr addObject:dic_op];
				}
			}
		}
		
	}
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"BOTimeTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self checkCertainBtnStates];
	
	
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	UICollectionView *view_collec = [self.views objectForKey:@"CollectionVer"];
	if (indexPathHandle) {
		id tmp = [otmSet copy];
		kAYDelegatesSendMessage(@"BOrderTime", kAYDelegateChangeDataMessage, &tmp)
		[view_collec reloadItemsAtIndexPaths:@[indexPathHandle]];
	}
	indexPathHandle = [args objectForKey:@"index_path"];
	
	NSTimeInterval t = timeSpanhandle.doubleValue;
	[self setTipTitleWithInterval:t];
	
	NSInteger numb = ((NSNumber*)[args objectForKey:@"numb_weeks"]).integerValue;
	numb = 2;
	CGFloat transHeight = itemWidth * (numb+1);
	
	[UIView animateWithDuration:0.25 animations:^{
		view_collec.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40, SCREEN_WIDTH - screenPadding * 2, transHeight);
		view_table.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40 + transHeight, SCREEN_WIDTH, SCREEN_HEIGHT - (kStatusAndNavBarH + 40 + 40 + transHeight + kBotButtonH));
	}];
	[view_collec scrollToItemAtIndexPath:indexPathHandle atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
	
	return nil;
}

- (id)scrollToShowMore {
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	UICollectionView *view_collec = [self.views objectForKey:@"CollectionVer"];
	[UIView animateWithDuration:0.25 animations:^{
		view_collec.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40, SCREEN_WIDTH - screenPadding * 2, SCREEN_HEIGHT - kStatusAndNavBarH - 40 - 40 - kBotButtonH);
		view_table.frame = CGRectMake(0, SCREEN_HEIGHT - kBotButtonH, SCREEN_WIDTH, 0);
	}];
	return nil;
}

- (id)scrollToCenter:(id)args {
	UICollectionView *view_collection = [self.views objectForKey:@"CollectionVer"];
	[view_collection scrollToItemAtIndexPath:args atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
	return nil;
}

#pragma mark -- pickerView notifies
- (id)cellDeleteFromTable:(NSNumber*)args {
	[timesArr removeObjectAtIndex:args.integerValue];
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"BOTimeTable", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self checkCertainBtnStates];
	return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
	creatOrUpdateNote = args.integerValue;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)didClickTheCellRow:(id)args {
	
	NSInteger sect = ((NSIndexPath*)args).section;
	NSMutableDictionary *dic_op = [timesArr objectAtIndex:sect];
	BOOL isSelected = ((NSNumber*)[dic_op objectForKey:@"is_selected"]).boolValue;
	[dic_op setValue:[NSNumber numberWithBool:!isSelected] forKey:@"is_selected"];
	
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	[view_table reloadRowsAtIndexPaths:@[args] withRowAnimation:UITableViewRowAnimationNone];
	return nil;
}

- (id)didSaveClick {
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	NSDictionary *args = nil;
	[cmd_index performWithResult:&args];
	//eg: (int)1400-1600
	
	if (!args) {
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSDictionary *argsHolder = nil;
	if (creatOrUpdateNote == timesArr.count) {
		//添加
		[timesArr addObject:args];
	} else {
		//修改
		argsHolder = [timesArr objectAtIndex:creatOrUpdateNote];
		[timesArr replaceObjectAtIndex:creatOrUpdateNote withObject:args];
	}
	
	[timesArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[obj1 objectForKey:kAYServiceArgsStart] intValue] > [[obj2 objectForKey:kAYServiceArgsStart] intValue];
	}];
	
	if (![self isCurrentTimesLegal]) {
		if (!argsHolder) {
			[timesArr removeObject:args];
		} else {
			NSInteger holderIndex = [timesArr indexOfObject:args];
			[timesArr replaceObjectAtIndex:holderIndex withObject:argsHolder];
		}
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"BOTimeTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self checkCertainBtnStates];
	return nil;
}

- (id)didCancelClick {
	//do nothing else ,but be have to invoke this methed
	return nil;
}

- (BOOL)isCurrentTimesLegal {
	__block BOOL isLegal = YES;
	[timesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSNumber *currentEnd = [obj objectForKey:@"end"];
		if (idx+1 < timesArr.count) {
			NSNumber *nextStart = [[timesArr objectAtIndex:idx+1] objectForKey:@"start"];
			if (currentEnd.intValue > nextStart.intValue) {
				isLegal = NO;
				*stop = YES;
			}
		}
	}];
	return isLegal;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
