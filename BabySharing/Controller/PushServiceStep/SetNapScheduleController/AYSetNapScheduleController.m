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

@implementation AYSetNapScheduleController {
    
    NSMutableDictionary *push_service_info;
    BOOL isChangeCalendar;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        push_service_info = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Tools whiteColor];
    
//    NSArray *offer_date = [push_service_info objectForKey:@"offer_date"];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:offer_date forKey:@"offer_date"];
//    kAYViewsSendMessage(@"Schedule", @"changeQueryData:", &dic)
    
    UIButton *pushServiceBtn = [Tools creatUIButtonWithTitle:@"发布服务" andTitleColor:[Tools whiteColor] andFontSize:17.f andBackgroundColor:[Tools themeColor]];
    [pushServiceBtn addTarget:self action:@selector(didPushServiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushServiceBtn];
    [pushServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
    }];
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
    
    return nil;
}

- (id)ScheduleLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 +10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 -10);
    return nil;
}

#pragma mark -- actions
- (void)didPushServiceBtnClick {
    
    NSArray *unavilableDateArr = nil;
    kAYViewsSendMessage(@"Schedule", @"queryUnavluableDate:", &unavilableDateArr)
    [push_service_info setValue:unavilableDateArr forKey:@"offer_date"];
    
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
                    NSString *tip = @"服务发布成功,去管理日程?";
                    [self popToRootVCWithTip:tip];
                    
                } else {
                    NSLog(@"push error with:%@",result);
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
    
    NSArray *unavilableDateArr = nil;
    kAYViewsSendMessage(@"Schedule", @"queryUnavluableDate:", &unavilableDateArr)
    NSMutableDictionary *update_info = [[NSMutableDictionary alloc]init];
    [update_info setValue:[push_service_info objectForKey:@"service_id"] forKey:@"service_id"];
    [update_info setValue:unavilableDateArr forKey:@"offer_date"];
    
    NSDictionary* args = nil;
    CURRENUSER(args)
    NSMutableDictionary *dic_revert = [[NSMutableDictionary alloc]init];
    [dic_revert setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
    [dic_revert setValue:[push_service_info objectForKey:@"service_id"] forKey:@"service_id"];
    //1.撤销服务
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateMyService"];
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
//    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
//    [bar_right_btn sizeToFit];
//    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
//    kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnWithBtn:", &bar_right_btn)
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
