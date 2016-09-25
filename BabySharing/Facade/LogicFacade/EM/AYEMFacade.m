//
//  AYEMFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEMFacade.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"
//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"
#import "EnumDefines.h"
#import "RemoteInstance.h"
#import "AYModel.h"
#import "AYRemoteCallCommand.h"

#import "RemoteInstance.h"


@interface AYEMFacade () <EMClientDelegate, EMChatManagerDelegate, EMChatroomManagerDelegate, EMGroupManagerDelegate>

@end

@implementation AYEMFacade {
    id dongda_note;
}

@synthesize para = _para;

#pragma mark -- commands
- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeDefaultFacade;
}

- (void)postPerform {
//    EMOptions *options = [EMOptions optionsWithAppkey:kAYEMAppKey];
////    options.apnsCertName = @"istore_dev";
//    EMError* error = [[EMClient sharedClient] initializeSDKWithOptions:options];
//    if (error) {
//        NSLog(@"error is : %d", error.code);
//        @throw [[NSException alloc]initWithName:@"error" reason:@"register EM Error" userInfo:nil];
//    }
    
    //消息回调:EMChatManagerChatDelegate
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

#pragma mark -- life cycle
- (void)dealloc {
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

#pragma mark -- EM Client Delegate
/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice {
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"SignOutLocal"];
    [cmd performWithResult:nil];
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer {
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"SignOutLocal"];
    [cmd performWithResult:nil];
}

/*!
 *  自动登录返回结果
 *
 *  @param aError 错误信息
 */
- (void)didAutoLoginWithError:(EMError *)aError {
    NSLog(@"auto login");
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState {
    NSLog(@"connection state changed");
}

#pragma mark -- EM Chat Manager Delegate
/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages {
    
    if (dongda_note == aMessages) {
        return;
    }
    dongda_note = aMessages;
    /**
     * for notification
     */
    NSPredicate* pn = [NSPredicate predicateWithFormat:@"SELF.from=%@", @"dongda_master"];
    NSArray* dongda_notify = [aMessages filteredArrayUsingPredicate:pn];
    
    for (EMMessage* message in dongda_notify) {
        if (message.isRead == NO && message.body.type == EMMessageBodyTypeText) {
            NSLog(@"message is : %@", ((EMTextMessageBody*)message.body).text);
            
            NSDictionary* dic = [RemoteInstance searchDataFromData:[((EMTextMessageBody*)message.body).text dataUsingEncoding:NSUTF8StringEncoding]];
            
            NotificationActionType type = ((NSNumber*)[dic objectForKey:@"type"]).intValue;
            
            switch (type) {
                case NotificationActionTypeOrderPushed:
                {
                    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                    [notify setValue:kAYNotifyOrderAccomplished forKey:kAYNotifyFunctionKey];
                    
                    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
                    [args setValue:dic forKey:@"notify_info"];
                    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
                    [self performWithResult:&notify];
                }
                    break;
                    
                case NotificationActionTypeOrderAccecpted:
                {
                    
                }
                    break;
                    
                case NotificationActionTypeOrderRejected:
                {
                    
                }
                    break;
                    
                case NotificationActionTypeOrderAccomplished:
                {
                    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                    [notify setValue:kAYNotifyOrderAccomplished forKey:kAYNotifyFunctionKey];
                    
                    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
                    [args setValue:dic forKey:@"notify_info"];
                    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
                    [self performWithResult:&notify];
                }
                    break;
                    
                default:
                    break;
            }
            
//            if (((NSNumber*)[dic objectForKey:@"type"]).intValue == NotificationActionTypeLoginOnOtherDevice) {
//            
//            } else {
//                
//                id<AYFacadeBase> f = CHATSESSIONMODEL;
//                id<AYCommand> cmd = [f.commands objectForKey:@"PushNotification"];
//                id args = dic;
//                [cmd performWithResult:&args];
//            }
//            
//            message.isRead = YES;
        }
    }
  
    /**
     * for message
     */
    NSPredicate* pm = [NSPredicate predicateWithFormat:@"SELF.from!=%@", @"dongda_master"];
    NSArray* dongda_msg = [aMessages filteredArrayUsingPredicate:pm];
    
    for (EMMessage* message in dongda_msg) {
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYNotifyEMReceiveMessage forKey:kAYNotifyFunctionKey];
        
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:message forKey:@"message"];
        [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
        [self performWithResult:&notify];
    }
}

/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages {
    
}

#pragma mark -- EM chat room Delegate
/*!
 *  接收到有用户加入聊天室
 *
 *  @param aChatroom    加入的聊天室
 *  @param aUsername    加入者username
 */
- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername {
    
}

/*!
 *  接收到有用户离开聊天室
 *
 *  @param aChatroom    离开的聊天室
 *  @param aUsername    离开者username
 */
- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername {
    
}

/*!
 *  接收到被踢出聊天室
 *
 *  @param aChatroom    被踢出的聊天室
 *  @param aReason      被踢出聊天室的原因
 */
- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
                              reason:(EMChatroomBeKickedReason)aReason {
    
}
@end
