//
//  AYCollectServController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMyServiceController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYMyServiceController

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
        if (backArgs) {
            
            [self syncQueryData];
            
            if ([backArgs isKindOfClass:[NSString class]]) {
                
                NSString *title = (NSString*)backArgs;
                id<AYFacadeBase> f_alert = DEFAULTFACADE(@"Alert");
                id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"ShowAlert"];
                
                NSMutableDictionary *dic_alert = [[NSMutableDictionary alloc]init];
                [dic_alert setValue:title forKey:@"title"];
                [dic_alert setValue:[NSNumber numberWithInt:2] forKey:@"type"];
                [cmd_alert performWithResult:&dic_alert];
            }
            //backargs if end
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"MyService"];
    
    id obj = (id)cmd_collect;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_collect;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"MyServiceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
    ((UITableView*)view_table).mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    
    [self syncQueryData];
}

- (void)syncQueryData {
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[info objectForKey:@"user_id"]  forKey:@"owner_id"];
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"QueryMyService"];
    [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            NSArray *data = [result objectForKey:@"result"];
            kAYDelegatesSendMessage(@"MyService", @"changeQueryData:", &data)
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
            
        } else {
            NSString *title = @"请检查网络链接是否正常";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
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
    
    NSString *title = @"我的服务";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnVisibility:", &left_hidden);
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnVisibility:", &right_hidden);
    
    kAYViewsSendMessage(@"FakeNavBar", @"setBarBotLine", nil);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 , SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

#pragma mark -- actions
- (void)loadRefreshData {
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[info objectForKey:@"user_id"]  forKey:@"owner_id"];
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"QueryMyService"];
    [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            NSArray *data = [result objectForKey:@"result"];
            kAYDelegatesSendMessage(@"MyService", @"changeQueryData:", &data)
            kAYViewsSendMessage(@"Table", @"refresh", nil)
            
        } else {
            NSString *title = @"请检查网络链接是否正常";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        [((UITableView*)view_table).mj_header endRefreshing];
    }];
    
}


- (void)didPushNewSerBtnClick {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:@"" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)didManagerBtnClick:(id)args {
    
    id<AYCommand> setting = DEFAULTCONTROLLER(@"SetNapSchedule");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

@end
