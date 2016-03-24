//
//  AYDefaultFacadeFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDefaultFacadeFactory.h"
//#import "AYLogicFacade.h"
#import "AYFacadeBase.h"
#import "AYCommandDefines.h"

@implementation AYDefaultFacadeFactory {
    id<AYFacadeBase> facade; // = [[NSMutableDictionary alloc]init];
    
}

@synthesize para = _para;

- (id)createInstance {
    NSLog(@"para is : %@", _para);
  
    if (facade == nil) {
    
        NSString* desFacade = [self.para objectForKey:@"facade"];
        id<AYFacadeBase> result = nil;
        
        NSDictionary* cmds = [_para objectForKey:@"commands"];
        for (id<AYCommand> cmd in cmds.allValues) {
            [cmd postPerform];
        }
        
        Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desFacade] stringByAppendingString:kAYFactoryManagerFacadesuffix]);
        if (c == nil) {
            @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
        } else {
            result = [[c alloc]init];
            result.commands = cmds;
            facade = result;
        }
    }
    
    return facade;
}
@end
