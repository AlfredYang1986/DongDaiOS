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
    if ([self checkForArgs]) {
        NSLog(@"request confirm code from sever: %@", _para);
    }
}

- (BOOL)checkForArgs {
//    return _para != nil && [_para.allKeys containsObject:@"user_id"] && [_para.allKeys containsObject:@"auth_token"] && [_para.allKeys containsObject:@"phoneNo"];
    return _para != nil && [_para.allKeys containsObject:@"phoneNo"];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandModule;
}
@end
