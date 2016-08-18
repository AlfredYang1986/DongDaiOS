//
//  AYProfileServiceInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 12/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCalendarServiceInitCommand.h"
#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYNavigationServiceController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"

@implementation AYCalendarServiceInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    UIViewController* controller = CONTROLLER(@"DefaultController", @"CalendarService");
    
    AYNavigationServiceController * rootContorller = CONTROLLER(@"DefaultController", @"NavigationService");
    [rootContorller pushViewController:controller animated:NO];
    
    [rootContorller setNavigationBarHidden:YES animated:NO];
    *obj = rootContorller;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
