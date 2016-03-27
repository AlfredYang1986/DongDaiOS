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

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"request confirm code from sever: %@", args);
    [NSThread sleepForTimeInterval:2.f];
    //TODO: notifycation;
    block(YES, nil);
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
