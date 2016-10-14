//
//  AYProfileController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYProfileController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"
#import "AYProfileDefines.h"
#import "AYRemoteCallDefines.h"

#import "AYModelFacade.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#define STATUS_BAR_HEIGHT       20
#define FAKE_BAR_HEIGHT        44

#define QUERY_VIEW_MARGIN_LEFT      10.5
#define QUERY_VIEW_MARGIN_RIGHT     QUERY_VIEW_MARGIN_LEFT
#define QUERY_VIEW_MARGIN_UP        STATUS_BAR_HEIGHT
#define QUERY_VIEW_MARGIN_BOTTOM    0

#define HEADER_VIEW_HEIGHT          183

#define MARGIN_LEFT                 10.5
#define MARGIN_RIGHT                10.5

#define SEG_CTR_HEIGHT              49

@interface AYProfileController ()
@property (nonatomic, setter=setCurrentStatus:) RemoteControllerStatus status;
@end

@implementation AYProfileController {
    
    NSString* screen_name;
    NSDictionary* profile_dic;
    
//    id backArgs;
//    NSArray* post_content;
//    NSArray* push_content;
    
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
        if (backArgs) {
            
            NSDictionary *user_info = nil;
            CURRENPROFILE(user_info)
            
            AYViewController* des = DEFAULTCONTROLLER(@"TabBar");
            BOOL isNap = ![self.tabBarController isKindOfClass:[des class]];
            NSMutableDictionary *tmp = [user_info mutableCopy];
            [tmp setValue:[NSNumber numberWithBool:isNap] forKey:@"is_nap"];
            kAYDelegatesSendMessage(@"Profile", @"changeQueryData:", &tmp)
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
            
            if ([backArgs isKindOfClass:[NSString class]]) {
                
                NSString *title = (NSString*)backArgs;
                id<AYFacadeBase> f_alert = [self.facades objectForKey:@"Alert"];
                id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"ShowAlert"];
                
                NSMutableDictionary *dic_alert = [[NSMutableDictionary alloc]init];
                [dic_alert setValue:title forKey:@"title"];
                [dic_alert setValue:[NSNumber numberWithInt:2] forKey:@"type"];
                [cmd_alert performWithResult:&dic_alert];
            }
            
        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Profile"];
        
        id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithNib:"];
        NSString* nib_name = @"AYProfileHeadCellView";
        [cmd_cell performWithResult:&nib_name];
        
        id<AYCommand> cmd_class = [view_notify.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name = @"AYProfileOrigCellView";
        [cmd_class performWithResult:&class_name];
        
        AYViewController* des = DEFAULTCONTROLLER(@"TabBar");
        BOOL isNap = ![self.tabBarController isKindOfClass:[des class]];
//        NSNumber *args = [NSNumber numberWithBool:isNap];
//        kAYDelegatesSendMessage(@"Profile", @"changeModel:", &args)
        
        NSDictionary *user_info = nil;
        CURRENPROFILE(user_info)
        
        NSMutableDictionary *tmp = [user_info mutableCopy];
        [tmp setValue:[NSNumber numberWithBool:isNap] forKey:@"is_nap"];
        kAYDelegatesSendMessage(@"Profile", @"changeQueryData:", &tmp)
    }
    
//    id<AYFacadeBase> remote = [self.facades objectForKey:@"ProfileRemote"];
//    AYRemoteCallCommand* cmd = [remote.commands objectForKey:@"QueryUserProfile"];
//    NSDictionary* user = nil;
//    CURRENUSER(user);
//    
//    NSMutableDictionary* dic = [user mutableCopy];
//    [dic setValue:[user objectForKey:@"user_id"]  forKey:@"owner_user_id"];
    
//    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//        if (success) {
//            id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Profile"];
//            id<AYCommand> cmd = [cmd_notify.commands objectForKey:@"changeQueryData:"];
//            
//            NSDictionary *dic = [result copy];
//            [cmd performWithResult:&dic];
//            
//            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
//            id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
//            [refresh performWithResult:nil];
//        }
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left_vis = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    [cmd_left_vis performWithResult:&left_hidden];
    
    NSString *title = @"我的";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    [cmd_bot performWithResult:nil];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTabBarH);
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    //    ((UITableView*)view).style = UITableViewStyleGrouped;
    return nil;
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
    
    return nil;
}

//- (id)queryModel:(id)args {
//    
//    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
//    BOOL isNap = [self.tabBarController isKindOfClass:[des class]];
//    args = [NSNumber numberWithBool:isNap];
//    return args;
//}

//- (id)queryIsGridSelected:(id)obj {
//    //    NSInteger index = ((NSNumber*)obj).integerValue;
//    return [NSNumber numberWithBool:NO];
//}

//- (id)SamePersonBtnSelected {
//    
//    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
//    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
//    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
//    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:profile_dic forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd = PUSH;
//    [cmd performWithResult:&dic_push];
//    return nil;
//}
//
//- (id)relationChanged:(id)args {
//    NSNumber* new_relations = (NSNumber*)args;
//    NSLog(@"new relations %@", new_relations);
//    
//    id<AYViewBase> view_header = [self.views objectForKey:@"ProfileHeader"];
//    id<AYCommand> cmd = [view_header.commands objectForKey:@"changeRelations:"];
//    [cmd performWithResult:&new_relations];
//    
//    return nil;
//}

- (id)sendRegMessage:(NSNumber*)type {
    
    AYViewController* compare = DEFAULTCONTROLLER(@"TabBar");
    BOOL isNap = ![self.tabBarController isKindOfClass:[compare class]];
    
    AYViewController *des;
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    
    if (isNap) {
        des = compare;
        //    [dic_show_module setValue:kAYControllerActionShowModuleValue forKey:kAYControllerActionKey];
        [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
        [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
        [dic_show_module setValue:[NSNumber numberWithInteger:ProfileModelServiceToCommon] forKey:kAYControllerChangeArgsKey];
        
    } else {
        des = DEFAULTCONTROLLER(@"TabBarService");
        //    [dic_show_module setValue:kAYControllerActionShowModuleValue forKey:kAYControllerActionKey];
        [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
        [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
        [dic_show_module setValue:[NSNumber numberWithInteger:ProfileModelServicePersonal] forKey:kAYControllerChangeArgsKey];
        
    }
    
    id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
    [cmd_show_module performWithResult:&dic_show_module];
    return nil;
}
#pragma mark -- status

@end
