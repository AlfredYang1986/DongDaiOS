//
//  AYLandingReqConfirmCode.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingReqConfirmCodeCommand.h"
#import "AYCommandDefines.h"

@implementation AYLandingReqConfirmCodeCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"request confirm code from sever: %@", *obj);
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandModule;
}
@end
