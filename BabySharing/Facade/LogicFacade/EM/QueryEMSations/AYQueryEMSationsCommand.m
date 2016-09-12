//
//  AYQueryEMSationsCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 9/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYQueryEMSationsCommand.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"

//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EMConversation.h"
#import "EMMessageBody.h"

@implementation AYQueryEMSationsCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSString *owner_id = (NSString*)*obj;
    [[EMClient sharedClient].chatManager getConversation:owner_id type:EMConversationTypeChat createIfNotExist:YES];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    NSMutableArray *tmp = [conversations mutableCopy];
    for (EMConversation *sation in conversations) {
        EMMessage *message = sation.latestMessage;
        if (message == nil) {
            [tmp removeObject:sation];
        }
    }
    
//    NSString *from = message.from;
//    NSString *to = message.to;
//    NSString *me = ((EMTextMessageBody*)message.body).text;
    
    *obj = tmp;
    //群聊模式：
    //    NSDictionary* dic = (NSDictionary*)*obj;
    //    NSString* group_id = [dic objectForKey:@"group_id"];
    //
    //    NSTimeInterval t = [NSDate date].timeIntervalSince1970;
    //
    //    EMConversation* c = [[EMClient sharedClient].chatManager getConversation:group_id type:EMConversationTypeChatRoom createIfNotExist:NO];
    //    NSArray* result = [c loadMoreMessagesWithType:EMMessageBodyTypeText before:t limit:10 from:nil direction:EMMessageSearchDirectionDownload];
    //
    //    *obj = result != nil ? result : [[NSArray alloc]init];
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
