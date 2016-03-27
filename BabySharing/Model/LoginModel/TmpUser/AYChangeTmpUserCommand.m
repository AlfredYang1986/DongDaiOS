//
//  AYChangeTmpUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChangeTmpUserCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "RegTmpToken.h"
#import "RegTmpToken+ContextOpt.h"

#import "AYModelFacade.h"

@implementation AYChangeTmpUserCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change tmp user in local db: %@", *obj);

    NSDictionary* dic = (NSDictionary*)*obj;
    NSString* phoneNo = [dic objectForKey:@"phoneNo"];
    NSString* reg_token = [dic objectForKey:@"reg_token"];
 
    AYModelFacade* f = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"LoginModel");
    dispatch_async(dispatch_get_main_queue(), ^{
        [RegTmpToken createRegTokenInContext:f.doc.managedObjectContext WithToken: reg_token andPhoneNumber: phoneNo];
    });
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
