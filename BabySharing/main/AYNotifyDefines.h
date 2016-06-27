//
//  AYModelDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYNotifyDefines_h
#define AYNotifyDefines_h

static NSString* const kAYNotifyActionKey = @"action";
static NSString* const kAYNotifyActionKeyNotify = @"notify";
static NSString* const kAYNotifyActionKeyReceive = @"receive";

static NSString* const kAYNotifyFunctionKey = @"message_name";

static NSString* const kAYNotifyFunctionKeyRegister = @"register";
static NSString* const kAYNotifyFunctionKeyUnregister = @"unregister";

static NSString* const kAYNotifyArgsKey = @"args";
static NSString* const kAYNotifyTargetKey = @"target";

static NSString* const kAYNotifyControllerKey = @"controller";


static NSString* const kAYNotifyQQAPIReady = @"SNSQQRegister:";
static NSString* const kAYNotifyWechatAPIReady = @"SNSWechatRegister:";
static NSString* const kAYNotifyWeiboAPIReady = @"SNSWeiboRegister:";
static NSString* const kAYNotifyLoginModelReady = @"LoginModelRegister:";

static NSString* const kAYNotifySNSLoginSuccess = @"SNSLoginSuccess:";
static NSString* const kAYCurrentLoginUserChanged = @"CurrentLoginUserChanged:";
static NSString* const kAYNotifyLoginXMPPSuccess = @"LoginXMPPSuccess:";
static NSString* const kAYNotifyLoginEMSuccess = @"LoginEMSuccess:";

static NSString* const kAYNotifyStartLogin = @"SNSStartLogin:";
static NSString* const kAYNotifyEndLogin = @"SNSEndLogin:";

static NSString* const kAYNotifyCurrentUserLogout = @"LogoutCurrentUser";

static NSString* const kAYNotifyDidStartMovieRecording = @"DidStartMovieRecording";
static NSString* const kAYNotifyDidEndMovieRecording = @"DidEndMovieRecording";
static NSString* const kAYNotifyDidDeleteMovieRecord = @"DidDeleteMovieRecord:";
static NSString* const kAYNotifyDidMergeMovieRecord = @"DidMergeMovieRecord:";

static NSString* const kAYNotifyXMPPMessageSendSuccess = @"XMPPMessageSendSuccess:";
static NSString* const kAYNotifyXMPPMessageSendFailed = @"XMPPMessageSendFailed:";
static NSString* const kAYNotifyXMPPReceiveMessage = @"XMPPReceiveMessage:";
static NSString* const kAYNotifyXMPPGetGroupMemberSuccess = @"XMPPGetGroupMemberSuccess:";
static NSString* const kAYNotifyXMPPMessageGetMessageListSuccess = @"XMPPMessageGetMessageListSuccess:";
static NSString* const kAYNotifyXMPPMessageGetMessageListFailed = @"XMPPMessageGetMessageListFailed:";

static NSString* const kAYNotifyKeyboardShowKeyboard = @"KeyboardShowKeyboard:";
static NSString* const kAYNotifyKeyboardHideKeyboard = @"KeyboardHideKeyboard:";
static NSString* const kAYNotifyKeyboardArgsHeightKey = @"KeyboardArgsHeightKey";

#endif /* AYNotifyDefines_h */
