//
//  AYSetNapScheduleController.m
//  BabySharing
//
//  Created by Alfred Yang on 11/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapScheduleController.h"
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

#import "AYAddTimeSignView.h"

#define weekdaysViewHeight          95
static NSString* const kAYScheduleWeekDaysView = 	@"ScheduleWeekDays";
static NSString* const kAYSpecialTMAndStateView = 	@"SpecialTMAndState";

@implementation AYSetNapScheduleController {
	
	NSMutableDictionary *push_service_info;
	
    NSMutableDictionary *basicTMS;
    
    NSMutableArray *oneWeekDayTMs;
    NSInteger segCurrentIndex;
    NSInteger creatOrUpdateNote;
	
	AYAddTimeSignView *addBasicTMView;
	UIImageView *maskTableHeadView;
	
	BOOL isChange;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools garyBackgroundColor];
	
	basicTMS = [NSMutableDictionary dictionary];
    oneWeekDayTMs = [NSMutableArray array];  //value
//	[basicTMS setValue:oneWeekDayTMs forKey:@"basic"];
    segCurrentIndex = 0;
    
	id<AYDelegateBase> dlg_pick = [self.delegates objectForKey:@"ServiceTimesPick"];
	id obj = (id)dlg_pick;
	kAYViewsSendMessage(kAYPickerView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)dlg_pick;
	kAYViewsSendMessage(kAYPickerView, kAYTableRegisterDatasourceMessage, &obj)
	
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"ServiceTimesShow"];
    obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
    obj = (id)cmd_notify;
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
    NSString* cell_name = @"AYServiceTimesCellView";
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	
	NSArray *tmp = [oneWeekDayTMs copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
    
    //提升view层级
    UIView *weekdaysView = [self.views objectForKey:kAYScheduleWeekDaysView];
    [self.view bringSubviewToFront:weekdaysView];
	
	addBasicTMView = [[AYAddTimeSignView alloc] initWithTitle:@"服务时间"];
	[self.view addSubview:addBasicTMView];
	[addBasicTMView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(weekdaysView.mas_bottom).offset(8);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 46));
	}];
	[addBasicTMView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddBasicTMViewTap)]];
	
	UIView* view_table = [self.views objectForKey:kAYTableView];
	[view_table mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(addBasicTMView.mas_bottom);
		make.centerX.equalTo(self.view);
		make.width.equalTo(addBasicTMView);
		make.bottom.equalTo(self.view);
	}];
	[self.view bringSubviewToFront:view_table];
	maskTableHeadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_add_basic_tms"]];
	[self.view addSubview:maskTableHeadView];
	[maskTableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(view_table);
		make.centerX.equalTo(view_table);
		make.width.equalTo(addBasicTMView);
		make.height.mas_equalTo(17);
	}];
	view_table.hidden = maskTableHeadView.hidden = YES;
	
	UIView *view_table_div = [self.views objectForKey:kAYSpecialTMAndStateView];
	view_table_div.hidden = YES;
	
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
	NSNumber *offset = [NSNumber numberWithInt:0];
	[cmd_scroll_center performWithResult:&offset];
}

#pragma mark -- Layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
	
    NSString *title = @"服务时间设置";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:616.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)ScheduleWeekDaysLayout:(UIView*)view {
	
    view.frame = CGRectMake(view.frame.origin.x, 70, view.frame.size.width, view.frame.size.height);
    view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
//	((UITableView*)view).contentInset = UIEdgeInsetsMake(17, 0, 0, 0);
    view.frame = CGRectMake(0, 64 + weekdaysViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - weekdaysViewHeight - 64 );
    return nil;
}

- (id)SpecialTMAndStateLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, 370, SCREEN_WIDTH, SCREEN_HEIGHT - 370);
	return nil;
}

- (id)PickerLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
    return nil;
}

#pragma mark -- actions
- (void)didAddBasicTMViewTap {
	creatOrUpdateNote = -1;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
}

