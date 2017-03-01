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
	
	NSMutableDictionary *push_service_info;
	BOOL isChangeCalendar;
	
	NSMutableArray *timesArr;
	NSMutableArray *offer_date;
	NSString *service_id;
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
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
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
	
	UIView* picker = [self.views objectForKey:@"Picker"];
	[self.view bringSubviewToFront:picker];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
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
	
	
	if (offer_date.count == 0) {
		NSString *title = @"您还没有设置时间";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return ;
	}
	
	{
		id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
		id<AYCommand> cmd = [facade.commands objectForKey:@"PushServiceTMProtocol"];
		id args = [offer_date copy];
		[cmd performWithResult:&args];
		NSArray* result = (NSArray*)args;
		NSLog(@"result is %@", result);
		[push_service_info setValue:result forKey:@"tms"];
	}
	
	//    [push_service_info setValue:[offer_date copy] forKey:@"offer_date"];
	
	NSMutableArray* semaphores_upload_photos = [[NSMutableArray alloc]init];   // 一个图片是一个上传线程，需要一个semaphores等待上传完成
	NSMutableArray* post_image_result = [[NSMutableArray alloc]init];           // 记录每一个图片在线中上传的结果
	
	NSArray *napPhotos = [push_service_info objectForKey:@"images"];
	for (int index = 0; index < napPhotos.count; ++index) {
		
		dispatch_semaphore_t tmp = dispatch_semaphore_create(0);
		[semaphores_upload_photos addObject:tmp];
		[post_image_result addObject:[NSNumber numberWithBool:NO]];
	}
	
	dispatch_queue_t qp = dispatch_queue_create("post thread", nil);
	dispatch_async(qp, ^{
		
		NSMutableArray* arr_items = [[NSMutableArray alloc]init];
		
		for (int index = 0; index < napPhotos.count; ++index) {
			
			UIImage* iter = [napPhotos objectAtIndex:index];
			//            NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:iter];
			NSString* extent = [TmpFileStorageModel generateFileName];
			
			NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:1];
			[photo_dic setValue:extent forKey:@"image"];
			[photo_dic setValue:iter forKey:@"upload_image"];
			
			AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
			[up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
				NSLog(@"upload result are %d", success);
				[post_image_result replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:success]];
				dispatch_semaphore_signal([semaphores_upload_photos objectAtIndex:index]);
			}];
			[arr_items addObject:extent];
		}
		
		// 4. 等待图片进程全部处理完成：每一个阻塞线程等待一个图片的上传结果
		for (dispatch_semaphore_t iter in semaphores_upload_photos) {
			dispatch_semaphore_wait(iter, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
		}
		
		NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
		NSArray* image_result = [post_image_result filteredArrayUsingPredicate:p];
		
		if (image_result.count == 0) {
			NSDictionary* user_info = nil;
			CURRENUSER(user_info)
			
			[push_service_info setValue:[user_info objectForKey:@"user_id"]  forKey:@"owner_id"];
			[push_service_info setValue:arr_items forKey:@"images"];
			
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
						
						AYViewController *des = compare;
						NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
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
					
				} else {
					
					NSString *title = @"服务上传失败";
					AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
				}
			}];
		} else {
			NSString *title = @"图片上传失败,请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	});
}

- (void)popToRootVCWithTip:(NSString*)tip {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:tip forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POPTOROOT;
	[cmd performWithResult:&dic];
	
}

- (BOOL)isCurrentTimesLegal {
	//    NSMutableArray *allTimeNotes = [NSMutableArray array];
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
	
	[timesArr removeObjectAtIndex:args.integerValue];
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	[self ChangeOfSchedule];
	return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
	
//	creatOrUpdateNote = args.integerValue;
//	
//	id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServiceTimesPick"];
//	id<AYCommand> cmd_scroll_center = [cmd_recommend.commands objectForKey:@"scrollToCenterWithOffset:"];
//	NSNumber *offset = [NSNumber numberWithInt:12];
//	[cmd_scroll_center performWithResult:&offset];
//	
//	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)didSaveClick {
	
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	NSDictionary *args = nil;
	[cmd_index performWithResult:&args];
	//eg: 14:00-16:00
	
	if (!args) {
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	return nil;
}

- (id)didCancelClick {
	//do nothing else ,but be have to invoke this methed
	return nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
