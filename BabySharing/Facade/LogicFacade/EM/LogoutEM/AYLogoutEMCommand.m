//
//  AYLogoutXMPPCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLogoutEMCommand.h"
//#import "GotyeOCAPI.h"
#import "EMSDK.h"
#import "EMError.h"

#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYFacade.h"

@implementation AYLogoutEMCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
//    [GotyeOCAPI logout];
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"环信: 退出成功");
    } else {
        NSLog(@"环信: 退出失败");
    }
    
	//    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
	//    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
	//    [notify setValue:kAYNotifyCurrentUserLogout forKey:kAYNotifyFunctionKey];
	//
	//    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
	//    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
	//
	//    id<AYFacadeBase> f = LOGINMODEL;
	//    [f performWithResult:&notify];
	
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
