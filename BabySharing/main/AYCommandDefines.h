//
//  AYCommandDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYCommandDefines_h
#define AYCommandDefines_h

static NSString* const kAYFactoryManagerControllerPrefix = @"AY";
static NSString* const kAYFactoryManagerControllersuffix = @"Controller";
static NSString* const kAYFactoryManagerFacadesuffix = @"Facade";
static NSString* const kAYFactoryManagerViewsuffix = @"View";

static NSString* const kAYFactoryManagerCatigoryCommand = @"Command";
static NSString* const kAYFactoryManagerCatigoryController = @"Controller";
static NSString* const kAYFactoryManagerCatigoryFacade = @"Facade";
static NSString* const kAYFactoryManagerCatigoryView = @"View";

static NSString* const kAYFactoryManagerCommandInit = @"Init";
static NSString* const kAYFactoryManagerCommandPush = @"Push";
static NSString* const kAYFactoryManagerCommandAPN = @"APN";
static NSString* const kAYFactoryManagerCommandMessage = @"Message";
static NSString* const kAYFactoryManagerCommandModule = @"Module";        // 处理单一功能的Command

#define COMMAND(TYPE, NAME)     [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryCommand type:TYPE name:NAME]
#define CONTROLLER(TYPE, NAME)  [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryController type:TYPE name:NAME]
#define DEFAULTCONTROLLER(NAME) [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryController type:@"DefaultController" name:NAME]
#define FACADE(TYPE, NAME)      [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryFacade type:TYPE name:NAME]
#define DEFAULTFACADE(NAME)     [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryFacade type:@"DefaultFacade" name:NAME]
#define MODULE(NAME)            COMMAND(kAYFactoryManagerCommandModule, NAME)
#define VIEW(TYPE, NAME)        [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryView type:TYPE name:NAME]

#define PNGRESOURCE(NAME)       [[AYResourceManager sharedInstance] enumResourceImageWithName:NAME andExtension:@"png"]
#endif /* AYCommandDefines_h */
