//
//  AYIsInstalledWeChatCommand.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/2.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYIsInstalledWeChatCommand.h"
#import "WXApi.h"

static NSString* const kWechatID = @"wx66d179d99c9ba7d6";

@implementation AYIsInstalledWeChatCommand

@synthesize command_type = _command_type;

@synthesize para = _para;

- (void)postPerform {
    
    
    
}


- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    [WXApi registerApp:kWechatID];
    
    BOOL isWXAppInstalled = [WXApi isWXAppInstalled];
    
    *obj = [NSNumber numberWithBool:isWXAppInstalled];
    
}

- (NSString*)getCommandType {
    
    return kAYFactoryManagerCommandTypeModule;
    
}

@end
