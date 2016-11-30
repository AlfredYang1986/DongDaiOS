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

#define becomeNapNormalModelFitHeight               (64+49)
#define becomeNapAllreadyModelFitHeight               (64+49 + 44)

#define servInfoNormalModelFitHeight                           (64)
#define servInfoChangedModelFitHeight                           (64+44)

#define napPushServNormalModelFitHeight               (64+44)
#define napPushServAllreadyModelFitHeight               (64+44)

typedef void(^asynUploadImages)(BOOL, NSDictionary*);

@implementation AYMainInfoController {
    
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
            
        } else if ([args objectForKey:@"location"]) {
            _service_change_dic = [args mutableCopy];
        }
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        id dic_info = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([dic_info isKindOfClass:[NSNumber class]]) {
            return;
        }
        if (dic_info) {
            NSString *key = [dic_info objectForKey:@"key"];
            if ([key isEqualToString:@"nap_cover"]) {       //0
                napPhotos = [dic_info objectForKey:@"content"];
                [_noteAllArgs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:@"nap_theme"]){  //1
                
                [_service_change_dic setValue:[dic_info objectForKey:@"cans"] forKey:@"cans"];
                [_service_change_dic setValue:[dic_info objectForKey:@"allow_leave"] forKey:@"allow_leave"];
                
                [_noteAllArgs replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:@"nap_title"]) {  //2
                
                [_service_change_dic setValue:[dic_info objectForKey:@"title"] forKey:@"title"];
                
                [_noteAllArgs replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:@"nap_desc"]) {    //3
                napDesc = [dic_info objectForKey:@"content"];
                [_service_change_dic setValue:[dic_info objectForKey:@"content"] forKey:@"description"];
                [_noteAllArgs replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:@"nap_ages"]) {     //4
                
                [_service_change_dic setValue:[dic_info objectForKey:@"age_boundary"] forKey:@"age_boundary"];
                [_service_change_dic setValue:[dic_info objectForKey:@"capacity"] forKey:@"capacity"];
                [_service_change_dic setValue:[dic_info objectForKey:@"servant_no"] forKey:@"servant_no"];
                
                [_noteAllArgs replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:@"nap_cost"]) {   //5
                
                NSString *price = [dic_info objectForKey:@"price"];
                [_service_change_dic setValue:[NSNumber numberWithFloat:price.floatValue] forKey:@"price"];
                [_service_change_dic setValue:[dic_info objectForKey:@"least_hours"] forKey:@"least_hours"];
                
                [_noteAllArgs replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
            }
//            else if([key isEqualToString:@"nap_adress"]){     //5+
//                
//                CLLocation *napLoc = [dic_info objectForKey:@"location"];
//                NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
//                [location setValue:[NSNumber numberWithDouble:napLoc.coordinate.latitude] forKey:@"latitude"];
//                [location setValue:[NSNumber numberWithDouble:napLoc.coordinate.longitude] forKey:@"longtitude"];
//                
//                NSString *address = [dic_info objectForKey:@"address"];
//                NSString *adjust_address = [dic_info objectForKey:@"adjust_address"];
//                
//                [_service_change_dic setValue:location forKey:@"location"];
//                [_service_change_dic setValue:address forKey:@"address"];
//                [_service_change_dic setValue:adjust_address forKey:@"adjust_address"];
//                
//                [_noteAllArgs replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
//            }
            else if([key isEqualToString:@"nap_device"]) {     //6
                
                [_service_change_dic setValue:[dic_info objectForKey:@"facility"] forKey:@"facility"];
                [_service_change_dic setValue:[dic_info objectForKey:@"option_custom"] forKey:@"option_custom"];
            }
            
            if (service_info) {
                [self ServiceInfoChanged];
            }
            kAYDelegatesSendMessage(@"MainInfo", @"changeQueryData:", &dic_info)
            kAYViewsSendMessage(@"Table", @"refresh", nil)
        }
    }
}

- (void)ServiceInfoChanged {
    confirmSerBtn.hidden = NO;
    UIView *view = [self.views objectForKey:@"Table"];
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoChangedModelFitHeight);
}

- (BOOL)isAllArgsReady {
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
    NSArray* isAllResady = [_noteAllArgs filteredArrayUsingPredicate:p];
    return isAllResady.count == 0 ? YES : NO;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!_service_change_dic) {
        if (service_info) {
            _service_change_dic = [service_info mutableCopy];
        } else
            _service_change_dic = [[NSMutableDictionary alloc]init];
    }
    
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
    
    id<AYCommand> cmd_class = [view_notify.commands objectForKey:@"registerCellWithClass:"];
    NSString* photoCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapPhotosCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&photoCell];
    
    confirmSerBtn = [[UIButton alloc]init];
    confirmSerBtn.backgroundColor = [Tools themeColor];
    [confirmSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmSerBtn];
    confirmSerBtn.hidden = YES;
    
