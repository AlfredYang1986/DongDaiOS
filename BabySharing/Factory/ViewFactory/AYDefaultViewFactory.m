//
//  AYDefaultViewFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDefaultViewFactory.h"
//#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYViewBase.h"
#import "AYViewCommand.h"

@implementation AYDefaultViewFactory

@synthesize para = _para;

+ (id)factoryInstance {
//    static AYDefaultViewFactory* instance = nil;
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
    
    NSString* desFacade = [self.para objectForKey:@"view"];
    id<AYViewBase> result = nil;

    Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desFacade] stringByAppendingString:kAYFactoryManagerViewsuffix]);
    if (c == nil) {
        @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
    } else {
        result = [[c alloc]init];
        [result postPerform];
    }
   
    NSDictionary* cmds = [_para objectForKey:@"commands"];
    NSMutableDictionary* commands = [[NSMutableDictionary alloc]initWithCapacity:cmds.count];
    for (NSString* cmd in cmds) {
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = result;
        c.method_name = cmd;
        [commands setObject:c forKey:cmd];
    }
    
    result.commands = [commands copy];
    return result;
}
@end
