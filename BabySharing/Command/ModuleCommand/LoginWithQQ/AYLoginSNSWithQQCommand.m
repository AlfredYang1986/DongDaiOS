//
//  AYLoginWithQQCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginSNSWithQQCommand.h"

@implementation AYLoginSNSWithQQCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
//    [self postPerform];
//    NSString* desController = [self.para objectForKey:@"controller"];
//    if (desController != nil) {
//        id<AYCommand> cmd = CONTROLLER(desController);
//        NSLog(@"cmd is : %@", cmd);
//        
//        *obj = cmd;
//    }
    *(obj) = @"login with QQ command perform";
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandInit;
}
@end
