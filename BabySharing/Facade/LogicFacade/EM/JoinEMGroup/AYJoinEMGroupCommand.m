//
//  AYJoinGroupCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYJoinEMGroupCommand.h"
//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EMConversation.h"

@implementation AYJoinEMGroupCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSString* group_id = (NSString*)*obj;
    
    EMError *error = nil;
    [[EMClient sharedClient].roomManager joinChatroom:group_id error:&error];
    if (error == nil) {
        NSLog(@"环信: 进入聊天室成功");
    } else {
        NSLog(@"环信: error is : %d", error.code);
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
