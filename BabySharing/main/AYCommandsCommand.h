//
//  AYCommandsCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 20/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#ifndef AYCommandsCommand_h
#define AYCommandsCommand_h

#pragma mark -- VC中的views发消息 / 发通知
#define kAYViewsSendMessage(VIEW,MESSAGE,ARGS)              {\
                                                                id<AYViewBase> kAYView = [self.views objectForKey:VIEW];\
                                                                id<AYCommand> kAYCommand = [kAYView.commands objectForKey:MESSAGE];\
                                                                [kAYCommand performWithResult:ARGS];\
                                                            }

#define kAYViewsSendNotify(VIEW,MESSAGE,ARGS)               {\
                                                                id<AYViewBase> kAYView = [self.views objectForKey:VIEW];\
                                                                id<AYCommand> kAYCommand = [kAYView.notifies objectForKey:MESSAGE];\
                                                                [kAYCommand performWithResult:ARGS];\
                                                            }
#pragma mark -- 一个view发消息 / 发通知
#define kAYViewSendMessage(VIEW,MESSAGE,ARGS)              {\
                                                                id<AYCommand> kAYCommand = [VIEW.commands objectForKey:MESSAGE];\
                                                                [kAYCommand performWithResult:ARGS];\
                                                            }

#define kAYViewSendNotify(VIEW,MESSAGE,ARGS)                {\
                                                                id<AYCommand> kAYCommand = [VIEW.notifies objectForKey:MESSAGE];\
                                                                [kAYCommand performWithResult:ARGS];\
                                                            }

#pragma mark -- VC中的delagates发消息
#define kAYDelegatesSendMessage(DELEGATE,MESSAGE,ARGS)      {\
                                                                id<AYDelegateBase> kAYDelegate = [self.delegates objectForKey:DELEGATE];\
                                                                id<AYCommand> kAYCommand = [kAYDelegate.commands objectForKey:MESSAGE];\
                                                                [kAYCommand performWithResult:ARGS];\
                                                            }
#pragma mark -- delagate 发通知
#define kAYDelegateSendNotify(DELEGATE,MESSAGE,ARGS)        {\
                                                                id<AYCommand> kAYCommand = [DELEGATE.notifies objectForKey:MESSAGE];\
                                                                [kAYCommand performWithResult:ARGS];\
                                                            }





#pragma mark -- 系统提示弹框
#define kAYUIAlertView(TITLE,MESSAGE)               [[[UIAlertView alloc]initWithTitle:TITLE message:MESSAGE delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show]


#endif /* AYCommandsCommand_h */
