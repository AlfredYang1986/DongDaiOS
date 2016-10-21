//
//  AppDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "AYFactoryManager.h"
#import "AYCommand.h"
#import "AYFacade.h"
#import "AYCommandDefines.h"
#import "AYViewController.h"
#import "AYNavigationController.h"

#import "TencentOAuth.h"
#import "WXApi.h"
#import "WeiboSDK.h"

#import "EMSDK.h"
#import "EMError.h"

static NSString* const kAYEMAppKey = @"blackmirror#dongda";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    NSLog(@"项目路径 ======= %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);

    [NSThread sleepForTimeInterval:2.5f];
    
    EMOptions *options = [EMOptions optionsWithAppkey:kAYEMAppKey];
    //    options.apnsCertName = @"istore_dev";
    EMError* error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (error) {
        NSLog(@"error is : %d", error.code);
        @throw [[NSException alloc]initWithName:@"error" reason:@"register EM Error" userInfo:nil];
    }
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
  
    /**
     * create dongda model
     */
    id<AYCommand> model = MODEL;
    [model postPerform];
    
    /**
     * create controller factory
     */
    id<AYCommand> cmd = COMMAND(kAYFactoryManagerCommandTypeInit, kAYFactoryManagerCommandTypeInit);
    AYViewController* controller = nil;
    [cmd performWithResult:&controller];
    
    /**
     * apn notification factory
     */
    id<AYCommand> apn = COMMAND(kAYFactoryManagerCommandTypeAPN, kAYFactoryManagerCommandTypeAPN);
    [apn performWithResult:nil];
    
    /**
     * Navigation Controller
     */
    AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
    [rootContorller pushViewController:controller animated:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = rootContorller;
    
    return YES;
}

#pragma mark -- life cycle
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  
    AYFacade* em = DEFAULTFACADE(@"EM");
    id<AYCommand> cmd = [em.commands objectForKey:@"EMEnterBackground"];
    [cmd performWithResult:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    AYFacade* em = DEFAULTFACADE(@"EM");
    id<AYCommand> cmd = [em.commands objectForKey:@"EMEnterFront"];
    [cmd performWithResult:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- notification callback
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //    UIUserNotificationSettings *settings = [application currentUserNotificationSettings];
    //    UIUserNotificationType types = [settings types];
    //    //只有5跟7的时候包含了 UIUserNotificationTypeBadge
    //    if (types == 5 || types == 7) {
    //        application.applicationIconBadgeNumber = 0;
    //    }
    //注册远程通知
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString* apn_token = [NSString stringWithFormat:@"%@",(NSString*)deviceToken];
    apn_token = [apn_token stringByReplacingOccurrencesOfString:@" " withString:@""];
    apn_token = [apn_token lowercaseString];
    apn_token = [apn_token substringToIndex:apn_token.length-1];
    apn_token = [apn_token substringFromIndex:1];
    NSLog(@"My token is: %@", apn_token);
    id<AYCommand> apn = COMMAND(kAYFactoryManagerCommandTypeAPN, kAYFactoryManagerCommandTypeAPN);
    [apn pushCommandPara:apn_token withName:@"apn_token"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification : %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -- coredata version control

#pragma mark -- open sns url
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    id<AYCommand> weibo_delegate = DEFAULTFACADE(@"SNSWeibo");
    id<AYCommand> wechat_delegate = DEFAULTFACADE(@"SNSWechat");
    
    return [TencentOAuth HandleOpenURL:url] ||
        [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)weibo_delegate] ||
        [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)wechat_delegate];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    id<AYCommand> weibo_delegate = DEFAULTFACADE(@"SNSWeibo");
    id<AYCommand> wechat_delegate = DEFAULTFACADE(@"SNSWechat");
   
    return [TencentOAuth HandleOpenURL:url] ||
        [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)weibo_delegate] ||
        [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)wechat_delegate];
}
@end
