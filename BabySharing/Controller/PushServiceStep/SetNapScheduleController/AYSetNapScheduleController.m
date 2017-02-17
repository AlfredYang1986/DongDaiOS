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
    
    NSMutableDictionary *push_service_info;
    BOOL isChangeCalendar;
    
    NSMutableArray *offer_date;
    NSString *service_id;
    
    NSMutableArray *timesArr;
    NSInteger segCurrentIndex;
    NSInteger creatOrUpdateNote;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        
        if ([tmp objectForKey:@"service_id"]) {
            offer_date = [[tmp objectForKey:@"offer_date"] mutableCopy];
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
    
//    NSArray *offer_date = [push_service_info objectForKey:@"offer_date"];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:offer_date forKey:@"offer_date"];
//    kAYViewsSendMessage(@"Schedule", @"changeQueryData:", &dic)
    
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
    
    if (push_service_info) {
        
        UIButton *pushServiceBtn = [Tools creatUIButtonWithTitle:@"发布服务" andTitleColor:[Tools whiteColor] andFontSize:17.f andBackgroundColor:[Tools themeColor]];
        [pushServiceBtn addTarget:self action:@selector(didPushServiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pushServiceBtn];
        [pushServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
        }];
    } else {
        
        for (NSDictionary *iter in offer_date) {
            if (((NSNumber*)[iter objectForKey:@"day"]).integerValue == segCurrentIndex) {
                [timesArr addObjectsFromArray:[iter objectForKey:@"occurance"]];
            }
        }
        NSArray *tmp = [timesArr copy];
        kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
        kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    }
    
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
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"时间管理";
    [cmd_title performWithResult:&title];
    
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
    view.frame = CGRectMake(0, 64 + weekdaysViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - weekdaysViewHeight - 64 - (push_service_info?49:0));
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.frame.size.height);
    return nil;
}

- (id)ScheduleLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 +10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 -10);
    return nil;
}

#pragma mark -- actions
- (void)didPushServiceBtnClick {
    
//    NSArray *unavilableDateArr = nil;
//    kAYViewsSendMessage(@"Schedule", @"queryUnavluableDate:", &unavilableDateArr)
//    [push_service_info setValue:unavilableDateArr forKey:@"offer_date"];
    
//    if (![self isCurrentTimesLegal]) {
//        NSString *title = @"服务时间设置错误";
//        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//        return ;
//    }
    
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
        [self didSaveClick];
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
        
    }
    
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
    
    if (service_id) {
        UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
        kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnWithBtn:", &bar_right_btn)
    }
    return nil;
}

- (id)changeCurrentIndex:(NSNumber *)args {
    /*
     日程管理可以是集合，不超出从日到一，是不按顺序的，以keyValue:day为序号(0-6)进行各种操
     */
    
//    if (![self isCurrentTimesLegal]) {
//        NSString *title = @"服务时间设置错误";
//        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//        return nil;
//    }
    
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
    
    [self ChangeOfSchedule];
    return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
    
    creatOrUpdateNote = args.integerValue;
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServiceTimesPick"];
    id<AYCommand> cmd_scroll_center = [cmd_recommend.commands objectForKey:@"scrollToCenterWithOffset:"];
    NSNumber *offset = [NSNumber numberWithInt:12];
    [cmd_scroll_center performWithResult:&offset];
    
    kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
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
    
    [self ChangeOfSchedule];
    
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
