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
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"
#import "Tools.h"
#import <CoreLocation/CoreLocation.h>

#import "AYModelFacade.h"

#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "TmpFileStorageModel.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height

@interface AYMainInfoController () <UIActionSheetDelegate>

@end

@implementation AYMainInfoController {
    NSString *areaString;
    
    UIImage *napPhoto;
    NSArray *napPhotos;
    
    NSString *napTitle;
    NSString *napDesc;
    NSString *napAges;
    NSDictionary *age_boundary;
    
    NSDictionary *dic_cost;
    NSString *napCost;
    long napCostOptions;
    
    NSDictionary *dic_adress;
    NSString *napAdress;
    CLLocation *napLoc;
    
    NSDictionary *dic_device;
    NSString *napDevice;
    long napDeviceOptons;
    
    NSDictionary *service_info;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        id args = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([args isKindOfClass:[NSDictionary class]]) {
            
            service_info = (NSDictionary*)args;
            
            id<AYDelegateBase> delegate = [self.delegates objectForKey:@"MainInfo"];
            id<AYCommand> cmd = [delegate.commands objectForKey:@"changeQueryInfo:"];
            NSDictionary *dic_info = service_info;
            [cmd performWithResult:&dic_info];
        } else if ([args isKindOfClass:[NSString class]]){
            areaString = (NSString*)args;
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *dic_info = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_info) {
            
            NSString *key = [dic_info objectForKey:@"key"];
            if ([key isEqualToString:@"nap_cover"]) {
                napPhotos = [dic_info objectForKey:@"content"];
                napPhoto = [napPhotos objectAtIndex:0];
                
            } else if([key isEqualToString:@"nap_title"]){
                napTitle = [dic_info objectForKey:@"content"];
                
            } else if([key isEqualToString:@"nap_desc"]){
                napDesc = [dic_info objectForKey:@"content"];
                
            } else if([key isEqualToString:@"nap_ages"]){
                age_boundary = [dic_info objectForKey:@"content"];
                
            } else if([key isEqualToString:@"nap_cost"]){
                dic_cost = [dic_info objectForKey:@"content"];
                napCost = [dic_cost objectForKey:@"cost"];
                napCostOptions = ((NSNumber*)[dic_cost objectForKey:@"option_pow"]).longValue;
                
            } else if([key isEqualToString:@"nap_adress"]){
                dic_adress = [dic_info objectForKey:@"content"];
                napLoc = [dic_adress objectForKey:@"location"];
                napAdress = [NSString stringWithFormat:@"%@%@",[dic_adress objectForKey:@"head"], [dic_adress objectForKey:@"detail"]];
                
            } else if([key isEqualToString:@"nap_device"]){
                dic_device = [dic_info objectForKey:@"content"];
                napDevice = [dic_device objectForKey:@"option_custom"];
                napDeviceOptons = ((NSNumber*)[dic_device objectForKey:@"option_pow"]).longValue;
            }
            
            id<AYDelegateBase> delegate = [self.delegates objectForKey:@"MainInfo"];
            id<AYCommand> cmd = [delegate.commands objectForKey:@"changeQueryData:"];
            [cmd performWithResult:&dic_info];
        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
    UIColor* c_nav = [UIColor clearColor];
    [cmd_nav performWithResult:&c_nav];
    
    
    {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"MainInfo"];
        
        id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithNib:"];
        NSString* photoCell = @"AYNapPhotosCellView";
        [cmd_cell performWithResult:&photoCell];
        NSString* titleCell = @"AYNapTitleCellView";
        [cmd_cell performWithResult:&titleCell];
        NSString* decsCell = @"AYNapDescCellView";
        [cmd_cell performWithResult:&decsCell];
        
        NSString* babyAgeCell = @"AYNapBabyAgeCellView";
        [cmd_cell performWithResult:&babyAgeCell];
        
        NSString* costCell = @"AYNapCostCellView";
        [cmd_cell performWithResult:&costCell];
        
        NSString* locationCell = @"AYNapLocationCellView";
        [cmd_cell performWithResult:&locationCell];
        
        NSString* deviceCell = @"AYNapDeviceCellView";
        [cmd_cell performWithResult:&deviceCell];
    }
    
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
    [me addTarget:self action:@selector(popToRootVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmSerBtn = [[UIButton alloc]init];
    confirmSerBtn.backgroundColor = [Tools themeColor];
    [confirmSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmSerBtn];
    [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tabbar.mas_top);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    if (service_info) {
        [confirmSerBtn setTitle:@"修改服务信息" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(updateMyService) forControlEvents:UIControlEventTouchDown];
    } else{
        [confirmSerBtn setTitle:@"提交我的服务" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(conmitMyService) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- layout
- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 44 +1);
    //    view.backgroundColor = [UIColor orangeColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"预览" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"添加看护服务";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [Tools blackColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 44 / 2 + 20);
    return nil;
}

#pragma mark -- actions
- (void)popToRootVC {
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic_pop];
}

- (void)conmitMyService {
    NSMutableArray* semaphores_upload_photos = [[NSMutableArray alloc]init];   // 没一个图片是一个上传线程，需要一个semaphores等待上传完成
    for (int index = 0; index < napPhotos.count; ++index) {
        dispatch_semaphore_t tmp = dispatch_semaphore_create(0);
        [semaphores_upload_photos addObject:tmp];
    }
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);              // 用户上传数据库信息
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
            NSDictionary* obj = nil;
            CURRENUSER(obj)
            NSDictionary* args = [obj mutableCopy];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[args objectForKey:@"user_id"]  forKey:@"owner_id"];
            [dic setObject:arr_items forKey:@"images"];
            
            NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
            [location setValue:[NSNumber numberWithFloat:napLoc.coordinate.latitude] forKey:@"latitude"];
            [location setValue:[NSNumber numberWithFloat:napLoc.coordinate.longitude] forKey:@"longtitude"];
            [dic setValue:location forKey:@"location"];
            
            [dic setValue:napTitle forKey:@"title"];
            [dic setValue:napDesc forKey:@"description"];
            [dic setValue:[NSNumber numberWithInt:2] forKey:@"capacity"];
            [dic setValue:[NSNumber numberWithFloat:napCost.floatValue] forKey:@"price"];
            [dic setValue:[NSNumber numberWithLong:napCostOptions] forKey:@"cans"];
            [dic setValue:[NSNumber numberWithLong:napDeviceOptons] forKey:@"facility"];
            [dic setValue:napAdress forKey:@"address"];
            if (areaString) {
                [dic setValue:areaString forKey:@"distinct"];
            }
            
            id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
            AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushServiceInfo"];
            [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                if (success) {
                    //发布服务需两步：1上传 -> 2发布
                    NSMutableDictionary *dic_publish = [[NSMutableDictionary alloc]init];
                    [dic_publish setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
                    [dic_publish setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
                    AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"PublishService"];
                    [cmd_publish performWithResult:[dic_publish copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                        if (success) {
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"服务发布成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                        }else {
                            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务发布失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                        }
                    }];
                } else {
                    NSLog(@"push error with:%@",result);
                    [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务上传失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                }
            }];
        } else {
            
        }
    });
    
}

