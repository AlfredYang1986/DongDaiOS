//
//  AYSendMessageCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSendEMMessageCommand.h"
//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EMChatroom.h"
#import "EMMessage.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYNotifyDefines.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacade.h"

@implementation AYSendEMMessageCommand
@synthesize para = _para;

- (void)postPerform {
    
}

//EMConversationTypeChat            单聊会话
//EMConversationTypeGroupChat       群聊会话
//EMConversationTypeChatRoom        聊天室会话

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    NSString* owner_id = [dic objectForKey:@"owner_id"];
    NSString* text = [dic objectForKey:@"text"];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:owner_id from:from to:owner_id body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];

        if (error == nil) {
            [notify setValue:kAYNotifyEMMessageSendSuccess forKey:kAYNotifyFunctionKey];
        } else {
            [notify setValue:kAYNotifyEMMessageSendFailed forKey:kAYNotifyFunctionKey];
        }

        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:message forKey:@"message"];
        [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
        [((AYFacade*)EMCLIENT) performWithResult:&notify];
    }];
    
    //群聊：
//    NSString* group_id = [dic objectForKey:@"group_id"];
//    NSString* text = [dic objectForKey:@"text"];
//
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
//    NSString *from = [[EMClient sharedClient] currentUsername];
//    
//    //生成Message
//    EMMessage *message = [[EMMessage alloc] initWithConversationID:group_id from:from to:group_id body:body ext:nil];
//    message.chatType = EMChatTypeChat;// 设置为单聊消息
////    message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
//    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
//    
//    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
//        NSLog(@"send message success: %@", aMessage);
//        
//        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
//        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
//        
//        if (aError == nil) {
//            [notify setValue:kAYNotifyEMMessageSendSuccess forKey:kAYNotifyFunctionKey];
//        } else {
//            [notify setValue:kAYNotifyEMMessageSendFailed forKey:kAYNotifyFunctionKey];
//        }
//        
//        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
//        [args setValue:aMessage forKey:@"message"];
//        [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
//        [((AYFacade*)EMCLIENT) performWithResult:&notify];
//    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
