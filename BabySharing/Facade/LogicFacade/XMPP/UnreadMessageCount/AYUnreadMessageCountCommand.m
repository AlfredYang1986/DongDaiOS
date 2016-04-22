//
//  AYUnreadMessageCountCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUnreadMessageCountCommand.h"
#import "GotyeOCAPI.h"

@implementation AYUnreadMessageCountCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    int count = [GotyeOCAPI getUnreadNotifyCount];
    *obj = [NSNumber numberWithInt:count];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