- (void)showRightBtn {
	if (!isChange) {
		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:316.f andBackgroundColor:nil];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isChange = YES;
	}
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
    [oneWeekDayTMs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *currentEnd = [obj objectForKey:@"end"];
        
        if (idx+1 < oneWeekDayTMs.count) {
            NSNumber *nextStart = [[oneWeekDayTMs objectAtIndex:idx+1] objectForKey:@"start"];
            
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
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
	
	if (basicTMS.count == 0) {
		NSString *title = @"您还没有设置时间";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
	[dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
//	[dic_pop setValue:[offer_date copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic_pop];
    return nil;
}

- (id)firstTimeTouchWeekday {
	addBasicTMView.state = AYAddTMSignStateEnable;
	return nil;
}

- (id)changeCurrentIndex:(NSNumber *)args {
    /*
     日程管理可以是集合，不超出从日到一，是不按顺序的，以keyValue:day为序号(0-6)进行各种操
     */
    
    WeekDayBtnState state = WeekDayBtnStateNormal;
	
	if (oneWeekDayTMs.count != 0) {
		//1.接收到切换seg的消息后，整理容器内当前的内容，规到当前index数据中，然后切换
		state = WeekDayBtnStateSeted;
		[basicTMS setValue:oneWeekDayTMs forKey:args.stringValue];
		
		//2.切换 刷新
		//此index下如果有数据 ？载到容器中 ：重建容器
		if ([basicTMS objectForKey:[NSString stringWithFormat:@"%ld", segCurrentIndex]]) {
			oneWeekDayTMs = [basicTMS objectForKey:[NSString stringWithFormat:@"%ld", segCurrentIndex]];
			
			NSArray *tmp = [oneWeekDayTMs copy];
			kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			
		} else
			oneWeekDayTMs = [NSMutableArray array];
	}
	
    //切换index
    segCurrentIndex = args.integerValue;
    
    //3.如果有数据：返回yes，用于btn作已设置标记
    return [NSNumber numberWithInt:state];
}

- (id)swipeDownExpandSchedule:(id)args {
	UIView* view_table = [self.views objectForKey:kAYTableView];
	view_table.hidden = addBasicTMView.hidden = maskTableHeadView.hidden = YES;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([args floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		UIView *view_table_div = [self.views objectForKey:kAYSpecialTMAndStateView];
		view_table_div.hidden = NO;
	});
	return nil;
}

- (id)swipeUpShrinkSchedule:(id)args {
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([args floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		UIView* view_table = [self.views objectForKey:kAYTableView];
		view_table.hidden = addBasicTMView.hidden = maskTableHeadView.hidden = NO;
		NSDictionary *date_info = [basicTMS copy];
		kAYViewsSendMessage(kAYScheduleWeekDaysView, @"setViewInfo:", &date_info)
	});
	UIView *view_table_div = [self.views objectForKey:kAYSpecialTMAndStateView];
	view_table_div.hidden = YES;
	return nil;
}

- (id)didSelectItemAtIndexPath:(id)args {
	id tmp = [args copy];
	kAYViewsSendMessage(kAYSpecialTMAndStateView, @"recodeTMHandle:", &tmp)
	return nil;
}

- (id)cellDeleteFromTable:(NSNumber*)args {
    
    [oneWeekDayTMs removeObjectAtIndex:args.integerValue];
    NSArray *tmp = [oneWeekDayTMs copy];
    kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
    kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    
    [self showRightBtn];
    return nil;
}

- (id)specialOrOpendayAddTM {
	creatOrUpdateNote = -2;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
    
    creatOrUpdateNote = args.integerValue;
    kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
    return nil;
}

#pragma mark -- pickerView notifies
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
	if (creatOrUpdateNote == -2) { //添加／修改 特殊、开放日
		kAYViewsSendMessage(kAYSpecialTMAndStateView, @"pushTMArgs:", &args)
		return nil;
	} else if (creatOrUpdateNote == -1) { //添加基础
        [oneWeekDayTMs addObject:args];
    } else { //修改基础
        argsHolder = [oneWeekDayTMs objectAtIndex:creatOrUpdateNote];
        [oneWeekDayTMs replaceObjectAtIndex:creatOrUpdateNote withObject:args];
    }
    
	[oneWeekDayTMs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[obj1 objectForKey:kAYServiceArgsStart] intValue] > [[obj2 objectForKey:kAYServiceArgsStart] intValue];
	}];
	
    if (![self isCurrentTimesLegal]) {
        if (!argsHolder) {
            [oneWeekDayTMs removeObject:args];
        } else {
            NSInteger holderIndex = [oneWeekDayTMs indexOfObject:args];
            [oneWeekDayTMs replaceObjectAtIndex:holderIndex withObject:argsHolder];
        }
        NSString *title = @"服务时间设置错误";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    [self showRightBtn];
	
	if (oneWeekDayTMs.count != 0 && addBasicTMView.state == AYAddTMSignStateEnable) {
		kAYViewsSendMessage(kAYScheduleWeekDaysView, @"havenAddTM", nil)
		
		addBasicTMView.state = AYAddTMSignStateHead;
		UIView *view_table = [self.views objectForKey:kAYTableView];
		view_table.hidden = NO;
	}
	
	NSArray *tmp = [oneWeekDayTMs copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    
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
