//
//  AYLoginSNSWithWechatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginSNSWithWechatCommand.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"


static NSString* const kWechatUserInfo = @"snsapi_userinfo,snsapi_base";
static NSString* const kWechatAuthState = @"0744";

@interface AYLoginSNSWithWechatCommand () <WXApiDelegate>

@end

@implementation AYLoginSNSWithWechatCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = kWechatUserInfo;
    req.state = kWechatAuthState;
    [WXApi sendReq:req];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandModule;
}


@end
