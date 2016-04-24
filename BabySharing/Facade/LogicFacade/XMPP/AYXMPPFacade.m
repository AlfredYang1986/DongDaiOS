//
//  AYXMPPFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYXMPPFacade.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"
#import "GotyeOCAPI.h"
#import "EnumDefines.h"
#import "RemoteInstance.h"
#import "AYModel.h"
#import "AYRemoteCallCommand.h"

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
    [GotyeOCAPI beginReceiveOfflineMessage];
}

/**
 * @brief  退出登录回调
 * @param code: 状态id
 */
-(void) onLogout:(GotyeStatusCode)code {
    NSLog(@"XMPP on Logout");
}

/**
 * @brief 接收消息回调
 * @param message: 接收到的消息对象
 * @param downloadMediaIfNeed: 是否自动下载
 */
-(void) onReceiveMessage:(GotyeOCMessage*)message downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
    
    if (message.status == GotyeMessageStatusUnread) {
        NSLog(@"message is : %@", message.text);
        
        NSDictionary* dic = [RemoteInstance searchDataFromData:[message.text dataUsingEncoding:NSUTF8StringEncoding]];
        if (((NSNumber*)[dic objectForKey:@"type"]).intValue == NotificationActionTypeLoginOnOtherDevice) {
            //                [_lm signOutCurrentUserLocal];        // other device login
        } else {
            
            id<AYFacadeBase> f = CHATSESSIONMODEL;
            id<AYCommand> cmd = [f.commands objectForKey:@"PushNotification"];
            id args = dic;
            [cmd performWithResult:&args];
        }
        
        [GotyeOCAPI markOneMessageAsRead:message isRead:YES];
    }
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyXMPPReceiveMessage forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:message forKey:@"message"];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

/**
 * @brief 获取历史/离线消息回调
 * @param code: 状态id
 * @param msglist: 消息列表
 * @param downloadMediaIfNeed: 是否需要下载
 */
-(void) onGetMessageList:(GotyeStatusCode)code msglist:(NSArray *)msgList downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
    NSLog(@"get message count : %lu", (unsigned long)msgList.count);

    /**
     * for notification
     */
    NSPredicate* pn = [NSPredicate predicateWithFormat:@"SELF.name=%@", @"alfred_test"];
    NSArray* dongda_notify = [msgList filteredArrayUsingPredicate:pn];
    
    for (GotyeOCMessage* m in dongda_notify) {
        if (m.status == GotyeMessageStatusUnread) {
            NSLog(@"message is : %@", m.text);
            
            NSDictionary* dic = [RemoteInstance searchDataFromData:[m.text dataUsingEncoding:NSUTF8StringEncoding]];
            if (((NSNumber*)[dic objectForKey:@"type"]).intValue == NotificationActionTypeLoginOnOtherDevice) {
            } else {
                
                id<AYFacadeBase> f = CHATSESSIONMODEL;
                id<AYCommand> cmd = [f.commands objectForKey:@"PushNotification"];
                id args = dic;
                [cmd performWithResult:&args];
            }
            
            [GotyeOCAPI markOneMessageAsRead:m isRead:YES];
        }
    }
    

    /**
     * for message
     */
    NSPredicate* pm = [NSPredicate predicateWithFormat:@"SELF.name!=%@", @"alfred_test"];
    NSArray* dongda_msg = [msgList filteredArrayUsingPredicate:pm];
   
    if (dongda_msg.count > 0) {
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        
        if (code == GotyeStatusCodeOK) {
            [notify setValue:kAYNotifyXMPPMessageGetMessageListSuccess forKey:kAYNotifyFunctionKey];
        } else {
            [notify setValue:kAYNotifyXMPPMessageGetMessageListFailed forKey:kAYNotifyFunctionKey];
        }
        
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:dongda_msg forKey:@"msglist"];
        [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
        [self performWithResult:&notify];
    }
}

/**
 * @brief 发送消息回调
 * @param code: 状态id
 * @param message: 消息对象
 */
-(void) onSendMessage:(GotyeStatusCode)code message:(GotyeOCMessage*)message {
    NSLog(@"send message success: %@", message);
   
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    
    if (code == GotyeStatusCodeOK) {
        [notify setValue:kAYNotifyXMPPMessageSendSuccess forKey:kAYNotifyFunctionKey];
    } else {
        [notify setValue:kAYNotifyXMPPMessageSendFailed forKey:kAYNotifyFunctionKey];
    }

    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:message forKey:@"message"];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

- (void)onJoinGroup:(GotyeStatusCode)code group:(GotyeOCGroup *)group {
    NSLog(@"join group status code %d", code);
    [GotyeOCAPI reqGroupMemberList:group pageIndex:0];
    [GotyeOCAPI markMessagesAsRead:group isRead:YES];
}

- (void)onGetGroupMemberList:(GotyeStatusCode)code group:(GotyeOCGroup *)group pageIndex:(unsigned int)pageIndex curPageMemberList:(NSArray *)curPageMemberList allMemberList:(NSArray *)allMemberList {
  
    if (code == GotyeStatusCodeOK) {
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:curPageMemberList.count];
        for (GotyeOCUser* user in allMemberList) {
            [arr addObject:user.name];
        }
        
        NSDictionary* user = nil;
        CURRENUSER(user);
        
        NSMutableDictionary* args = [user mutableCopy];
        [args setValue:[arr copy] forKey:@"query_list"];
    
        id<AYFacadeBase> f = DEFAULTFACADE(@"ProfileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"QueryMultipleUsers"];
        [cmd performWithResult:[args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSMutableDictionary* reVal = [[NSMutableDictionary alloc]init];
            [reVal setValue:[NSNumber numberWithLong:group.id] forKey:@"group_id"];
            [reVal setValue:result forKey:@"result"];
            
            NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
            [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
            [notify setValue:kAYNotifyXMPPGetGroupMemberSuccess forKey:kAYNotifyFunctionKey];
            
            [notify setValue:[reVal copy] forKey:kAYNotifyArgsKey];
            [self performWithResult:&notify];
        }];
    }
}
@end
