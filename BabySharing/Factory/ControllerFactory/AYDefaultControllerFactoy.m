//
//  AYDefaultControllerFactoy.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDefaultControllerFactoy.h"
#import "AYCommandDefines.h"
#import "AYCommand.h"
#import "AYControllerBase.h"

@implementation AYDefaultControllerFactoy

@synthesize para = _para;

- (id)createInstance {
    NSLog(@"para is : %@", _para);
    NSDictionary* cmds = [_para objectForKey:@"commands"];
    for (id<AYCommand> cmd in cmds.allValues) {
        [cmd postPerform];
    }

    NSDictionary* facades = [_para objectForKey:@"facades"];
   
    id<AYControllerBase> controller = nil;
    NSString* desController = [self.para objectForKey:@"controller"];
    Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desController] stringByAppendingString:kAYFactoryManagerControllersuffix]);
    if (c == nil) {
        @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
    } else {
        controller = [[c alloc]init];
       
        if (cmds)
            controller.commands = cmds;

        if (facades)
            controller.facades = facades;
        
    }
    
    return controller;
}
@end
