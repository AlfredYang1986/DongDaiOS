//
//  AYQueryMessagesCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryEMMessagesCommand.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"

//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EMConversation.h"
#import "EMMessageBody.h"

@implementation AYQueryEMMessagesCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
//    NSDictionary *info = nil;
//    CURRENUSER(info)
//    NSString *user_id = [info objectForKey:@"user_id"];
    
    NSString *owner_id = (NSString*)*obj;
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:owner_id type:EMConversationTypeChat createIfNotExist:YES];
    
//    NSTimeInterval d = [NSDate date].timeIntervalSince1970;
    NSArray *messages = [conversation loadMoreMessagesFromId:nil limit:50 direction:EMMessageSearchDirectionUp];
    
//    EMMessage *me = [conversation latestMessage];
//    NSString *str = ((EMTextMessageBody*)me.body).text;
    
    NSLog(@"%lu",messages.count);
    
    *obj = messages;
    
    
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
