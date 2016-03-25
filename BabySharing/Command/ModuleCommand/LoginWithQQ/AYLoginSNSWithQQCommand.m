//
//  AYLoginWithQQCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginSNSWithQQCommand.h"
// qq sdk
#import "TencentOAuth.h"
#import "AYLogicFacade.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

static NSString* const kQQTencentID = @"1104831230";
static NSString* const kQQTencentPermissionUserInfo = @"get_user_info";
static NSString* const kQQTencentPermissionSimpleUserInfo = @"get_simple_userinfo";
static NSString* const kQQTencentPermissionAdd = @"add_t";

@interface AYLoginSNSWithQQCommand () 

@end

@implementation AYLoginSNSWithQQCommand {
    TencentOAuth* qq_oauth;
    NSArray* permissions;
}
@synthesize para = _para;

- (void)postPerform {
    
    id<AYFacadeBase> qq_facade = FACADE(@"DefaultFacade", @"SNSQQ");
    
    qq_oauth = [[TencentOAuth alloc] initWithAppId:kQQTencentID andDelegate:(id<TencentSessionDelegate>)qq_facade];
    qq_oauth.redirectURI = nil;
    permissions =  @[kQQTencentPermissionUserInfo, kQQTencentPermissionSimpleUserInfo, kQQTencentPermissionUserInfo];
  
    NSMutableDictionary* dic = [qq_facade.para mutableCopy];
    if (dic == nil)
        dic = [[NSMutableDictionary alloc]init];
    [dic setValue:qq_oauth forKey:@"qq_instance"];
    qq_facade.para = [dic copy];
}

- (void)performWithResult:(NSObject**)obj {
    [self loginWithQQ];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandModule;
}

- (void)loginWithQQ {
    [qq_oauth authorize:permissions inSafari:YES];
}
@end
