//
//  AYShowAlertCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 13/10/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShowAlertCommand.h"
#import "AYAlertFacade.h"
#import "AYFactoryManager.h"

@implementation AYShowAlertCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYAlertFacade* alert_facade = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"Alert");
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:@"ShowBtmAlert:" forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:((NSDictionary*)*obj) forKey:@"notify_info"];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [alert_facade performWithResult:&notify];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

@end
