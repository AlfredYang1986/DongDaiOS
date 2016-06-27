//
//  AYUnreadMessageCountCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEMUnreadMessageCountCommand.h"
//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EMConversation.h"

@implementation AYEMUnreadMessageCountCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    int count = 0;
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    for (EMConversation* c in conversations) {
        count += c.unreadMessagesCount;
    }
    *obj = [NSNumber numberWithInt:count];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
