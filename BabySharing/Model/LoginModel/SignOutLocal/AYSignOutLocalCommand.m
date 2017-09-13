//
//  AYSignOutLocalCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSignOutLocalCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
//#import "LoginToken.h"
//#import "LoginToken+ContextOpt.h"

@implementation AYSignOutLocalCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"logout current info in local db");
   
    AYModelFacade* f = LOGINMODEL;
    [CurrentToken logOutCurrentLoginUserInContext:f.doc.managedObjectContext];
    
    /**
     * create controller factory
     */
    id<AYCommand> cmd = COMMAND(kAYFactoryManagerCommandTypeInit, kAYFactoryManagerCommandTypeInit);
    AYViewController* controller = nil;
    [cmd performWithResult:&controller];
    
    /**
     * Navigation Controller
     */
    UINavigationController* rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
    [rootContorller pushViewController:controller animated:NO];
    
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:rootContorller forKey:kAYControllerActionDestinationControllerKey];
    [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
    [cmd_show_module performWithResult:&dic_show_module];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:DongDaAppModeUnLogin] forKey:@"dongda_app_mode"];
    [defaults synchronize];
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
