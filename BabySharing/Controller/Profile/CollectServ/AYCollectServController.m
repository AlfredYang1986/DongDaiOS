//
//  AYCollectServController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCollectServController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

@interface AYCollectServController ()

@end

@implementation AYCollectServController{
    
    int serviceType; //0收藏的服务 /1自己发布的服务
    
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        serviceType = ((NSNumber*)[dic objectForKey:kAYControllerChangeArgsKey]).intValue;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"CollectServ"];
    
    id obj = (id)cmd_collect;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_collect;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"CLResultCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    
    if (serviceType == 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[info objectForKey:@"user_id"]  forKey:@"owner_id"];
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"QueryMyService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                id<AYCommand> cmd_change_data = [cmd_collect.commands objectForKey:@"changeQueryData:"];
                NSArray *data = [result objectForKey:@"result"];
                [cmd_change_data performWithResult:&data];
                
                id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
                [refresh performWithResult:nil];
                
            } else {
                NSLog(@"push error with:%@",result);
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请改善网络环境并重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
//                NSString *title = @"请改善网络环境并重试";
//                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
        
        UIButton *confirmSerBtn = [[UIButton alloc]init];
        confirmSerBtn.backgroundColor = [Tools themeColor];
        [confirmSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:confirmSerBtn];
        [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        [confirmSerBtn setTitle:@"发布新服务" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(conmitMyService) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"AllCollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
                NSArray *data = [result objectForKey:@"result"];
                if (data.count == 0) {
                    NSString *title = @"您还没有收藏过服务";
                    AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
                } else {
                    kAYDelegatesSendMessage(@"CollectServ", @"changeQueryData:", &data)
                    kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
                }
            } else {
                
                NSString *title = @"请改善网络环境并重试";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = (serviceType == 1) ? @"我发布的服务" : @"我心仪的服务";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_left_vis = [((id<AYViewBase>)view).commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    [cmd_left_vis performWithResult:&left_hidden];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 , SCREEN_WIDTH, SCREEN_HEIGHT - 64 - (serviceType == 1?44:0));
    return nil;
}

#pragma mark -- actions
- (void)conmitMyService {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:@"" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (id)ownerIconTap:(id)args {
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end
