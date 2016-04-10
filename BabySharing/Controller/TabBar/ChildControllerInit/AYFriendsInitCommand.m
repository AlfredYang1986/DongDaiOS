//
//  AYFriendsInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFriendsInitCommand.h"

#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"
// test
#import "AYPlaceHolderTabBarController.h"

@implementation AYFriendsInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    UIViewController* controller = [[AYPlaceHolderTabBarController alloc]init];
    controller.view.backgroundColor = [UIColor greenColor];
    
    AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
    [rootContorller pushViewController:controller animated:NO];
    
    *obj = rootContorller;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
