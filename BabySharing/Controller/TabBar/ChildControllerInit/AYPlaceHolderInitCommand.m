//
//  AYPlaceHolderInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPlaceHolderInitCommand.h"

#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"
// test
#import "AYPlaceHolderTabBarController.h"

@implementation AYPlaceHolderInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    *obj = [[AYPlaceHolderTabBarController alloc]init];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
