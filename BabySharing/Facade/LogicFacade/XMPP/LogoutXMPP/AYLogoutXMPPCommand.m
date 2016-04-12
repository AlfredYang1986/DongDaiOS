//
//  AYLogoutXMPPCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLogoutXMPPCommand.h"
#import "GotyeOCAPI.h"

@implementation AYLogoutXMPPCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    [GotyeOCAPI logout];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
