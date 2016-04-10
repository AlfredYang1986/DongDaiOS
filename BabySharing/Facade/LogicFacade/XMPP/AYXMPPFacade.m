//
//  AYXMPPFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYXMPPFacade.h"
#import "AYCommandDefines.h"
#import "AYNotifyDefines.h"
#import "GotyeOCAPI.h"

static NSString* const kAYMessageCommandRegisterID = @"1afd2cc8-4060-41eb-aa5a-ee9460370156";
static NSString* const kAYMessageCommandRegisterName = @"DongDa";

@interface AYXMPPFacade () <GotyeOCDelegate>

@end

@implementation AYXMPPFacade

@synthesize para = _para;

#pragma mark -- commands
- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeDefaultFacade;
}

- (void)postPerform {
    status im_register_result = [GotyeOCAPI init:kAYMessageCommandRegisterID packageName:kAYMessageCommandRegisterName];
    if (im_register_result != GotyeStatusCodeOK) {
        NSLog(@"IM Register Error!");
    } else {
        NSLog(@"IM Register Success!");
    }

    [GotyeOCAPI addListener:self];
}

#pragma mark -- life cycle
- (void)dealloc {
    [GotyeOCAPI removeListener:self];
}

#pragma mark -- Gotaye Delegate
/**
 * @brief 登录回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onLogin:(GotyeStatusCode)code user:(GotyeOCUser*)user {
    NSLog(@"XMPP on Login");
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyLoginXMPPSuccess forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:user.name forKey:@"user_id"];
    
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

/**
 * @brief  正在重连回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onReconnecting:(GotyeStatusCode)code user:(GotyeOCUser*)user {
    NSLog(@"XMPP on Reconnecting");
//    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    app.im_user = user;
    
    //    [GotyeOCAPI activeSession:[GotyeOCUser userWithName:@"alfred_test"]];
//    [GotyeOCAPI beginReceiveOfflineMessage];
}

/**
 * @brief  退出登录回调
 * @param code: 状态id
 */
-(void) onLogout:(GotyeStatusCode)code {
    NSLog(@"XMPP on Logout");
//    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    app.im_user = nil;
}

/**
 * @brief 接收消息回调
 * @param message: 接收到的消息对象
 * @param downloadMediaIfNeed: 是否自动下载
 */
-(void) onReceiveMessage:(GotyeOCMessage*)message downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
//    if (message.sender.type == GotyeChatTargetTypeRoom) {
//        return;
//    }
//    
//    if ([message.sender.name isEqualToString:@"alfred_test"]) {
//        NSLog(@"this is a system notification");
//        
//        [_mm addNotification:[RemoteInstance searchDataFromData:[message.text dataUsingEncoding:NSUTF8StringEncoding]] withFinishBlock:^{
//            [_contentController unReadMessageCountChanged:nil];
//        }];
//        
//        [GotyeOCAPI markOneMessageAsRead:message isRead:YES];
//        //        GotyeOCUser* u = [GotyeOCUser userWithName:@"alfred_test"];
//        //        [GotyeOCAPI deleteMessage:u msg:message];
//        //        [GotyeOCAPI deleteSession:u alsoRemoveMessages:YES];
//        
//    } else {
//        NSLog(@"this is a chat message");
//        
//        // TODO: add logic for chat message
//        [_contentController unReadMessageCountChanged:nil];
//    }
}

/**
 * @brief 获取历史/离线消息回调
 * @param code: 状态id
 * @param msglist: 消息列表
 * @param downloadMediaIfNeed: 是否需要下载
 */
//-(void) onGetMessageList:(GotyeStatusCode)code totalCount:(unsigned)totalCount downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
-(void) onGetMessageList:(GotyeStatusCode)code msglist:(NSArray *)msgList downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
    NSLog(@"get message count : %lu", (unsigned long)msgList.count);
//
//    /**
//     * for notification
//     */
//    GotyeOCUser* u = [GotyeOCUser userWithName:@"alfred_test"];
//    NSArray* arr = [GotyeOCAPI getMessageList:u more:YES];
//    for (int index = 0; index < arr.count; ++index) {
//        GotyeOCMessage* m = [arr objectAtIndex:index];
//        if (m.status == GotyeMessageStatusUnread) {
//            NSLog(@"message is : %@", m.text);
//            
//            NSDictionary* dic = [RemoteInstance searchDataFromData:[m.text dataUsingEncoding:NSUTF8StringEncoding]];
//            if (((NSNumber*)[dic objectForKey:@"type"]).intValue == NotificationActionTypeLoginOnOtherDevice) {
//                [_lm signOutCurrentUserLocal];
//            } else {
//                [_mm addNotification:dic withFinishBlock:^{
//                    //                  [_contentController addOneNotification];
//                }];
//            }
//            
//            [GotyeOCAPI markOneMessageAsRead:m isRead:YES];
//        }
//    }
//    //    [GotyeOCAPI deleteMessages:u msglist:arr];
//    //    [GotyeOCAPI deleteSession:u alsoRemoveMessages:YES];
//    
//    /**
//     * for messages
//     */
//    [_contentController unReadMessageCountChanged:nil];
}

/**
 * @brief 发送消息回调
 * @param code: 状态id
 * @param message: 消息对象
 */
-(void) onSendMessage:(GotyeStatusCode)code message:(GotyeOCMessage*)message {
    NSLog(@"send message success: %@", message);
}
@end
