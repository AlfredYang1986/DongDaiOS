//
//  AYNurseScheduleMainController.m
//  BabySharing
//
//  Created by Alfred Yang on 1/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseScheduleMainController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "TmpFileStorageModel.h"
#import "AYServiceTimesRule.h"

#define weekdaysViewHeight          95

@implementation AYNurseScheduleMainController {
	
	UIButton *PushBtn;
	
	NSMutableDictionary *push_service_info;
	BOOL isChangeCalendar;
	
	NSMutableArray *timeDurationArr;
	NSMutableArray *offer_date;
	NSString *service_id;
	
	//back args
	NSArray *restDayScheduleArr;
	
	NSNumber *exchangeIndexNote;
	BOOL isAddAlready;
}

- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
		
		if ([tmp objectForKey:@"service_id"]) {
			
			if ([tmp objectForKey:@"tms"]) {
				id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
				id<AYCommand> cmd = [facade.commands objectForKey:@"ParseServiceTMProtocol"];
				id args = [tmp objectForKey:@"tms"];
				[cmd performWithResult:&args];
				offer_date = [args mutableCopy];
			}
			// offer_date = [[tmp objectForKey:@"offer_date"] mutableCopy];
			service_id = [tmp objectForKey:@"service_id"];
		} else {
			push_service_info = [tmp mutableCopy];
		}
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		restDayScheduleArr = [dic objectForKey:kAYControllerChangeArgsKey];
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	if (!timeDurationArr) {
		timeDurationArr  = [NSMutableArray array];
	}
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"最后，设定您的看顾时间" andTextColor:[Tools themeColor] andFontSize:120.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	{
		
		id<AYDelegateBase> pick_delegate = [self.delegates objectForKey:@"ServiceTimesPick"];
		
		id obj = (id)pick_delegate;
		kAYViewsSendMessage(kAYPickerView, kAYPickerRegisterDelegateMessage, &obj)
		obj = (id)pick_delegate;
		kAYViewsSendMessage(kAYPickerView, kAYPickerRegisterDatasourceMessage, &obj)
	}
	
	{
		id<AYDelegateBase> table_delegate = [self.delegates objectForKey:@"NurseScheduleTable"];
		id obj = (id)table_delegate;
		kAYViewsSendMessage(kAYTableView, kAYPickerRegisterDelegateMessage, &obj)
		obj = (id)table_delegate;
		kAYViewsSendMessage(kAYTableView, kAYPickerRegisterDatasourceMessage, &obj)
		
		NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NurseScheduleCellTheme"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	}
	
	NSArray *date_info = [offer_date copy];
	kAYViewsSendMessage(@"ScheduleWeekDays", @"setViewInfo:", &date_info)
	
	PushBtn = [Tools creatUIButtonWithTitle:@"发布服务" andTitleColor:[Tools whiteColor] andFontSize:-16.f andBackgroundColor:[Tools themeColor]];
	[Tools setViewBorder:PushBtn withRadius:25.f andBorderWidth:0 andBorderColor:0 andBackground:[Tools themeColor]];
	[self.view addSubview:PushBtn];
	[PushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-25);
		make.right.equalTo(self.view).offset(-25);
		make.size.mas_equalTo(CGSizeMake(125, 50));
	}];

	PushBtn.alpha = 0.f;
	[PushBtn addTarget:self action:@selector(didPushServiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIView* picker = [self.views objectForKey:@"Picker"];
	[self.view bringSubviewToFront:picker];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_scroll_center = [cmd_recommend.commands objectForKey:@"scrollToCenterWithOffset:"];
	NSNumber *offset = [NSNumber numberWithInt:6];
	[cmd_scroll_center performWithResult:&offset];
}

#pragma mark -- Layout
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnVisibility:", &right_hidden);
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	CGFloat marginTop = 110.f;
	view.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
	return nil;
}

- (id)PickerLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.frame.size.height);
	return nil;
}

#pragma mark -- actions
- (void)didPushServiceBtnClick {
	
	{
		id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
		id<AYCommand> cmd = [facade.commands objectForKey:@"PushServiceTMNurse"];
		
		NSMutableDictionary *time_brige_args = [[NSMutableDictionary alloc] init];
		[time_brige_args setValue:timeDurationArr forKey:@"schedule_normal"];
		[time_brige_args setValue:restDayScheduleArr forKey:@"schedule_restday"];
		
		[cmd performWithResult:&time_brige_args];
		NSArray* result = (NSArray*)time_brige_args;
		NSLog(@"result is %@", result);
		[push_service_info setValue:result forKey:@"tms"];
	}
	
//    [push_service_info setValue:[offer_date copy] forKey:@"offer_date"];
	
	NSArray *napPhotos = [push_service_info objectForKey:@"images"];
	AYRemoteCallCommand* cmd_upload = MODULE(@"PostPhotos");
	[cmd_upload performWithResult:(NSDictionary*)napPhotos andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSDictionary* user_info = nil;
			CURRENUSER(user_info)
			
			[push_service_info setValue:[user_info objectForKey:@"user_id"]  forKey:@"owner_id"];
			[push_service_info setValue:(NSArray*)result forKey:@"images"];
			
			id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
			AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushServiceInfo"];
			[cmd_push performWithResult:[push_service_info copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
				if (success) {
					
					id<AYFacadeBase> facade = LOGINMODEL;
					id<AYCommand> cmd = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
					NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
					[dic setValue:[NSNumber numberWithBool:YES] forKey:@"is_service_provider"];
					[cmd performWithResult:&dic];
					
					//                    NSString *tip = @"服务发布成功,去管理服务?";
					//                    [self popToRootVCWithTip:tip];
					
					AYViewController* compare = DEFAULTCONTROLLER(@"TabBarService");
					BOOL isNap = [self.tabBarController isKindOfClass:[compare class]];
					if (isNap) {
						[super tabBarVCSelectIndex:2];
					} else {
						[self exchangeWindowsWithDest:compare];
					}
					
				} else {
					
					NSString *title = @"服务上传失败";
					AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
				}
			}];
		} else {
			NSString *title = @"图片上传失败,请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
	
}

- (void)exchangeWindowsWithDest:(id)dest {
	AYViewController *des = dest;
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc] init];
	[dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_exchange = [[NSMutableDictionary alloc]init];
	[dic_exchange setValue:[NSNumber numberWithInteger:2] forKey:@"index"];
	[dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeUnloginToAllModel] forKey:@"type"];
	[dic_show_module setValue:dic_exchange forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
	[cmd_show_module performWithResult:&dic_show_module];
	
}