- (void)updateMyService {
    NSDictionary* obj = nil;
    CURRENUSER(obj)
    NSDictionary* args = [obj mutableCopy];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[args objectForKey:@"user_id"]  forKey:@"owner_id"];
    
    [dic setValue:napTitle forKey:@"title"];
    [dic setValue:napDesc forKey:@"description"];
    [dic setValue:[NSNumber numberWithInt:2] forKey:@"capacity"];
    if (![napCost isEqualToString:@""] && napCost) {
        [dic setValue:[NSNumber numberWithFloat:napCost.floatValue] forKey:@"price"];
    }
    [dic setValue:[NSNumber numberWithLong:napCostOptions] forKey:@"cans"];
    [dic setValue:[NSNumber numberWithLong:napDeviceOptons] forKey:@"facility"];
    NSLog(@"push json:%@",dic);
    
    NSMutableDictionary *dic_revert = [[NSMutableDictionary alloc]init];
    [dic_revert setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
    [dic_revert setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"RevertMyService"];
    [cmd_push performWithResult:[dic_revert copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            //修改服务需两步：1 撤销服务 -> 2更新 -> 3再次发布
            [dic setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
            AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"UpdateMyService"];
            [cmd_publish performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                if (success) {
//                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"服务信息已更新" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                    NSMutableDictionary *dic_publish = [[NSMutableDictionary alloc]init];
                    [dic_publish setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
                    [dic_publish setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
                    AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"PublishService"];
                    [cmd_publish performWithResult:[dic_publish copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                        if (success) {
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"服务信息已更新发布成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                        }else {
                            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务信息已更新发布失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                        }
                    }];
                    
                }else {
                    [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务信息更新失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                }
            }];
        } else {
            NSLog(@"push error with:%@",result);
            if (((NSNumber*)[result objectForKey:@"code"]).intValue == -15) {
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"服务撤销失败,该服务状态错误！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
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
    
//    [[[UIAlertView alloc]initWithTitle:@"TIP" message:@"be readying..." delegate:nil cancelButtonTitle:@"cancerl" otherButtonTitles:nil, nil] show ];
    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
    NSMutableDictionary* dic_args = [[NSMutableDictionary alloc]init];
    [dic_args setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_args setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_args setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if (service_info) {
        [dic_args setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:napPhotos forKey:@"images"];
        
        NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
        [location setValue:[NSNumber numberWithFloat:napLoc.coordinate.latitude] forKey:@"latitude"];
        [location setValue:[NSNumber numberWithFloat:napLoc.coordinate.longitude] forKey:@"longtitude"];
        [dic setValue:location forKey:@"location"];
        
        [dic setValue:napTitle forKey:@"title"];
        [dic setValue:napDesc forKey:@"description"];
        [dic setValue:[NSNumber numberWithInt:2] forKey:@"capacity"];
        [dic setValue:[NSNumber numberWithFloat:napCost.floatValue] forKey:@"price"];
        [dic setValue:[NSNumber numberWithLong:napCostOptions] forKey:@"cans"];
        [dic setValue:[NSNumber numberWithLong:napDeviceOptons] forKey:@"facility"];
        [dic setValue:napAdress forKey:@"address"];
        if (areaString) {
            [dic setValue:areaString forKey:@"distinct"];
        }
        
        [dic_args setValue:dic forKey:kAYControllerChangeArgsKey];
    }
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic_args];
    
    return nil;
}

/*************************/
- (id)addPhotosAction {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"EditPhotos");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"push" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

-(id)inputNapTitleAction:(NSString*)args{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputNapTitle");
    
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
-(id)inputNapDescAction:(NSString*)args{
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

-(id)setNapBabyAges:(NSDictionary*)args{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"SetNapAges");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapCost:(NSDictionary*)args{
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapCost");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapAdress:(NSDictionary*)args{
    id<AYCommand> dest = DEFAULTCONTROLLER(@"InputNapAdress");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)setNapDevice:(NSDictionary*)args{
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}
/**********************/
-(id)sendRegMessage{
    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
    
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    [dic_show_module setValue:kAYControllerActionShowModuleValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULE;
    [cmd_show_module performWithResult:&dic_show_module];
    
    self.tabBarController.tabBar.hidden = YES;
    return nil;
}

@end
