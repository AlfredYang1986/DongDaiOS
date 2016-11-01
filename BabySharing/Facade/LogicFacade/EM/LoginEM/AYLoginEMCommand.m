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
    
    void (^registerSuccess)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[EMClient sharedClient] asyncLoginWithUsername:current_user_id password:kAYEMDongdaCommonPassword success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"环信: 登陆成功");
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    [[EMClient sharedClient] dataMigrationTo3];
                    
                    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                    [notify setValue:kAYNotifyLoginEMSuccess forKey:kAYNotifyFunctionKey];
                    
                    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
                    [args setValue:current_user_id forKey:@"user_id"];
                    
                    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
                    [((AYFacade*)EMCLIENT) performWithResult:&notify];
                });
            } failure:^(EMError *aError) {
                NSLog(@"环信: 登陆失败");
            }];
        });
    };
    
    void (^rigisterFailed)(EMError* error) = ^(EMError* error) {
        if (error == nil || error.code == EMErrorUserAlreadyExist) {
            registerSuccess();
        } else {
            NSLog(@"环信: 注册失败");
        }
    };
    
    
    [[EMClient sharedClient] asyncRegisterWithUsername:current_user_id password:kAYEMDongdaCommonPassword success:registerSuccess failure:rigisterFailed];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
