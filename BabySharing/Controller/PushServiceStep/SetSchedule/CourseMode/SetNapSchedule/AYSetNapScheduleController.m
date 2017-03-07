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

#define weekdaysViewHeight          95

@implementation AYSetNapScheduleController {
    
    NSMutableArray *offer_date;
    
    NSMutableArray *timesArr;
    NSInteger segCurrentIndex;
    NSInteger creatOrUpdateNote;
	
	BOOL isChange;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        offer_date = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!offer_date) {
        offer_date = [NSMutableArray array];
    }
    timesArr = [NSMutableArray array];
    segCurrentIndex = 0;
    
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
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"ServiceTimesShow"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_class = [view_notify.commands objectForKey:@"registerCellWithClass:"];
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceTimesCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&cell_name];
    cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceAddTimesCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&cell_name];
    
    NSArray *date_info = [offer_date copy];
    kAYViewsSendMessage(@"ScheduleWeekDays", @"setViewInfo:", &date_info)
	
	for (NSDictionary *iter in offer_date) {
		if (((NSNumber*)[iter objectForKey:@"day"]).integerValue == segCurrentIndex) {
			[timesArr addObjectsFromArray:(NSArray*)[iter objectForKey:@"occurance"]];
		}
	}
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
    
    //提升view层级
    UIView *weekdaysView = [self.views objectForKey:@"ScheduleWeekDays"];
    [self.view bringSubviewToFront:weekdaysView];
    
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
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
	
//    NSString *title = @"时间管理";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnVisibility:", &right_hidden);
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)ScheduleWeekDaysLayout:(UIView*)view {
    
    CGFloat margin = 0;
    view.frame = CGRectMake(margin, 64, SCREEN_WIDTH - margin * 2, weekdaysViewHeight);
    view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
	view.backgroundColor = [Tools garyBackgroundColor];
    view.frame = CGRectMake(0, 64 + weekdaysViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - weekdaysViewHeight - 64 );
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.frame.size.height);
    return nil;
}

#pragma mark -- actions
- (void)showRightBtn {
	if (!isChange) {
		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:-16.f andBackgroundColor:nil];
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
    [timesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *currentEnd = [obj objectForKey:@"end"];
        
        if (idx+1 < timesArr.count) {
            NSNumber *nextStart = [[timesArr objectAtIndex:idx+1] objectForKey:@"start"];
            
            if (currentEnd.intValue > nextStart.intValue) {
                isLegal = NO;
                *stop = YES;
            }
        }
        
        //        NSEnumerator* enumerator = ((NSDictionary*)obj).keyEnumerator;
        //        id iter = nil;
        //        while ((iter = [enumerator nextObject]) != nil) {
        //            if ([iter isEqualToString:@"start"]) {
        //                NSNumber *startNumb = [obj objectForKey:iter];
        //
        //            }
        //            else if ([iter isEqualToString:@"end"]) {
        //                NSNumber *endNumb = [obj objectForKey:iter];
        //            } else {
        //                // do nothing
        //            }
        //        }
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
	NSMutableDictionary *date_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
	[date_dic setValue:[timesArr copy] forKey:@"occurance"];
	[date_dic setValue:[NSNumber numberWithInteger:segCurrentIndex] forKey:@"day"];
	
	NSPredicate *pred_conts = [NSPredicate predicateWithFormat:@"SELF.day=%d",segCurrentIndex];
	NSArray *result = [offer_date filteredArrayUsingPredicate:pred_conts];
	
	if (result.count != 0 && timesArr.count != 0) {     //update
		
		NSInteger changeIndex = [offer_date indexOfObject:result.lastObject];
		[offer_date replaceObjectAtIndex:changeIndex withObject:date_dic];
	}
	else if (result.count != 0 && timesArr.count == 0) {        //del
		
		[offer_date removeObject:result.lastObject];
	}
	else if (result.count == 0 && timesArr.count != 0) {        //creat
		
		[offer_date addObject:date_dic];
	}
	else if (result.count == 0 && timesArr.count == 0) {        //...
		
	}
	
	if (offer_date.count == 0) {
		NSString *title = @"您还没有设置时间";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
	[dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic_pop setValue:[offer_date copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic_pop];
	
    return nil;
}

- (id)changeCurrentIndex:(NSNumber *)args {
    /*
     日程管理可以是集合，不超出从日到一，是不按顺序的，以keyValue:day为序号(0-6)进行各种操
     */
    
    //1.接收到切换seg的消息后，整理容器内当前的内容，规到当前index数据中，然后切换
    WeekDayBtnState state = WeekDayBtnStateNormal;
    
    NSMutableDictionary *date_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [date_dic setValue:[timesArr copy] forKey:@"occurance"];
    [date_dic setValue:[NSNumber numberWithInteger:segCurrentIndex] forKey:@"day"];
    
    NSPredicate *pred_conts = [NSPredicate predicateWithFormat:@"SELF.day=%d",segCurrentIndex];
    NSArray *result = [offer_date filteredArrayUsingPredicate:pred_conts];
    
    if (result.count != 0 && timesArr.count != 0) {     //update
        state = WeekDayBtnStateSeted;
        NSInteger changeIndex = [offer_date indexOfObject:result.lastObject];
        [offer_date replaceObjectAtIndex:changeIndex withObject:date_dic];
    }
    else if (result.count != 0 && timesArr.count == 0) {        //del
        
        [offer_date removeObject:result.lastObject];
    }
    else if (result.count == 0 && timesArr.count != 0) {        //creat
        state = WeekDayBtnStateSeted;
        [offer_date addObject:date_dic];
    }
    else if (result.count == 0 && timesArr.count == 0) {        //...
        
    }
    
    //切换
    segCurrentIndex = args.integerValue;
    
    //2.切换后，刷新，并且展示（如果有）此index的数据到容器中
    [timesArr removeAllObjects];
    for (NSDictionary *iter in offer_date) {
        if (((NSNumber*)[iter objectForKey:@"day"]).integerValue == segCurrentIndex) {
            [timesArr addObjectsFromArray:[iter objectForKey:@"occurance"]];
        }
    }
    NSArray *tmp = [timesArr copy];
    kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
    kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    
    //3.如果有数据：返回yes，用于btn作已设置标记
    return [NSNumber numberWithInt:state];
}

#pragma mark -- pickerView notifies
- (id)cellDeleteFromTable:(NSNumber*)args {
    
    [timesArr removeObjectAtIndex:args.integerValue];
    NSArray *tmp = [timesArr copy];
    kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
    kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    
    [self showRightBtn];
    return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
    
    creatOrUpdateNote = args.integerValue;
    kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
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
    
    NSArray *sortedArray = [timesArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        int first = ((NSNumber*)[obj1 objectForKey:@"start"]).intValue;
        int second = ((NSNumber*)[obj2 objectForKey:@"start"]).intValue;
        
        if (first < second) return  NSOrderedAscending;
        else if (first > second) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    [timesArr removeAllObjects];
    [timesArr addObjectsFromArray:sortedArray];
    
    if (![self isCurrentTimesLegal]) {
        if (!argsHolder) {
//            NSInteger holderIndex = [timesArr indexOfObject:args];
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
    kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
    kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    
    [self showRightBtn];
    
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
