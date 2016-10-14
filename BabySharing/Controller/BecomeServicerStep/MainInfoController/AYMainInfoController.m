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
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import <CoreLocation/CoreLocation.h>

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44

#define becomeNapNormalModelFitHeight               (64+49 - 1)
#define becomeNapAllreadyModelFitHeight               (64+49 + 44 - 1)

#define servInfoNormalModelFitHeight                           (64 - 1)
#define servInfoChangedModelFitHeight                           (64+44 - 1)

#define napPushServNormalModelFitHeight               (64 - 1)
#define napPushServAllreadyModelFitHeight               (64+44 - 1)

typedef void(^asynUploadImages)(BOOL, NSDictionary*);

@implementation AYMainInfoController {
    
    NSString *areaString;
    NSNumber *type;
    
    NSArray *napPhotos;
    NSString *napDesc;
    NSString *napAges;
    NSDictionary *service_info;
    
    UIButton *confirmSerBtn;
    NSMutableDictionary* dic_push_photos;
    
    BOOL isNapModel;
}


#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *args = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([args objectForKey:@"owner_id"]) {
            service_info = args;
            
        } else if ([args objectForKey:@"type"]) {
            areaString = [args objectForKey:@"area"];
            type = [args objectForKey:@"type"];
        }
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *dic_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
        if (dic_info) {
            NSString *key = [dic_info objectForKey:@"key"];
            if ([key isEqualToString:@"nap_cover"]) {       //0
                napPhotos = [dic_info objectForKey:@"content"];
                [_noteAllArgs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
                
            } else if([key isEqualToString:@"nap_title"]) {  //1
                
                [_service_change_dic setValue:[dic_info objectForKey:@"title"] forKey:@"title"];
                [_noteAllArgs replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
            }
//            else if([key isEqualToString:@"nap_desc"]) {
//                napDesc = [dic_info objectForKey:@"content"];
//                [_service_change_dic setValue:[dic_info objectForKey:@"content"] forKey:@"description"];
//                
//            }
            else if([key isEqualToString:@"nap_ages"]){     //2
                
                [_service_change_dic setValue:[dic_info objectForKey:@"age_boundary"] forKey:@"age_boundary"];
                [_service_change_dic setValue:[dic_info objectForKey:@"capacity"] forKey:@"capacity"];
                
                [_noteAllArgs replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
                
            } else if([key isEqualToString:@"nap_theme"]){  //3
                
                [_service_change_dic setValue:[dic_info objectForKey:@"cans"] forKey:@"cans"];
                [_service_change_dic setValue:[dic_info objectForKey:@"allow_leave"] forKey:@"allow_leave"];
                
                [_noteAllArgs replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
                
            } else if([key isEqualToString:@"nap_cost"]){   //4
                
                NSString *price = [dic_info objectForKey:@"price"];
                [_service_change_dic setValue:[NSNumber numberWithFloat:price.floatValue] forKey:@"price"];
                [_service_change_dic setValue:[dic_info objectForKey:@"least_hours"] forKey:@"least_hours"];
                
                [_noteAllArgs replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:YES]];
                
            } else if([key isEqualToString:@"nap_adress"]){     //5
                
                CLLocation *napLoc = [dic_info objectForKey:@"location"];
                NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
                [location setValue:[NSNumber numberWithDouble:napLoc.coordinate.latitude] forKey:@"latitude"];
                [location setValue:[NSNumber numberWithDouble:napLoc.coordinate.longitude] forKey:@"longtitude"];
                
                NSString *address = [dic_info objectForKey:@"address"];
                NSString *adjust_address = [dic_info objectForKey:@"adjust_address"];
                
                [_service_change_dic setValue:location forKey:@"location"];
                [_service_change_dic setValue:address forKey:@"address"];
                [_service_change_dic setValue:adjust_address forKey:@"adjust_address"];
                
                [_noteAllArgs replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
                
            } else if([key isEqualToString:@"nap_device"]){     //6
                
                [_service_change_dic setValue:[dic_info objectForKey:@"facility"] forKey:@"facility"];
                [_service_change_dic setValue:[dic_info objectForKey:@"option_custom"] forKey:@"option_custom"];
                
//                [_noteAllArgs replaceObjectAtIndex:6 withObject:[NSNumber numberWithBool:YES]];
            }
            
            [self isAllArgsReady];
            
            kAYDelegatesSendMessage(@"MainInfo", @"changeQueryData:", &dic_info)
            kAYViewsSendMessage(@"Table", @"refresh", nil)
        }
    }
}

- (void)isAllArgsReady {
    
    if (!service_info) {
        
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
        NSArray* isAllResady = [_noteAllArgs filteredArrayUsingPredicate:p];
        
        if (isAllResady.count == 0 ) {
            
            confirmSerBtn.hidden = NO;
            UIView *view = [self.views objectForKey:@"Table"];
            view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - (isNapModel?napPushServAllreadyModelFitHeight:becomeNapAllreadyModelFitHeight));
        }
    } else {
        
        confirmSerBtn.hidden = NO;
        UIView *view = [self.views objectForKey:@"Table"];
        view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoChangedModelFitHeight);
    }
    
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _service_change_dic = [[NSMutableDictionary alloc]init];
    
    if (!service_info) {
        _noteAllArgs = [[NSMutableArray alloc]init];
        for (int i = 0; i < 6; ++i) {
            [_noteAllArgs addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"MainInfo"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithNib:"];
    NSString* photoCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapPhotosCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_cell performWithResult:&photoCell];
    
    confirmSerBtn = [[UIButton alloc]init];
    confirmSerBtn.backgroundColor = [Tools themeColor];
    [confirmSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmSerBtn];
    confirmSerBtn.hidden = YES;
    
    if (service_info) {
        
        NSString* editCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapEditInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&editCell];
        
        NSDictionary *dic_info = [service_info copy];
        kAYDelegatesSendMessage(@"MainInfo", @"changeQueryInfo:", &dic_info)
        kAYViewsSendMessage(@"Table", @"refresh", nil)
        
        [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        [confirmSerBtn setTitle:@"修改服务信息" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(updateMyService) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        AYViewController* comp = DEFAULTCONTROLLER(@"TabBar");
        isNapModel = ![self.tabBarController isKindOfClass:[comp class]];
        
        NSString* babyAgeCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapBabyAgeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_cell performWithResult:&babyAgeCell];
        
        [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset((isNapModel?0:-49));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        [confirmSerBtn setTitle:@"提交我的服务" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(conmitMyService) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (!isNapModel) {
            
            UIView *tabbar = [[UIView alloc]init];
            tabbar.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
            [self.view addSubview:tabbar];
            [tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(49);
            }];
            CALayer *line = [CALayer layer];
            line.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
            line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
            [tabbar.layer addSublayer:line];
            
            UIButton *me = [[UIButton alloc]init];
            [tabbar addSubview:me];
            [me setImage:IMGRESOURCE(@"tab_profile") forState:UIControlStateNormal];
            me.imageEdgeInsets = UIEdgeInsetsMake(-5, 10, 5, -10);
            [me setTitle:@"我的" forState:UIControlStateNormal];
            [me setTitleColor:[UIColor colorWithWhite:0.6078 alpha:1.f] forState:UIControlStateNormal];
            me.titleLabel.font = [UIFont systemFontOfSize:9.f];
            me.titleEdgeInsets = UIEdgeInsetsMake(15, -12, -15, 12);
            [me mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(tabbar).offset(-20);
                make.centerY.equalTo(tabbar);
                make.size.mas_equalTo(CGSizeMake(50, 44));
            }];
            [me addTarget:self action:@selector(didMeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)TableLayout:(UIView*)view {
    
    CGFloat fit_height = 0;
    if (service_info) {
        fit_height = servInfoNormalModelFitHeight;
    } else {
        fit_height = isNapModel?napPushServNormalModelFitHeight:becomeNapNormalModelFitHeight;
    }
    
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - fit_height);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"主题看顾服务";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnImg:", &left)
    
    UIButton* bar_right_btn = [[UIButton alloc]init];
    bar_right_btn = [Tools setButton:bar_right_btn withTitle:@"预览" andTitleColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnWithBtn:", &bar_right_btn);
    
    kAYViewsSendMessage(@"FakeNavBar", @"setBarBotLine", nil);
    
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
- (void)didMeBtnClick {
    
    NSString *title = [NSString stringWithFormat:@"您确认放弃发布当前服务吗？"];
    id<AYFacadeBase> f_alert = [self.facades objectForKey:@"Alert"];
    id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"ShowAlert"];
    
    NSMutableDictionary *dic_alert = [[NSMutableDictionary alloc]init];
    [dic_alert setValue:title forKey:@"title"];
    [dic_alert setValue:[NSNumber numberWithInt:3] forKey:@"type"];
    [cmd_alert performWithResult:&dic_alert];
}

- (void)BtmAlertOtherBtnClick {
    NSLog(@"didOtherBtnClick");
    
//    id<AYFacadeBase> f_alert = [self.facades objectForKey:@"Alert"];
//    id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"HideAlert"];
//    [cmd_alert performWithResult:nil];
    
    [super BtmAlertOtherBtnClick];
    
    [self popToRootVCWithTip:nil];
}

#pragma mark -- 提交/更新服务
- (void)conmitMyService {
    
    NSMutableArray* semaphores_upload_photos = [[NSMutableArray alloc]init];   // 一个图片是一个上传线程，需要一个semaphores等待上传完成
    NSMutableArray* post_image_result = [[NSMutableArray alloc]init];           // 记录每一个图片在线中上传的结果
    
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
            NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:iter];
            
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
//            dispatch_semaphore_wait([semaphores_upload_photos objectAtIndex:index], dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
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
            
            [_service_change_dic setValue:[user_info objectForKey:@"user_id"]  forKey:@"owner_id"];
            [_service_change_dic setObject:arr_items forKey:@"images"];
            if (areaString) {
                [_service_change_dic setValue:areaString forKey:@"distinct"];
            }
            
            id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
            AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushServiceInfo"];
            [cmd_push performWithResult:[_service_change_dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                if (success) {
                    //发布服务需两步：1上传 -> 2发布
                    NSMutableDictionary *dic_publish = [[NSMutableDictionary alloc]init];
                    [dic_publish setValue:[user_info objectForKey:@"user_id"] forKey:@"owner_id"];
                    [dic_publish setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
                    AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"PublishService"];
                    [cmd_publish performWithResult:[dic_publish copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                        if (success) {
//                            kAYUIAlertView(@"提示", @"服务发布成功");
                            
                            /**
                             *  change profile info in coredata
                             */
                            id<AYFacadeBase> facade = LOGINMODEL;
                            id<AYCommand> cmd_profle = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
                            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                            [dic setValue:[NSNumber numberWithInt:1] forKey:@"is_service_provider"];
                            [cmd_profle performWithResult:&dic];
                            
                            NSString *tip = @"服务发布成功";
                            [self popToRootVCWithTip:tip];
                        }else {
                            kAYUIAlertView(@"错误", @"服务发布失败");
                        }
                    }];
                } else {
                    NSLog(@"push error with:%@",result);
                    [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务上传失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                }
            }];
        } else {
            kAYUIAlertView(@"图片上传失败", @"请改善网络环境并重试");
        }
    });
    
}

- (void)updateMyService {
    //修改服务需两步：1 撤销服务 -> 2更新 -> 3再次发布
    NSDictionary* args = nil;
    CURRENUSER(args)
    NSMutableDictionary *dic_revert = [[NSMutableDictionary alloc]init];
    [dic_revert setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
    [dic_revert setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    //1.撤销服务
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"RevertMyService"];
    [cmd_push performWithResult:[dic_revert copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            //2.更新
            
            [_service_change_dic setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
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
                        NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:iter];
                        
                        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:1];
                        [photo_dic setValue:extent forKey:@"image"];
                        [photo_dic setValue:@"img_desc" forKey:@"expect_size"];
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
                        [_service_change_dic setValue:arr_items forKey:@"images"];
                        [self updateService];
                    }
                });
            } else {
                [self updateService];
            }
            
        } else {
            NSLog(@"push error with:%@",result);
            if (((NSNumber*)[result objectForKey:@"code"]).intValue == -15) {
                kAYUIAlertView(@"错误", @"服务撤销失败,该服务状态错误");
            }
        }
    }];
}

