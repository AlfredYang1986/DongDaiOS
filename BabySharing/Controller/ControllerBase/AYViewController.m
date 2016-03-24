//
//  AYViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"
#import "AYCommandDefines.h"
#import <objc/runtime.h>

@implementation AYViewController
@synthesize para = _para;

@synthesize commands = _commands;
@synthesize views = _views;
@synthesize facades = _facades;

- (NSString*)getControllerName {
//    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"Landing"] stringByAppendingString:kAYFactoryManagerControllersuffix];
    return NSStringFromClass([self class]);
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor redColor];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    *obj = self;
}
@end
