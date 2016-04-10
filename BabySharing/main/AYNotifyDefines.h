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

#endif /* AYNotifyDefines_h */