- (void)updateService {
    NSDictionary* args = nil;
    CURRENUSER(args)
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"UpdateMyService"];
    [cmd_publish performWithResult:[_service_change_dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            //3.重新发布
            NSMutableDictionary *dic_publish = [[NSMutableDictionary alloc]init];
            [dic_publish setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
            [dic_publish setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
            AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"PublishService"];
            [cmd_publish performWithResult:[dic_publish copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                if (success) {
                    
//                    kAYUIAlertView(@"提示", @"服务信息已更新");
                    confirmSerBtn.hidden = YES;
                    UIView *view = [self.views objectForKey:@"Table"];
                    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - (service_info?49:0) + 1);
                    
                    NSString *tip = @"服务信息已更新";
                    [self popToRootVCWithTip:tip];
                    
                } else {
                    kAYUIAlertView(@"错误", @"服务信息已更新发布失败");
                }
            }];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务信息更新失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
    NSMutableDictionary* dic_args = [[NSMutableDictionary alloc]init];
    [dic_args setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_args setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_args setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if (service_info) {
        [dic_args setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
    } else {
        
        if (napPhotos.count == 0) {
            kAYUIAlertView(@"提示", @"预览服务需要先添加图片");
            return nil;
        }
        
        [_service_change_dic setValue:napPhotos forKey:@"images"];
        if (areaString) {
            [_service_change_dic setValue:areaString forKey:@"distinct"];
        }
        [dic_args setValue:[_service_change_dic copy] forKey:kAYControllerChangeArgsKey];
    }
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic_args];
    
    return nil;
}

/*************************/
- (id)addPhotosAction {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"EditPhotos");
    
    dic_push_photos = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push_photos setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push_photos setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push_photos setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if (napPhotos.count != 0) {
        [dic_push_photos setValue:[napPhotos copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        NSDictionary *tmp = [dic_push_photos copy];
        [cmd performWithResult:&tmp];
        
    } else if(service_info) {
        
        UIView *HUBView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        HUBView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25f];
        [self.view addSubview:HUBView];
        CALayer *hubLayer = [[CALayer alloc]init];
        hubLayer.frame = CGRectMake(0, 0, 200, 80);
        hubLayer.position = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        hubLayer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f].CGColor;
        hubLayer.cornerRadius = 10.f;
        [HUBView.layer addSublayer:hubLayer];
        
        UILabel *tips = [[UILabel alloc]init];
        tips = [Tools setLabelWith:tips andText:@"正在准备图片..." andTextColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
        [HUBView addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(HUBView);
            make.centerY.equalTo(HUBView);
        }];
        
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        NSArray *namesArr = [service_info objectForKey:@"images"];
        
        for (int i = 0; i < namesArr.count; ++i) {
            NSString* photo_name = namesArr[i];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:photo_name forKey:@"image"];
            [dic setValue:@"img_local" forKey:@"expect_size"];
            
            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
            [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                UIImage* img = (UIImage*)result;
                if (img != nil) {
                    [tmp addObject:img];
                    if (tmp.count == namesArr.count) {
                        [dic_push_photos setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
                        
                        [HUBView removeFromSuperview];
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

- (id)inputNapTitleAction {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputNapTitle");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    if ([_service_change_dic objectForKey:@"title"]) {
        [dic_push setValue:[_service_change_dic objectForKey:@"title"] forKey:kAYControllerChangeArgsKey];
    } else
        [dic_push setValue:[service_info objectForKey:@"title"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)inputNapDescAction:(NSString*)args {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputNapDesc");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    if (args && ![args isEqualToString:@""]) {
        [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    }
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapBabyAges {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"SetNapAges");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    if ([_service_change_dic objectForKey:@"capacity"]) {
        [dic_args setValue:[_service_change_dic objectForKey:@"capacity"] forKey:@"capacity"];
        [dic_args setValue:[_service_change_dic objectForKey:@"age_boundary"] forKey:@"age_boundary"];
    } else {
        [dic_args setValue:[service_info objectForKey:@"capacity"] forKey:@"capacity"];
        [dic_args setValue:[service_info objectForKey:@"age_boundary"] forKey:@"age_boundary"];
    }
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapTheme {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapTheme");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
//    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
//    [dic_args setValue:[_service_change_dic objectForKey:@"cans"] forKey:@"cans"];
//    [dic_args setValue:[_service_change_dic objectForKey:@"allow_leave"] forKey:@"allow_leave"];
//    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    if ([_service_change_dic objectForKey:@"cans"]) {
        [dic_args setValue:[_service_change_dic objectForKey:@"cans"] forKey:@"cans"];
        [dic_args setValue:[_service_change_dic objectForKey:@"age_boundary"] forKey:@"age_boundary"];
    } else {
        [dic_args setValue:[service_info objectForKey:@"cans"] forKey:@"cans"];
        [dic_args setValue:[service_info objectForKey:@"allow_leave"] forKey:@"allow_leave"];
    }
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapCost {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapCost");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
//    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
//    [dic_args setValue:[_service_change_dic objectForKey:@"price"] forKey:@"price"];
//    [dic_args setValue:[_service_change_dic objectForKey:@"least_hours"] forKey:@"least_hours"];
//    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    if ([_service_change_dic objectForKey:@"price"]) {
        [dic_args setValue:[_service_change_dic objectForKey:@"price"] forKey:@"price"];
        [dic_args setValue:[_service_change_dic objectForKey:@"age_boundary"] forKey:@"age_boundary"];
    } else {
        [dic_args setValue:[service_info objectForKey:@"price"] forKey:@"price"];
        [dic_args setValue:[service_info objectForKey:@"least_hours"] forKey:@"least_hours"];
    }
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapAdress {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"InputNapAdress");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
//    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
//    [dic_args setValue:[_service_change_dic objectForKey:@"address"] forKey:@"address"];
//    [dic_args setValue:[_service_change_dic objectForKey:@"adjust_address"] forKey:@"adjust_address"];
//    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    if ([_service_change_dic objectForKey:@"address"]) {
        [dic_args setValue:[_service_change_dic objectForKey:@"address"] forKey:@"address"];
        [dic_args setValue:[_service_change_dic objectForKey:@"adjust_address"] forKey:@"adjust_address"];
        
        NSDictionary *loc_dic = [_service_change_dic objectForKey:@"location"];
        CLLocation *napLoc = [[CLLocation alloc]initWithLatitude:((NSNumber*)[loc_dic objectForKey:@"latitude"]).doubleValue longitude:((NSNumber*)[loc_dic objectForKey:@"longtitude"]).doubleValue];
        [dic_args setValue:napLoc forKey:@"location"];
        
    } else {
        [dic_args setValue:[service_info objectForKey:@"address"] forKey:@"address"];
        [dic_args setValue:[service_info objectForKey:@"adjust_address"] forKey:@"adjust_address"];
        NSDictionary *loc_dic = [service_info objectForKey:@"location"];
        CLLocation *napLoc = [[CLLocation alloc]initWithLatitude:((NSNumber*)[loc_dic objectForKey:@"latitude"]).doubleValue longitude:((NSNumber*)[loc_dic objectForKey:@"longtitude"]).doubleValue];
        [dic_args setValue:napLoc forKey:@"location"];
    }
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapDevice {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
//    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
//    [dic_args setValue:[_service_change_dic objectForKey:@"facility"] forKey:@"facility"];
//    [dic_args setValue:[_service_change_dic objectForKey:@"option_custom"] forKey:@"option_custom"];
//    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    if ([_service_change_dic objectForKey:@"facility"]) {
        [dic_args setValue:[_service_change_dic objectForKey:@"facility"] forKey:@"facility"];
        [dic_args setValue:[_service_change_dic objectForKey:@"option_custom"] forKey:@"option_custom"];
    } else {
        [dic_args setValue:[service_info objectForKey:@"facility"] forKey:@"facility"];
        [dic_args setValue:[service_info objectForKey:@"option_custom"] forKey:@"option_custom"];
    }
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}
/**********************/

@end
