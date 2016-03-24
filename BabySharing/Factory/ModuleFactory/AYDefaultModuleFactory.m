//
//  AYDefaultModuleFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDefaultModuleFactory.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"

@implementation AYDefaultModuleFactory {
    id<AYCommand> cmd; // = [[NSMutableDictionary alloc]init];
}

@synthesize para = _para;

- (id)createInstance {
    NSLog(@"para is : %@", _para);
    
    if (cmd == nil) {
        
        NSString* desCmd = [self.para objectForKey:@"name"];
        id<AYCommand> result = nil;
        
//        NSDictionary* cmds = [_para objectForKey:@"commands"];
//        for (id<AYCommand> subcmd in cmds.allValues) {
//            [subcmd postPerform];
//        }
        
        NSLog(@"%@ is creating", desCmd);
        
        Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desCmd] stringByAppendingString:kAYFactoryManagerCatigoryCommand]);
        if (c == nil) {
            @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
        } else {
            result = [[c alloc]init];
//            result.commands = cmds;
            cmd = result;
        }
    }
    return cmd;
}
@end
