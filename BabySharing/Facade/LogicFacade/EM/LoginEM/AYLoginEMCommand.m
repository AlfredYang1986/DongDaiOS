//
//  AYLoginXMPPCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginEMCommand.h"
//#import "GotyeOCAPI.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "EMSDK.h"
#import "EMError.h"
#import "AYCommandDefines.h"
#import "AYNotiyCommand.h"
#import "AYNotifyDefines.h"
#import "AYFactoryManager.h"

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
            
            NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
            [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
            [notify setValue:kAYNotifyLoginEMSuccess forKey:kAYNotifyFunctionKey];
            
            NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
            [args setValue:current_user_id forKey:@"user_id"];
            
            [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
            [((AYFacade*)EMCLIENT) performWithResult:&notify];
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
