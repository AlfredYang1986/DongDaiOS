//
//  AYTabBarServiceController.m
//  BabySharing
//
//  Created by Alfred Yang on 11/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYTabBarServiceController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "DongDaTabBar.h"
#import "AYViewController.h"

@interface AYTabBarServiceController () <UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation AYTabBarServiceController{
    
    DongDaTabBar* dongda_tabbar;
    UIImage* img_home_with_no_message;
    UIImage* img_home_with_unread_message;
}

@synthesize para = _para;

@synthesize commands = _commands;
@synthesize facades = _facades;
@synthesize views = _views;
@synthesize delegates = _delegates;

#pragma mark -- commands
- (NSString*)getControllerName {
    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TabBarService"] stringByAppendingString:kAYFactoryManagerControllersuffix];
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    id<AYCommand> cmd_order_init = [self.commands objectForKey:@"OrderInit"];
    AYViewController* order = nil;
    [cmd_order_init performWithResult:&order];
    order.tabBarItem.title = @"订单";
    
    id<AYCommand> cmd_message_init = [self.commands objectForKey:@"MessageServiceInit"];
    AYViewController* message = nil;
    [cmd_message_init performWithResult:&message];
    message.tabBarItem.title = @"消息";
    
    id<AYCommand> cmd_calendar_init = [self.commands objectForKey:@"CalendarServiceInit"];
    AYViewController* calendar = nil;
    [cmd_calendar_init performWithResult:&calendar];
    calendar.tabBarItem.title = @"日程";
    
    id<AYCommand> cmd_profile_init = [self.commands objectForKey:@"ProfileServiceInit"];
    AYViewController* profile = nil;
    [cmd_profile_init performWithResult:&profile];
    profile.tabBarItem.title = @"我的";
    
    //    self.viewControllers = [NSArray arrayWithObjects:home, found, post, friends, profile, nil];
    self.viewControllers = [NSArray arrayWithObjects:order, message, calendar, profile, nil];
    
    self.delegate = self;
    
    img_home_with_no_message = IMGRESOURCE(@"tab_home");
    img_home_with_unread_message = IMGRESOURCE(@"tab_home_unread");
    
    dongda_tabbar = [[DongDaTabBar alloc]initWithBar:self];
    [dongda_tabbar addItemWithImg:img_home_with_no_message andSelectedImg:IMGRESOURCE(@"tab_home_selected") andTitle:@"订单"];
    [dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_found") andSelectedImg:IMGRESOURCE(@"tab_found_selected") andTitle:@"消息"];
    [dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_message") andSelectedImg:IMGRESOURCE(@"tab_message_selected") andTitle:@"日程"];
    [dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_profile") andSelectedImg:IMGRESOURCE(@"tab_profile_selected") andTitle:@"我的"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    }
    
//    dongda_tabbar.selectIndex = 1;
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (id)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {
    @throw [[NSException alloc]initWithName:@"error" reason:@"不要在苹果自建Controller中调用Command函数" userInfo:nil];
}

- (id)startRemoteCall:(id)obj {
    return nil;
}

- (id)endRemoteCall:(id)obj {
    return nil;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -- tabbar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"select tab %@", item.title);
    
}

#pragma marks - tabbar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Post"]) {
        return NO;
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
    for (UIViewController * iter in viewControllers) {
        NSLog(@"%@", iter.title);
    }
}

#pragma mark -- actions
- (void)showPostController:(NSString*)name {
    
    AYViewController* des = nil; //
    id<AYCommand> cmd = [self.commands objectForKey:name];
    [cmd performWithResult:&des];
    
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    [dic_show_module setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic_show_module];
}
@end
