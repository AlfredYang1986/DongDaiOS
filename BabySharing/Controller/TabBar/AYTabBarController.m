//
//  AYTabBarController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTabBarController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "DongDaTabBar.h"
#import "AYViewController.h"

#define SHOWALBUM       [self showPostController:@"CameraRollInit"]
#define SHOWCAMERA      [self showPostController:@"CameraInit"]
#define SHOWMOVIEW      [self showPostController:@"MOVIEInit"]

@interface AYTabBarController () <UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation AYTabBarController {

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
    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TabBar"] stringByAppendingString:kAYFactoryManagerControllersuffix];
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    id<AYCommand> cmd_home_init = [self.commands objectForKey:@"HomeInit"];
    AYViewController* home = nil;
    [cmd_home_init performWithResult:&home];
    home.tabBarItem.title = @"Home";
    
    id<AYCommand> cmd_found_init = [self.commands objectForKey:@"FoundInit"];
    AYViewController* found = nil;
    [cmd_found_init performWithResult:&found];
    found.tabBarItem.title = @"Found";
   
    id<AYCommand> cmd_post_init = [self.commands objectForKey:@"PlaceHolderInit"];
    AYViewController* post = nil;
    [cmd_post_init performWithResult:&post];
    post.tabBarItem.title = @"Post";

    id<AYCommand> cmd_friends_init = [self.commands objectForKey:@"FriendsInit"];
    AYViewController* friends = nil;
    [cmd_friends_init performWithResult:&friends];
    friends.tabBarItem.title = @"Friends";

    id<AYCommand> cmd_profile_init = [self.commands objectForKey:@"ProfileInit"];
    AYViewController* profile = nil;
    [cmd_profile_init performWithResult:&profile];
    profile.tabBarItem.title = @"Profile";
    
    self.viewControllers = [NSArray arrayWithObjects:home, found, post, friends, profile, nil];
    
    self.delegate = self;
    
    img_home_with_no_message = PNGRESOURCE(@"tab_home");
    img_home_with_unread_message = PNGRESOURCE(@"tab_home_unread");
    
    dongda_tabbar = [[DongDaTabBar alloc]initWithBar:self];
    [dongda_tabbar addItemWithImg:img_home_with_no_message andSelectedImg:PNGRESOURCE(@"tab_home_selected") andTitle:@"主页"];
    [dongda_tabbar addItemWithImg:PNGRESOURCE(@"tab_found") andSelectedImg:PNGRESOURCE(@"tab_found_selected") andTitle:@"发现"];
    [dongda_tabbar addMidItemWithImg:PNGRESOURCE(@"tab_publish")];
    [dongda_tabbar addItemWithImg:PNGRESOURCE(@"tab_friends") andSelectedImg:PNGRESOURCE(@"tab_friends_selected") andTitle:@"好友"];
    [dongda_tabbar addItemWithImg:PNGRESOURCE(@"tab_profile") andSelectedImg:PNGRESOURCE(@"tab_profile_selected") andTitle:@"我的"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    }
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        NSNumber* index = [dic objectForKey:kAYControllerChangeArgsKey];
        switch (index.integerValue) {
            case 0:
                SHOWALBUM;
                break;
            case 1:
                SHOWCAMERA;
                break;
            case 2:
                break;
                
            default:
                @throw [[NSException alloc]initWithName:@"error" reason:@"wrong args" userInfo:nil];
                break;
        }
        
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
    
    if ([item.title isEqualToString:@"Post"]) {
//        SHOWALBUM;
        SHOWCAMERA;
        
    } else {
//        int count = [GotyeOCAPI getTotalUnreadMessageCount];
//        if (count > 0) {
//            [dongda_tabbar changeItemImage:img_home_with_unread_message andIndex:0];
//        } else {
//            [dongda_tabbar changeItemImage:img_home_with_no_message andIndex:0];
//        }
    }
}

#pragma marks - tabbar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Post"]) {
        return NO;
    }
    
//    if (backView.hidden == NO) {
//        return NO;
//    }
    
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
