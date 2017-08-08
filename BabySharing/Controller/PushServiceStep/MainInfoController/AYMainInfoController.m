//
//  AYMainInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMainInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "TmpFileStorageModel.h"
#import <CoreLocation/CoreLocation.h>

#import "AYServiceArgsDefines.h"

#define STATUS_BAR_HEIGHT						20
#define FAKE_BAR_HEIGHT							44
#define requiredInfoNumb						5

#define becomeNapNormalModelFitHeight			(64 + 49)
#define becomeNapAllreadyModelFitHeight			(64 + 49 + 44)
#define servInfoNormalModelFitHeight			(64)
#define servInfoChangedModelFitHeight			(64 + 44)
#define napPushServNormalModelFitHeight			(64 + 44)
#define napPushServAllreadyModelFitHeight		(64 + 44)

typedef void(^asynUploadImages)(BOOL, NSDictionary*);

@implementation AYMainInfoController {
    
    NSArray *napPhotos;
	
    NSMutableDictionary *push_service_info;
    NSMutableDictionary *update_service_info;
	NSMutableDictionary *show_service_info;
	
    NSMutableDictionary* dic_push_photos;
	UIButton *confirmSerBtn;
	
    BOOL isChangeServiceInfo;
	
	//handle
	NSMutableArray *handleIsCompileArgs;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        id push_args = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([push_args objectForKey:@"push"]) {
			push_service_info = [push_args mutableCopy];
        } else {
			show_service_info = [push_args mutableCopy];
        }
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		id dic_info = [dic objectForKey:kAYControllerChangeArgsKey];
		id key = [dic_info objectForKey:@"key"];
		
        if (key && [key isKindOfClass:[NSString class]]) {
            if ([key isEqualToString:kAYServiceArgsInfo]) {			//-1
                show_service_info = [dic_info objectForKey:kAYServiceArgsInfo];
            }
            else if ([key isEqualToString:@"nap_cover"]) {			//0
				napPhotos = [dic_info objectForKey:@"content"];
				[push_service_info setValue:[napPhotos copy] forKey:kAYServiceArgsImages];
                [handleIsCompileArgs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:kAYServiceArgsTitle]) {	//1
                
                NSString *title = [dic_info objectForKey:kAYServiceArgsTitle];
                //title constain and course_sign or coustom constain and or service_cat == 0
				if(title && ![title isEqualToString:@""]) {
					[update_service_info setValue:title forKey:kAYServiceArgsTitle];
					[show_service_info setValue:title forKey:kAYServiceArgsTitle];
					[push_service_info setValue:title forKey:kAYServiceArgsTitle];
                    [handleIsCompileArgs replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
                }
                
            }
            else if([key isEqualToString:@"nap_desc"]) {			//2
                NSString *napDesc = [dic_info objectForKey:@"content"];
				if (napDesc && ![napDesc isEqualToString:@""]) {
					[update_service_info setValue:napDesc forKey:kAYServiceArgsDescription];
					[show_service_info setValue:napDesc forKey:kAYServiceArgsDescription];
					[push_service_info setValue:napDesc forKey:kAYServiceArgsDescription];
					[handleIsCompileArgs replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
				}
            }
            else if([key isEqualToString:@"nap_cost"]) {			//3
                
                NSNumber *price = [dic_info objectForKey:kAYServiceArgsPrice];
                if (price && price.floatValue != 0) {
                    [[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:[NSNumber numberWithFloat:(price.floatValue * 100)] forKey:kAYServiceArgsPrice];
					[[show_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:[NSNumber numberWithFloat:(price.floatValue * 100)] forKey:kAYServiceArgsPrice];
					[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:[NSNumber numberWithFloat:(price.floatValue * 100)] forKey:kAYServiceArgsPrice];
                }
                NSNumber *leastHours = [dic_info objectForKey:kAYServiceArgsLeastHours];
                if (leastHours && leastHours.floatValue != 0) {
					[[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:leastHours forKey:kAYServiceArgsLeastHours];
					[[show_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:leastHours forKey:kAYServiceArgsLeastHours];
					[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:leastHours forKey:kAYServiceArgsLeastHours];
                }
                
                NSNumber *duration = [dic_info objectForKey:kAYServiceArgsCourseduration];
                if (duration && duration.floatValue != 0) {
					[[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:duration forKey:kAYServiceArgsCourseduration];
					[[show_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:duration forKey:kAYServiceArgsCourseduration];
					[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:duration forKey:kAYServiceArgsCourseduration];
                }
                NSNumber *leastTimes = [dic_info objectForKey:kAYServiceArgsLeastTimes];
                if (leastTimes && leastTimes.floatValue != 0) {
					[[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:leastTimes forKey:kAYServiceArgsLeastTimes];
					[[show_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:leastTimes forKey:kAYServiceArgsLeastTimes];
					[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:leastTimes forKey:kAYServiceArgsLeastTimes];
                }
				
				NSString *serviceCat = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
                if ([serviceCat isEqualToString:kAYStringNursery]) {
                    if (price && price.floatValue != 0 && leastHours && leastHours.floatValue != 0) {
                        [handleIsCompileArgs replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
                    }
                } else {
                    if (price && price.floatValue != 0 && duration && duration.floatValue != 0 && leastTimes && leastTimes.floatValue != 0) {
                        [handleIsCompileArgs replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
                    }
                }
            }
            else if([key isEqualToString:kAYServiceArgsNotice]) {   //4
				NSNumber *isAllowLeaves = [dic_info objectForKey:kAYServiceArgsAllowLeave];
				NSString *notice = [dic_info objectForKey:kAYServiceArgsNotice];
				
                [[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:isAllowLeaves forKey:kAYServiceArgsAllowLeave];
				[[show_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:isAllowLeaves forKey:kAYServiceArgsAllowLeave];
				[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:isAllowLeaves forKey:kAYServiceArgsAllowLeave];
				
				[[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:notice forKey:kAYServiceArgsNotice];
				[[show_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:notice forKey:kAYServiceArgsNotice];
				[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:notice forKey:kAYServiceArgsNotice];
				
                [handleIsCompileArgs replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:kAYServiceArgsFacility]) {     //5
				NSArray *facilities = [dic_info objectForKey:kAYServiceArgsFacility];
				[[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:facilities forKey:kAYServiceArgsFacility];
				[[show_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:facilities forKey:kAYServiceArgsFacility];
				[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:facilities forKey:kAYServiceArgsFacility];
//                [_service_change_dic setValue:[dic_info objectForKey:@"option_custom"] forKey:@"option_custom"];
            }
			
			NSDictionary *tmp;
            if (show_service_info) {
				tmp = [show_service_info copy];
                [self ServiceInfoChanged];
			} else {
				tmp = [push_service_info copy];
			}
			
            kAYDelegatesSendMessage(@"MainInfo", @"changeQueryData:", &tmp)
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
        }
		else {
			//isnot back service data
		}
    }
}

- (void)ServiceInfoChanged {
    confirmSerBtn.hidden = NO;
    UIView *view = [self.views objectForKey:kAYTableView];
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoChangedModelFitHeight);
}

- (BOOL)isAllArgsReady {
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
    NSArray* isAllResady = [handleIsCompileArgs filteredArrayUsingPredicate:p];
    return isAllResady.count == 0 ? YES : NO;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"MainInfo"];
    id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
    obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapPhotosCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
	cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OptionalInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
    confirmSerBtn = [Tools creatUIButtonWithTitle:nil andTitleColor:[Tools whiteColor] andFontSize:16.f andBackgroundColor:[Tools themeColor]];
    [self.view addSubview:confirmSerBtn];
    confirmSerBtn.hidden = YES;
    [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
	
	if (push_service_info) {
		handleIsCompileArgs = [[NSMutableArray alloc] init];
		for (int i = 0; i < requiredInfoNumb; ++i) {
			[handleIsCompileArgs addObject:[NSNumber numberWithBool:NO]];
		}
		
		NSDictionary *info_categ = [push_service_info objectForKey:kAYServiceArgsCategoryInfo];
		NSString *serviceCat = [info_categ objectForKey:kAYServiceArgsCat];
		if ([serviceCat isEqualToString:kAYStringNursery]) {
			NSString *title = @"我的看顾服务";
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
		} else if ([serviceCat isEqualToString:kAYStringCourse]) {
			NSString *title = @"我的课程";
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
		}
		
//		NSMutableDictionary *dic_info = [[NSMutableDictionary alloc] init];
//		[dic_info setValue:kAYServiceArgsCat forKey:@"key"];
//		[dic_info setValue:[_service_change_dic objectForKey:kAYServiceArgsCat] forKey:kAYServiceArgsCat];
//		[dic_info setValue:[_service_change_dic objectForKey:kAYServiceArgsCatSecondary] forKey:kAYServiceArgsCatSecondary];
//		kAYDelegatesSendMessage(@"MainInfo", @"changeQueryData:", &dic_info)
		
		NSString* babyAgeCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapBabyAgeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &babyAgeCell)
		
		confirmSerBtn.hidden = NO;
		[confirmSerBtn setTitle:@"下一步" forState:UIControlStateNormal];
		[confirmSerBtn addTarget:self action:@selector(pushServiceTodoNext) forControlEvents:UIControlEventTouchUpInside];
		
	} else {
		update_service_info = [[NSMutableDictionary alloc] init];
//		[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsCategoryInfo];
		[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsDetailInfo];
//		[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsDetailInfo];
//		[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsDetailInfo];
		
		NSString* editCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapEditInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &editCell)
		
		NSDictionary *dic_info = [show_service_info copy];
		kAYDelegatesSendMessage(@"MainInfo", @"changeQueryInfo:", &dic_info)
		
		[confirmSerBtn setTitle:@"修改服务信息" forState:UIControlStateNormal];
		[confirmSerBtn addTarget:self action:@selector(updateMyService) forControlEvents:UIControlEventTouchUpInside];
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    
    NSString *title = @"修改服务";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnImg:", &left)
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"预览" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnWithBtn:", &bar_right_btn);
    
    kAYViewsSendMessage(@"FakeNavBar", @"setBarBotLine", nil);
    return nil;
}

- (id)TableLayout:(UIView*)view {
	
    CGFloat fit_height = 0;
    if (show_service_info) {
        fit_height = servInfoNormalModelFitHeight;
    } else {
        fit_height = napPushServNormalModelFitHeight;
    }
    
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - fit_height);
    return nil;
}

#pragma mark -- actions
- (void)uploadImages:(NSArray*)images andResult:(asynUploadImages)block {
    
}

- (void)popToRootVCWithTip:(NSString*)tip {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:tip forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
    
}

#pragma mark -- alert actions
- (void)BtmAlertOtherBtnClick {
    NSLog(@"didOtherBtnClick");
    
    [super BtmAlertOtherBtnClick];
    [self popToRootVCWithTip:nil];
}

#pragma mark -- 提交服务
- (void)pushServiceTodoNext {
    
    if (![self isAllArgsReady]) {
        NSString *title = @"请完成所有必选项设置";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
	
    id<AYCommand> dest ;
	NSString *serviceCat = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([serviceCat isEqualToString:kAYStringCourse]) {
		dest = DEFAULTCONTROLLER(@"NapScheduleMain");
	} else if ([serviceCat isEqualToString:kAYStringNursery]) {
		dest = DEFAULTCONTROLLER(@"NurseScheduleMain");
	}
	
	[push_service_info setValue:napPhotos forKey:kAYServiceArgsImages];
	
	NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:push_service_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return;
    
}

- (void)updateMyService {
    
	if (napPhotos.count != 0) {
		NSMutableArray* semaphores_upload_photos = [[NSMutableArray alloc]init];   // 一个图片是一个上传线程，需要一个semaphores等待上传完成
		for (int index = 0; index < napPhotos.count; ++index) {
			dispatch_semaphore_t tmp = dispatch_semaphore_create(0);
			[semaphores_upload_photos addObject:tmp];
		}
		
		NSMutableArray* post_image_result = [[NSMutableArray alloc]init];           // 记录每一个图片在线中上传的结果
		for (int index = 0; index < napPhotos.count; ++index) {
			[post_image_result addObject:[NSNumber numberWithBool:NO]];
		}
		
		dispatch_queue_t qp = dispatch_queue_create("post thread", nil);
		dispatch_async(qp, ^{
			
			NSMutableArray* arr_items = [[NSMutableArray alloc]init];
			for (int index = 0; index < napPhotos.count; ++index) {
				UIImage* iter = [napPhotos objectAtIndex:index];
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
			
			// 4. 等待图片进程全部处理完成
			for (dispatch_semaphore_t iter in semaphores_upload_photos) {
				dispatch_semaphore_wait(iter, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
			}
			
			NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
			NSArray* image_result = [post_image_result filteredArrayUsingPredicate:p];
			if (image_result.count == 0) {
				[update_service_info setValue:arr_items forKey:kAYServiceArgsImages];
				[self updateServiceInfo];
			}
		});
	} else {
		[self updateServiceInfo];
	}
}

- (void)updateServiceInfo {
    NSDictionary* user = nil;
    CURRENUSER(user)
	
	NSMutableDictionary *dic_update = [[NSMutableDictionary alloc] init];
	[dic_update setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	NSDictionary *dic_condt = @{kAYCommArgsUserID:[user objectForKey:kAYCommArgsUserID]};
	[dic_update setValue:dic_condt forKey:kAYCommArgsCondition];
	
    [update_service_info setValue:[show_service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_update setValue:update_service_info forKey:kAYServiceArgsSelf];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"UpdateMyService"];
    [cmd_publish performWithResult:[dic_update copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
//            [_service_change_dic removeObjectForKey:kAYServiceArgsIsAdjustSKU];
			
            isChangeServiceInfo = YES;		//pop VC 是否刷新
            confirmSerBtn.hidden = YES;
            UIView *view = [self.views objectForKey:kAYTableView];
            view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoNormalModelFitHeight);
            
            NSString *title = @"服务信息已更新";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            
        } else {
            
            NSString *title = @"服务信息更新失败";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    if (isChangeServiceInfo) {
        [dic_pop setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    }
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
    NSMutableDictionary* dic_args = [[NSMutableDictionary alloc]init];
    [dic_args setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_args setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_args setValue:self forKey:kAYControllerActionSourceControllerKey];
	
    NSMutableDictionary *tmp;
    if (push_service_info) {
		tmp = [[NSMutableDictionary alloc] initWithDictionary:push_service_info];
    } else {
		tmp = [[NSMutableDictionary alloc] initWithDictionary:show_service_info];
        [tmp setValue:napPhotos forKey:kAYServiceArgsImages];
    }
	
	[tmp setValue:[NSNumber numberWithInt:1] forKey:@"perview_mode"];
	[dic_args setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic_args];
    return nil;
}

/*************************/
- (id)addPhotosAction {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"EditPhotos");
    
    dic_push_photos = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push_photos setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push_photos setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push_photos setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if (napPhotos.count != 0) {
        [dic_push_photos setValue:[napPhotos copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        NSDictionary *tmp = [dic_push_photos copy];
        [cmd performWithResult:&tmp];
        
    } else if(show_service_info) {
        
        UIView *HUBView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        HUBView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25f];
        [self.view addSubview:HUBView];
        CALayer *hubLayer = [[CALayer alloc]init];
        hubLayer.frame = CGRectMake(0, 0, 200, 80);
        hubLayer.position = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        hubLayer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f].CGColor;
        hubLayer.cornerRadius = 10.f;
        [HUBView.layer addSublayer:hubLayer];
        
        UILabel *tips = [Tools creatUILabelWithText:@"正在准备图片..." andTextColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
        [HUBView addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(HUBView);
            make.centerY.equalTo(HUBView);
        }];
        
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        NSArray *namesArr = [show_service_info objectForKey:kAYServiceArgsImages];
        
        for (int i = 0; i < namesArr.count; ++i) {
			
			NSString* photo_name = namesArr[i];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[kAYDongDaDownloadURL stringByAppendingString:photo_name]] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (finished) {
                    [tmp addObject:image];
                    if (tmp.count == namesArr.count) {  //所有图片准备完毕
                        
                        [HUBView removeFromSuperview];
                        
                        [dic_push_photos setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
                        id<AYCommand> cmd = PUSH;
                        NSDictionary *tmp = [dic_push_photos copy];
                        [cmd performWithResult:&tmp];
                    }
                }
            }];
            
        }
        
    } else {
        
        id<AYCommand> cmd = PUSH;
        NSDictionary *tmp = [dic_push_photos copy];
        [cmd performWithResult:&tmp];
    }
    
    return nil;
}

- (id)editPhotosAction {
    
    return nil;
}
/**********************/

@end
