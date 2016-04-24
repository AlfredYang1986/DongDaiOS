//
//  AYQueryMessagesCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryMessagesCommand.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"

#import "GotyeOCAPI.h"

@implementation AYQueryMessagesCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    NSNumber* group_id = [dic objectForKey:@"group_id"];
    
//    id<AYFacadeBase> f = DEFAULTFACADE(@"XMPP");
//    id<AYCommand> cmd = [f.commands objectForKey:@"UnreadMessageCount"];
//    NSNumber* unReadCount = nil;
//    [cmd performWithResult:&unReadCount];
   
//    if (unReadCount.integerValue > 0) {
//        [GotyeOCAPI setMessageReadIncrement:unReadCount.unsignedIntValue];
//    }
    GotyeOCGroup* group = [GotyeOCGroup groupWithId:group_id.longLongValue];
    id result = [GotyeOCAPI getMessageList:group more:YES];
//    [GotyeOCAPI setMessageReadIncrement:10];
    
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
