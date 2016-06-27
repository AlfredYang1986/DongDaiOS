//
//  AYXMPPFacade.m
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

static NSString* const kAYEMAppKey = @"blackmirror#dongda";

@interface AYEMFacade () <EMClientDelegate, EMChatManagerDelegate, EMChatroomManagerDelegate /*, EMGroupManagerDelegate*/>

@end

@implementation AYEMFacade

@synthesize para = _para;

#pragma mark -- commands
- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeDefaultFacade;
}

- (void)postPerform {
    EMOptions *options = [EMOptions optionsWithAppkey:kAYEMAppKey];
//    options.apnsCertName = @"istore_dev";
    EMError* error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (error) {
        NSLog(@"error is : %d", error.code);
        @throw [[NSException alloc]initWithName:@"error" reason:@"register EM Error" userInfo:nil];
    }
    
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

#pragma mark -- EM Chat Manager Delegate
/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages {
    
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
