//
//  AYOrderInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 11/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInitCommand.h"
#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"
#import "AppDelegate.h"

@implementation AYOrderInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    UIViewController* controller = CONTROLLER(@"DefaultController", @"OrderService");
    
    AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
    [rootContorller pushViewController:controller animated:NO];
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
    
//    AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
//    [rootContorller pushViewController:controller animated:NO];
//    
//    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
//    [self.window makeKeyAndVisible];
//    
//    self.window.rootViewController = rootContorller;
    
    [rootContorller setNavigationBarHidden:YES animated:NO];
    *obj = rootContorller;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
