//
//  AYFoundInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundInitCommand.h"

#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"

@implementation AYFoundInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    UIViewController* controller = DEFAULTCONTROLLER(@"Found");
    
    AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
    [rootContorller pushViewController:controller animated:NO];
   
    [rootContorller setNavigationBarHidden:YES animated:NO];
    *obj = rootContorller;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
