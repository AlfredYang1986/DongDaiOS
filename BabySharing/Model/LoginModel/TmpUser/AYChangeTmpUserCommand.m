//
//  AYChangeTmpUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChangeTmpUserCommand.h"
#import "AYCommandDefines.h"

@implementation AYChangeTmpUserCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change tmp user in local db: %@", *obj);
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
