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

static NSString* const kAYFactoryManagerCatigoryCommand = @"Command";
static NSString* const kAYFactoryManagerCatigoryController = @"Controller";
static NSString* const kAYFactoryManagerCatigoryFacade = @"Facade";

static NSString* const kAYFactoryManagerCommandInit = @"Init";
static NSString* const kAYFactoryManagerCommandPush = @"Push";
static NSString* const kAYFactoryManagerCommandAPN = @"APN";
static NSString* const kAYFactoryManagerCommandMessage = @"Message";
static NSString* const kAYFactoryManagerCommandModule = @"Module";        // 处理单一功能的Command

#define COMMAND(TYPE, NAME) [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryCommand type:TYPE name:NAME]
#define CONTROLLER(NAME) [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryController type:kAYFactoryManagerCatigoryController name:NAME]
#define FACADE(NAME) [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryFacade type:kAYFactoryManagerCatigoryFacade name:NAME]
#define MODULE(NAME)    COMMAND(kAYFactoryManagerCommandModule, NAME)
#endif /* AYCommandDefines_h */
