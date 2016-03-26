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
#import "AYNotifyDefines.h"

@implementation AYDefaultControllerFactoy

@synthesize para = _para;

+ (id)factoryInstance {
//    static AYDefaultControllerFactoy* instance = nil;
//    if (instance == nil) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            instance = [[self alloc]init];
//        });
//    }
//    return instance;
    return [[self alloc]init];
}

- (id)createInstance {
    NSLog(@"para is : %@", _para);
    NSDictionary* cmds = [_para objectForKey:@"commands"];
    for (id<AYCommand> cmd in cmds.allValues) {
        [cmd postPerform];
    }

    NSDictionary* facades = [_para objectForKey:@"facades"];
    NSDictionary* views = [_para objectForKey:@"views"];
   
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
        
        if (views)
            controller.views = views;
        
    }
    
    NSMutableDictionary* reg = [[NSMutableDictionary alloc]init];
    [reg setValue:kAYNotifyActionKeyReceive forKey:kAYNotifyActionKey];
    [reg setValue:kAYNotifyFunctionKeyRegister forKey:kAYNotifyActionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:controller forKey:kAYNotifyControllerKey];
    
    [reg setValue:[args copy] forKey:kAYNotifyArgsKey];
//    [args setValue:controller.controller_name forKey:kAYNotifyControllerKey];
    for (id<AYCommand> facade in facades) {
        [facade performWithResult:&reg];
    }
    
    return controller;
}
@end
