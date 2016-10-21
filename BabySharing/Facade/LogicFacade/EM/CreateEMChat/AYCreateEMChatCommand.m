//
//  AYCreateEMChatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 8/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCreateEMChatCommand.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EMConversation.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"

@implementation AYCreateEMChatCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {

    NSString *owner_id = (NSString*)*obj;
    [[EMClient sharedClient].chatManager getConversation:owner_id type:EMConversationTypeChat createIfNotExist:YES];
    
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:owner_id type:EMConversationTypeChat createIfNotExist:YES];
//    NSString *chat_id = conversation.conversationId;
//
//    *obj = conversations;

}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