- (void)popToRootVCWithTip:(NSString*)tip {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:tip forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POPTOROOT;
	[cmd performWithResult:&dic];
	
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
	[dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic_pop setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic_pop];
	return nil;
}

- (id)rightBtnSelected {
	
	//    NSArray *unavilableDateArr = nil;
	//    kAYViewsSendMessage(@"Schedule", @"queryUnavluableDate:", &unavilableDateArr)
	
	NSMutableDictionary *update_info = [[NSMutableDictionary alloc]init];
	[update_info setValue:service_id forKey:@"service_id"];
	
	{
		id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
		id<AYCommand> cmd = [facade.commands objectForKey:@"PushServiceTMProtocol"];
		id args = [offer_date copy];
		[cmd performWithResult:&args];
		NSArray* result = (NSArray*)args;
		NSLog(@"result is %@", result);
		[update_info setValue:result forKey:@"tms"];
	}
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateMyServiceTM"];
	[cmd_update performWithResult:[update_info copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSString *title = @"日程已修改";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			
			NSNumber* right_hidden = [NSNumber numberWithBool:YES];
			kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnVisibility:", &right_hidden);
			
			isChangeCalendar = YES;
		}
	}];
	
	return nil;
}

- (id)ChangeOfSchedule {
	
	return nil;
}

- (id)changeCurrentIndex:(NSNumber *)args {
	return nil;
}

#pragma mark -- pickerView notifies
- (id)cellDeleteFromTable:(NSNumber*)args {
	
	[timeDurationArr removeObjectAtIndex:args.integerValue];
	NSArray *tmp = [timeDurationArr copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	[self ChangeOfSchedule];
	return nil;
}

- (id)addTimeDuration {
	
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
	
	return nil;
}

- (id)didSaveClick {
	
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	NSDictionary *args = nil;
	[cmd_index performWithResult:&args];
	//eg: {(int)1400,1600}
	
	if (!args) {
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		exchangeIndexNote = nil;
		return nil;
	}
	
	if (exchangeIndexNote) {
		[timeDurationArr replaceObjectAtIndex:exchangeIndexNote.integerValue withObject:args];
	} else {
		[timeDurationArr addObject:args];
	}
	
	NSArray *tmpArr = [timeDurationArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		
		int first = ((NSNumber*)[obj1 objectForKey:@"start"]).intValue;
		int second = ((NSNumber*)[obj2 objectForKey:@"start"]).intValue;
		
		if (first < second) return  NSOrderedAscending;
		else if (first > second) return NSOrderedDescending;
		else return NSOrderedSame;
	}];
	[timeDurationArr removeAllObjects];
	[timeDurationArr addObjectsFromArray:tmpArr];
	
	if (![self isCurrentTimesLegal]) {
		[timeDurationArr removeObject:args];
		
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		exchangeIndexNote = nil;
		return nil;
	}
	
	
	id tmp = [timeDurationArr copy];
	kAYDelegatesSendMessage(@"NurseScheduleTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	if (!isAddAlready) {
		PushBtn.alpha = 1.f;
		isAddAlready = YES;
	}
	exchangeIndexNote = nil;
	return nil;
}

- (id)exchangeTimeDuration:(id)args {
	exchangeIndexNote = args;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)delTimeDuration:(id)args {
	NSNumber *row = args;
	[timeDurationArr removeObjectAtIndex:row.integerValue];
	
	id tmp = [timeDurationArr copy];
	kAYDelegatesSendMessage(@"NurseScheduleTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	return nil;
}

- (id)didCancelClick {
	//do nothing else ,but be have to invoke this methed
	return nil;
}


- (id)manageRestDaySchedule {
	
	if(timeDurationArr.count == 0) {
		NSString *title = @"需要先设置工作日日程";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"NurseCalendar");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:restDayScheduleArr forKey:@"schedule_restday"];
	[tmp setValue:timeDurationArr forKey:@"schedule_workday"];
	[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)isCurrentTimesLegal {
	//    NSMutableArray *allTimeNotes = [NSMutableArray array];
	__block BOOL isLegal = YES;
	[timeDurationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		NSNumber *currentEnd = [obj objectForKey:@"end"];
		
		if (idx+1 < timeDurationArr.count) {
			NSNumber *nextStart = [[timeDurationArr objectAtIndex:idx+1] objectForKey:@"start"];
			
			if (currentEnd.intValue > nextStart.intValue) {
				isLegal = NO;
				*stop = YES;
			}
		}
	}];
	
	return isLegal;
}

@end
