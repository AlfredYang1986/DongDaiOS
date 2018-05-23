//
//  AYQueryRegUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryRegUserCommand.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYCommandDefines.h"

#import "RegTmpToken.h"
#import "RegTmpToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "RegCurrentToken.h"
#import "RegCurrentToken+ContextOpt.h"

@implementation AYQueryRegUserCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user in local db: %@", *obj);
    
    AYModelFacade* f = LOGINMODEL;
    RegCurrentToken* tmp = [RegCurrentToken enumCurrentRegLoginUserInContext:f.doc.managedObjectContext];
    
    NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:2];
    [cur setValue:tmp.who.user_id forKey:kAYCommArgsUserID];
    [cur setValue:tmp.who.auth_token forKey:kAYCommArgsToken];
    
    *obj = [cur copy];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
