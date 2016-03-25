//
//  AYLoginSNSWechatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginSNSWithWeiboCommand.h"
#import "AYCommandDefines.h"

#import "WeiboSDK.h"
// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

static NSString* const kAYWeiboRegisterID = @"1584832986";

@interface AYLoginSNSWithWeiboCommand ()

@end

@implementation AYLoginSNSWithWeiboCommand

@synthesize para = _para;

- (void)postPerform {
    // Weibo sdk init
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAYWeiboRegisterID];
}

- (void)performWithResult:(NSObject**)obj {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://192.168.0.101";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandModule;
}
@end