//    AYViewController* comp = DEFAULTCONTROLLER(@"TabBar");
//    isNapModel = ![self.tabBarController isKindOfClass:[comp class]];
    
    if (service_info) {
        
        NSString* editCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapEditInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_class performWithResult:&editCell];
        
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
        
        NSString* babyAgeCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapBabyAgeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_class performWithResult:&babyAgeCell];
        
        confirmSerBtn.hidden = NO;
        [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        [confirmSerBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(pushServiceTodoNext) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"主题看顾服务";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnImg:", &left)
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"预览" andTitleColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil];
    kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnWithBtn:", &bar_right_btn);
    
    kAYViewsSendMessage(@"FakeNavBar", @"setBarBotLine", nil);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    
//    AYViewController* comp = DEFAULTCONTROLLER(@"TabBar");
//    isNapModel = ![self.tabBarController isKindOfClass:[comp class]];
    CGFloat fit_height = 0;
    if (service_info) {
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
- (void)didMeBtnClick {
    
    NSString *title = [NSString stringWithFormat:@"您确认放弃发布当前服务吗？"];
    
    id<AYFacadeBase> f_alert = DEFAULTFACADE(@"Alert");
    id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"ShowAlert"];
    
    NSMutableDictionary *dic_alert = [[NSMutableDictionary alloc]init];
    [dic_alert setValue:title forKey:@"title"];
    [dic_alert setValue:[NSNumber numberWithInt:3] forKey:@"type"];
    [cmd_alert performWithResult:&dic_alert];
}

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
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapSchedule");
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [_service_change_dic setValue:napPhotos forKey:@"images"];
    [dic_push setValue:[_service_change_dic copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return;
    
    
}

- (void)updateMyService {
    //修改服务需两步：1 撤销服务 -> 2更新 -> 3再次发布
    NSDictionary* args = nil;
    CURRENUSER(args)
    NSMutableDictionary *dic_revert = [[NSMutableDictionary alloc]init];
    [dic_revert setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
    [dic_revert setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    //1.撤销服务
//    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
//    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"RevertMyService"];
//    [cmd_push performWithResult:[dic_revert copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//        if (success) {
            //2.更新
            
//            [_service_change_dic setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
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
            
//        } else {
//            NSLog(@"push error with:%@",result);
//            if (((NSNumber*)[result objectForKey:@"code"]).intValue == -15) {
//                
//                NSString *title = @"服务撤销失败,该服务状态错误";
//                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//            }
//        }
//    }];
}

- (void)updateService {
    NSDictionary* args = nil;
    CURRENUSER(args)
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"UpdateMyService"];
    [_service_change_dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    [cmd_publish performWithResult:[_service_change_dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            confirmSerBtn.hidden = YES;
            UIView *view = [self.views objectForKey:@"Table"];
            view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoNormalModelFitHeight);
            
            NSString *title = @"服务信息已更新";
            id<AYFacadeBase> f_alert = DEFAULTFACADE(@"Alert");
            id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"ShowAlert"];
            NSMutableDictionary *dic_alert = [[NSMutableDictionary alloc]init];
            [dic_alert setValue:title forKey:@"title"];
            [dic_alert setValue:[NSNumber numberWithInt:BtmAlertViewTypeHideWithTimer] forKey:@"type"];
            [cmd_alert performWithResult:&dic_alert];
            
            //3.重新发布
//            NSMutableDictionary *dic_publish = [[NSMutableDictionary alloc]init];
//            [dic_publish setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
//            [dic_publish setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
//            AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"PublishService"];
//            [cmd_publish performWithResult:[dic_publish copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//                if (success) {
//                    
//                    confirmSerBtn.hidden = YES;
//                    UIView *view = [self.views objectForKey:@"Table"];
//                    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoNormalModelFitHeight);
//                    
//                    NSString *title = @"服务信息已更新";
////                    id<AYFacadeBase> f_alert = [self.facades objectForKey:@"Alert"];
//                    id<AYFacadeBase> f_alert = DEFAULTFACADE(@"Alert");
//                    id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"ShowAlert"];
//                    
//                    NSMutableDictionary *dic_alert = [[NSMutableDictionary alloc]init];
//                    [dic_alert setValue:title forKey:@"title"];
//                    [dic_alert setValue:[NSNumber numberWithInt:BtmAlertViewTypeHideWithTimer] forKey:@"type"];
//                    [cmd_alert performWithResult:&dic_alert];
//                    
//                } else {
//                    
//                    NSString *title = @"服务信息已更新,发布失败";
//                    AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//                }
//            }];
        } else {
            
            NSString *title = @"服务信息更新失败";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
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
        [dic_args setValue:[_service_change_dic copy] forKey:kAYControllerChangeArgsKey];
    } else {
        
        if (napPhotos.count == 0) {
            NSString *title = @"预览服务需要先添加图片";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            return nil;
        }
        
        [_service_change_dic setValue:napPhotos forKey:@"images"];
        [dic_args setValue:[_service_change_dic copy] forKey:kAYControllerChangeArgsKey];
    }
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
            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[cmd.route stringByAppendingString:photo_name]] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
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
