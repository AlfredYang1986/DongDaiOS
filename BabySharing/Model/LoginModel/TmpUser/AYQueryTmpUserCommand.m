//
//  AYQueryTmpUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryTmpUserCommand.h"
#import "AYCommandDefines.h"

@implementation AYQueryTmpUserCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user in local db: %@", *obj);
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandModule;
}
@end
