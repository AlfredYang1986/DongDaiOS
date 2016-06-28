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

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"

@implementation AYJoinEMGroupCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSString* group_id = (NSString*)*obj;
    
    BOOL b = [[EMClient sharedClient] isLoggedIn];
    NSLog(@"is logged in : %d", b);
    if (!b) {
        NSDictionary* obj = nil;
        CURRENUSER(obj)
        NSDictionary* user = [obj copy];
        [[EMClient sharedClient] loginWithUsername:[user objectForKey:@"user_id"] password:@"PassW0rd"];
    }
    
    EMError *error = nil;
    [[EMClient sharedClient].groupManager joinPublicGroup:group_id error:&error];
    if (error == nil) {
        NSLog(@"环信: 进入聊天室成功");
        *obj = [NSNumber numberWithBool:YES];
        
    } else {
        NSLog(@"环信: error is : %d", error.code);
        *obj = [NSNumber numberWithBool:NO];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
