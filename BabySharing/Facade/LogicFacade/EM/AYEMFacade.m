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

@interface AYEMFacade ()

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
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

#pragma mark -- life cycle

#pragma mark -- EM Delegate

@end
