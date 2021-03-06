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
#import "AYRemoteCallDefines.h"

#import "AYNavigationController.h"

#import "AYModelFacade.h"

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
			if ([backArgs isKindOfClass:[NSString class]]) {
				NSString *title = (NSString*)backArgs;
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			} else {
			}
			
            NSDictionary *user_info = nil;
            CURRENPROFILE(user_info)
            
			DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
			BOOL isServantMode = mode == DongDaAppModeServant;
			
            NSMutableDictionary *tmp = [user_info mutableCopy];
            [tmp setValue:[NSNumber numberWithBool:isServantMode] forKey:@"is_nap"];
            kAYDelegatesSendMessage(@"Profile", @"changeQueryData:", &tmp)
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			
        }//
    }
}

- (void)BtmAlertOtherBtnClick {
    [super BtmAlertOtherBtnClick];
    
	DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
	BOOL isServantMode = mode == DongDaAppModeServant;
	
    if (isServantMode) {
        [super tabBarVCSelectIndex:2];
        
    } else {
        
        AYViewController *des = DEFAULTCONTROLLER(@"TabBarService");
        NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
        [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
        [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
        
        NSMutableDictionary *dic_exchange = [[NSMutableDictionary alloc]init];
        [dic_exchange setValue:[NSNumber numberWithInteger:2] forKey:@"index"];
        [dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeCommonToServant] forKey:@"type"];
        [dic_show_module setValue:dic_exchange forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
        [cmd_show_module performWithResult:&dic_show_module];
    }
    
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Profile"];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	NSString* class_name = @"AYProfileHeadCellView";
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
	class_name = @"AYProfileOrigCellView";
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    class_name = @"AYProfilePublishCellView";
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
	
	NSDictionary *user_info = nil;
	CURRENPROFILE(user_info)
	NSMutableDictionary *tmp = [user_info mutableCopy];
	
	DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
	BOOL isServantMode = mode == DongDaAppModeServant;
    if ([@"Alfred" isEqualToString:[tmp valueForKey:@"screen_name"]]) isServantMode = true;
	[tmp setValue:[NSNumber numberWithBool:isServantMode] forKey:@"is_nap"];
	kAYDelegatesSendMessage(@"Profile", @"changeQueryData:", &tmp)
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
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor garyBackground];
    return nil;
    
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor garyBackground];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:@"exchange"]) {
        
        NSString *s = [userDefaults valueForKey:@"exchange"];
        
        if ([s isEqual:@"switchToService"]) {
            
            NSNumber *num = [NSNumber numberWithBool:YES];
            
            kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &num)
            
            [userDefaults setObject:@"switchedToService" forKey:@"exchange"];
            [userDefaults synchronize];
            
        }
        
        
    }
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH + kNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kTabBarH);
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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

- (id)sendRegMessage:(NSNumber*)type {
	
	DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
	BOOL isServantMode = mode == DongDaAppModeServant;
	
    AYViewController *des;
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
    NSMutableDictionary *dic_exchange = [[NSMutableDictionary alloc]init];
    AYNavigationController *nav = DEFAULTCONTROLLER(@"Navigation");
    
    if (isServantMode) {
        
//        des = DEFAULTCONTROLLER(@"TabBar");
//        [dic_exchange setValue:[NSNumber numberWithInteger:3] forKey:@"index"];
//        [dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeServantToCommon] forKey:@"type"];
        
        
    } else {
        
        //des = DEFAULTCONTROLLER(@"TabBarService");
        des = DEFAULTCONTROLLER(@"Home");
        [nav pushViewController:des animated:YES];
        NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
        [defaults setInteger:DongDaAppModeServant forKey:kAYDongDaAppMode];
        [defaults synchronize];
        
        [dic_exchange setValue:[NSNumber numberWithInteger:3] forKey:@"index"];
        [dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeCommonToServant] forKey:@"type"];
        
    }
    
    [dic_show_module setValue:dic_exchange forKey:kAYControllerChangeArgsKey];
    [dic_show_module setValue:nav forKey:kAYControllerActionDestinationControllerKey];
    
    id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
    [cmd_show_module performWithResult:&dic_show_module];
    return nil;
}
#pragma mark -- status

@end
