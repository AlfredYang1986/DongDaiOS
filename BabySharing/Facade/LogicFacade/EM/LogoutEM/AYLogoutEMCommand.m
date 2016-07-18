//
//  AYLogoutXMPPCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLogoutEMCommand.h"
//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"

@implementation AYLogoutEMCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
//    [GotyeOCAPI logout];
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"环信: 退出成功");
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
