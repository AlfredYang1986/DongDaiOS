//
//  AYPostPublishController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"
#import "AYLoginModelFacade.h"
#import "Tools.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "AYNotifyDefines.h"

#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "TmpFileStorageModel.h"
#import "QQApiInterfaceObject.h"
#import "QQApiInterface.h"
#import "Tools.h"
#import "AppDelegate.h"

// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"
#import "Providers.h"

// qq sdk
#import "TencentOAuth.h"

#import "WXApi.h"
#import "WXApiObject.h"


typedef enum : NSUInteger {
    AYPostPublishControllerStatusReady,
    AYPostPublishControllerStatusInputing,
} AYPostPublishControllerStatus;

@interface AYPostPublishController : AYViewController

@property (nonatomic, setter=setCurrentStatus:) AYPostPublishControllerStatus status;
@property (nonatomic, strong) UIImageView* mainContentView;
@property (nonatomic, strong) NSArray* tags;

@property (nonatomic) BOOL isShareWeibo;
@property (nonatomic) BOOL isShareWechat;
@property (nonatomic) BOOL isShareQQ;

- (NSString*)getNavTitle;
- (void)setCurrentStatus:(AYPostPublishControllerStatus)status;
- (void)didSelectPostBtn;
@end
