//
//  AYXMPPFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYXMPPFacade.h"
#import "AYCommandDefines.h"
#import "GotyeOCAPI.h"

static NSString* const kAYMessageCommandRegisterID = @"1afd2cc8-4060-41eb-aa5a-ee9460370156";
static NSString* const kAYMessageCommandRegisterName = @"DongDa";

@implementation AYXMPPFacade
@synthesize para = _para;


- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeDefaultFacade;
}

- (void)postPerform {
    status im_register_result = [GotyeOCAPI init:kAYMessageCommandRegisterID packageName:kAYMessageCommandRegisterName];
    if (im_register_result != GotyeStatusCodeOK) {
        NSLog(@"IM Register Error!");
    } else {
        NSLog(@"IM Register Success!");
    }
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
}
@end
