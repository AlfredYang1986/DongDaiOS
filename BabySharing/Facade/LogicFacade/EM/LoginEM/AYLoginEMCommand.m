//
//  AYLoginXMPPCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginEMCommand.h"
#import "GotyeOCAPI.h"

@implementation AYLoginEMCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSString* current_user_id = (NSString*)*obj;
    
    if (![GotyeOCAPI isOnline]) {
        [GotyeOCAPI login:current_user_id password:nil];
    } else if ([GotyeOCAPI getLoginUser].name != current_user_id) {
        [GotyeOCAPI login:current_user_id password:nil];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
