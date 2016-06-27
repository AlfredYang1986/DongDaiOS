//
//  AYLoginXMPPCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginEMCommand.h"
//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"

static NSString* const kAYEMDongdaCommonPassword = @"PassW0rd";

@implementation AYLoginEMCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSString* current_user_id = (NSString*)*obj;
    
//    if (![GotyeOCAPI isOnline]) {
//        [GotyeOCAPI login:current_user_id password:nil];
//    } else if ([GotyeOCAPI getLoginUser].name != current_user_id) {
//        [GotyeOCAPI login:current_user_id password:nil];
//    }
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:current_user_id password:kAYEMDongdaCommonPassword];
    if (error == nil || error.code == EMErrorUserAlreadyExist) {
        error = [[EMClient sharedClient] loginWithUsername:current_user_id password:kAYEMDongdaCommonPassword];
        if (error == nil) {
            NSLog(@"环信: 登陆成功");
        } else {
            NSLog(@"环信: 登陆失败");
        }
    } else {
        NSLog(@"环信: 注册失败");
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
