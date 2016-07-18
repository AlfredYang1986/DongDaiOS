//
//  AYEMQueryGroupMemberLstCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 6/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEMQueryGroupMemberLstCommand.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EMGroup.h"

#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYNotifyDefines.h"

@implementation AYEMQueryGroupMemberLstCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
//    [[EMClient sharedClient] applicationDidEnterBackground:[UIApplication sharedApplication]];
    NSString* group_id = (NSString*)*obj;
    
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:group_id includeMembersList:YES error:&error];
    
    NSArray* arr = group.members;
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    NSMutableDictionary* args = [user mutableCopy];
    [args setValue:[arr copy] forKey:@"query_list"];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"ProfileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"QueryMultipleUsers"];
    [cmd performWithResult:[args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSMutableDictionary* reVal = [[NSMutableDictionary alloc]init];
        [reVal setValue:group_id forKey:@"group_id"];
        [reVal setValue:result forKey:@"result"];
        
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYNotifyEMGetGroupMemberSuccess forKey:kAYNotifyFunctionKey];
        
        [notify setValue:[reVal copy] forKey:kAYNotifyArgsKey];
        [((AYFacade*)EMCLIENT) performWithResult:&notify];
    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
