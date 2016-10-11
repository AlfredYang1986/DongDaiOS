//
//  AYCommandsCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 20/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#ifndef AYCommandsCommand_h
#define AYCommandsCommand_h

#pragma mark --  default views define
//default views and views'messages  define
static NSString* const kAYFakeNavBarView =                  @"FakeNavBar";
static NSString* const kAYTableView =                       @"Table";
static NSString* const kAYPickerView =                       @"Picker";

//FakeNavBar
static NSString* const kAYNavBarSetTitleMessage =               @"setTitleText:";
static NSString* const kAYNavBarSetLeftBtnImgMessage =          @"setLeftBtnImg:";
static NSString* const kAYNavBarSetRightBtnImgMessage =         @"setRightBtnImg:";
static NSString* const kAYNavBarSetRightBtnWithBtnMessage =     @"setRightBtnWithBtn:";
static NSString* const kAYNavBarSetLeftBtnVisibilityMessage =   @"setLeftBtnVisibility:";
static NSString* const kAYNavBarSetRightBtnVisibilityMessage =  @"setRightBtnVisibility:";
static NSString* const kAYNavBarSetBarBotLineMessage =          @"setBarBotLine";

//Table
static NSString* const kAYTableRegisterDatasourceMessage =      @"registerDatasource:";
static NSString* const kAYTableRegisterDelegateMessage =        @"registerDelegate:";
static NSString* const kAYTableRegisterCellWithClassMessage =   @"registerCellWithClass:";
static NSString* const kAYTableRegisterCellWithNibMessage =     @"registerCellWithNib:";
static NSString* const kAYTableRefreshMessage =                 @"refresh";

//Picker
static NSString* const kAYPickerShowViewMessage =                 @"showPickerView";

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

#pragma mark -- popToRoot
#define kAYPopToRootVC                              {\
                                                        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];\
                                                        [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];\
                                                        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];\
                                                        \
                                                        id<AYCommand> cmd = POPTOROOT;\
                                                        [cmd performWithResult:&dic];\
                                                    }


#endif /* AYCommandsCommand_h */
