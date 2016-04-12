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
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
