//
//  AYNapScheduleMainController.m
//  BabySharing
//
//  Created by Alfred Yang on 7/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNapScheduleMainController.h"
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

@implementation AYNapScheduleMainController {
	
	UIButton *PushBtn;
	UIButton *plusBtn;
	NSInteger currentNumbCount;
	
	NSMutableDictionary *push_service_info;
	NSMutableArray *offer_date;
	NSString *service_id;
	
	BOOL isChange;
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
			
			service_id = [tmp objectForKey:@"service_id"];
		} else {
			push_service_info = [tmp mutableCopy];
		}
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		offer_date = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
		[self showPushServiceBtn];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"最后，设定您的课程时间" andTextColor:[Tools themeColor] andFontSize:120.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	UILabel *scheduleTitleLabel = [Tools creatUILabelWithText:@"1.您每周的课程时间" andTextColor:[Tools themeColor] andFontSize:-18.f andBackgroundColor:nil andTextAlignment:0];
	[self.view addSubview:scheduleTitleLabel];
	[scheduleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(30);
		make.right.equalTo(self.view).offset(-20);
		make.height.mas_equalTo(45);
	}];
	scheduleTitleLabel.userInteractionEnabled = YES;
	[scheduleTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didScheduleLabelTap)]];
	
	UIImageView *accessView = [[UIImageView alloc]init];
	[self.view addSubview:accessView];
	accessView.image = IMGRESOURCE(@"plan_time_icon");
	[accessView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(scheduleTitleLabel);
		make.centerY.equalTo(scheduleTitleLabel);
		make.size.mas_equalTo(CGSizeMake(23, 23));
	}];
//	accessView.userInteractionEnabled  = NO;
	
	UILabel *weekNumbTitleLabel = [Tools creatUILabelWithText:@"2.这个课程您打算循环几周？" andTextColor:[Tools themeColor] andFontSize:-18.f andBackgroundColor:nil andTextAlignment:0];
	[self.view addSubview:weekNumbTitleLabel];
	[weekNumbTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(scheduleTitleLabel);
		make.top.equalTo(scheduleTitleLabel.mas_bottom).offset(30);
		make.right.equalTo(self.view).offset(-20);
		make.height.mas_equalTo(45);
	}];
	
	CGFloat btnWH = 50.f;
	UIButton *minusBtn = [[UIButton alloc]init];
	CALayer *minusLayer = [CALayer layer];
	minusLayer.frame = CGRectMake(0, 0, btnWH * 0.4, 3);
	minusLayer.position = CGPointMake(btnWH * 0.5, btnWH * 0.5);
	minusLayer.backgroundColor = [Tools themeColor].CGColor;
	[minusBtn.layer addSublayer:minusLayer];
	[self.view addSubview:minusBtn];
	[minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(weekNumbTitleLabel.mas_bottom).offset(30);
		make.left.equalTo(weekNumbTitleLabel).offset(10);
		make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
	}];
	[minusBtn addTarget:self action:@selector(didMinusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	plusBtn = [[UIButton alloc]init];
	if (!currentNumbCount || currentNumbCount == 0) {
		currentNumbCount = 2;
	}
	[plusBtn setTitle:[NSString stringWithFormat:@"%d",(int)currentNumbCount] forState:UIControlStateNormal];
	plusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
	[plusBtn setTitleColor:[Tools whiteColor] forState:UIControlStateNormal];
	plusBtn.backgroundColor = [Tools themeColor];
	plusBtn.layer.cornerRadius = btnWH * 0.5;
	[self.view addSubview:plusBtn];
	[plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(minusBtn);
		make.left.equalTo(minusBtn.mas_right).offset(10);
		make.size.equalTo(minusBtn);
	}];
	[plusBtn addTarget:self action:@selector(didPlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *weekSign = [Tools creatUILabelWithText:@"周" andTextColor:[Tools themeColor] andFontSize:120.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:weekSign];
	[weekSign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(plusBtn);
		make.left.equalTo(plusBtn.mas_right).offset(20);
	}];
	
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
- (void)didScheduleLabelTap {
	id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapSchedule");
	
	NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:[offer_date copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
}

- (void)didPlusBtnClick:(UIButton*)btn {
	currentNumbCount ++;
	[plusBtn setTitle:[NSString stringWithFormat:@"%ld", currentNumbCount] forState:UIControlStateNormal];
	[self showPushServiceBtn];
}

- (void)didMinusBtnClick:(UIButton*)btn {
	if (currentNumbCount == 2) {
		return;
	}
	currentNumbCount --;
	[plusBtn setTitle:[NSString stringWithFormat:@"%ld", currentNumbCount] forState:UIControlStateNormal];
	[self showPushServiceBtn];
}

- (void)didPushServiceBtnClick {
	
	if (offer_date.count == 0) {
		NSString *title = @"请设置课程时间安排";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return;
	}
	
	{
		id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
		id<AYCommand> cmd = [facade.commands objectForKey:@"PushServiceTMProtocol"];
		
		NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
		[args setValue:[offer_date copy] forKey:@"offer_date"];
		[args setValue:[NSNumber numberWithDouble:currentNumbCount * 7 * OneDayTimeInterval] forKey:@"timeinterval_start_end"];
		
		[cmd performWithResult:&args];
		NSArray* result = (NSArray*)args;
		NSLog(@"result is %@", result);
		[push_service_info setValue:result forKey:@"tms"];
	}
	
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

- (void)showPushServiceBtn {
	if (!isChange) {
		PushBtn.alpha = 1.f;
		isChange = YES;
	}
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
		
		NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
		[args setValue:[offer_date copy] forKey:@"offer_date"];
		[args setValue:[NSNumber numberWithDouble:currentNumbCount * 7 * OneDayTimeInterval] forKey:@"timeinterval_start_end"];
		
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
			
		}
	}];
	
	return nil;
}

- (id)manageRestDaySchedule {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"NurseCalendar");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
