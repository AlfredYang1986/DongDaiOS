//
//  AYNavigationController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYNavigationController.h"
#import "AYCommandDefines.h"

@implementation AYNavigationController
@synthesize para = _para;

@synthesize commands = _commands;
@synthesize facades = _facades;
@synthesize views = _views;

- (NSString*)getControllerName {
    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"Navigation"] stringByAppendingString:kAYFactoryManagerControllersuffix];
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    *obj = self;
}

- (void)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {

}
@end
