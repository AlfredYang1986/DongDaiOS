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

@implementation AYSendEMMessageCommand
@synthesize para = _para;

- (void)postPerform {
    
}

//EMConversationTypeChat            单聊会话
//EMConversationTypeGroupChat       群聊会话
//EMConversationTypeChatRoom        聊天室会话

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
//    NSNumber* group_id = [dic objectForKey:@"group_id"];
    NSString* group_id = [dic objectForKey:@"group_id"];
    NSString* text = [dic objectForKey:@"text"];
    
//    GotyeOCGroup* group = [GotyeOCGroup groupWithId:group_id.longLongValue];
//    GotyeOCMessage* m = [GotyeOCMessage createTextMessage:group text:text];
//    [GotyeOCAPI sendMessage:m];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:group_id from:from to:group_id body:body ext:nil];
//    message.chatType = EMChatTypeChat;// 设置为单聊消息
    message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        
    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
