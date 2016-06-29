//
//  AYEMClientInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 6/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEMClientInitCommand.h"

@implementation AYEMClientInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
