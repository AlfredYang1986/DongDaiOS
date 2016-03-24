//
//  AYLogicFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLogicFacade.h"
#import "AYCommandDefines.h"

@implementation AYLogicFacade

@synthesize para = _para;
@synthesize commands = _commands;

- (NSString*)getFacadeType {
    return kAYFactoryManagerCatigoryFacade;
}

- (NSString*)getFacadeName {
    return NSStringFromClass([self class]);
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryFacade;
}

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    *obj = self;
}
@end
