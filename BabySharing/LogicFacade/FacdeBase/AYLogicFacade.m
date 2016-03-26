//
//  AYLogicFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLogicFacade.h"
#import "AYCommandDefines.h"
#import <objc/runtime.h>
#import "AYNotifyDefines.h"

@implementation AYLogicFacade

@synthesize para = _para;
@synthesize commands = _commands;
@synthesize observer = _observer;

- (NSString*)getFacadeType {
    return kAYFactoryManagerCatigoryFacade;
}

- (NSString*)getFacadeName {
    return NSStringFromClass([self class]);
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryFacade;
}

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    if (obj == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"you should have args" userInfo:nil];
    }
    
    NSDictionary* dic = ((NSDictionary*)*obj);
    
    if ([[dic objectForKey:kAYNotifyActionKey] isEqualToString:kAYNotifyActionKeyReceive]) {
        NSDictionary* args = [dic objectForKey:kAYNotifyArgsKey];
        NSString* message_name = [dic objectForKey:kAYNotifyFunctionKey];
        
        id result = nil;
        [self receiveMessage:message_name andArgs:args withResult:&result];
        *obj = result;
    } else {
        NSString* notify_name = [dic objectForKey:kAYNotifyFunctionKey];
        NSString* notify_target = [dic objectForKey:kAYNotifyTargetKey];
        
        [self sendNotification:notify_name andName:notify_target];
    }
}

/**
 * 巨大的表驱动
 */
- (void)receiveMessage:(NSString*)message_name andArgs:(NSDictionary*)args withResult:(id*)obj {
    if ([message_name isEqualToString:kAYNotifyFunctionKeyRegister]) {
        [_observer addObject:[args objectForKey:kAYNotifyControllerKey]];
        NSLog(@"observers are : %@", _observer);
        
    } else if ([message_name isEqualToString:kAYNotifyFunctionKeyUnregister]) {
        [_observer removeObject:[args objectForKey:kAYNotifyControllerKey]];
        NSLog(@"observers are : %@", _observer);
    }
}

- (void)sendNotification:(NSString*)message_name andName:(NSString*)target {
    for (NSObject * controller  in _observer) {
        SEL sel = NSSelectorFromString(message_name);
        Method m = class_getInstanceMethod([controller class], sel);
        if (m) {
            IMP imp = method_getImplementation(m);
            id (*func)(id, SEL, ...) = imp;
            func(controller, sel);
        }
    }
}
@end
