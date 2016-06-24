//
//  AYEMEnterFrontCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 6/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEMEnterFrontCommand.h"
#import "EMSDK.h"
#import "EMError.h"

@implementation AYEMEnterFrontCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    [[EMClient sharedClient] applicationWillEnterForeground:[UIApplication sharedApplication]];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
