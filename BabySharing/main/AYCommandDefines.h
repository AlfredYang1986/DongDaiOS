//
//  AYCommandDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYCommandDefines_h
#define AYCommandDefines_h

typedef void(^asynCommandFinishBlock)(BOOL, NSDictionary*);

static NSString* const kAYFactoryManagerMessageNameKey = @"factory manager message name";
static NSString* const kAYFactoryManagerMessageNameHostValue = @"server host";

static NSString* const kAYFactoryManagerControllerPrefix = @"AY";
static NSString* const kAYFactoryManagerControllersuffix = @"Controller";
static NSString* const kAYFactoryManagerFacadesuffix = @"Facade";
static NSString* const kAYFactoryManagerViewsuffix = @"View";
static NSString* const kAYFactoryManagerDelegatesuffix = @"Delegate";

static NSString* const kAYFactoryManagerCatigoryCommand = @"Command";
static NSString* const kAYFactoryManagerCatigoryController = @"Controller";
static NSString* const kAYFactoryManagerCatigoryFacade = @"Facade";
static NSString* const kAYFactoryManagerCatigoryView = @"View";
static NSString* const kAYFactoryManagerCatigoryDelegate = @"Delegate";
static NSString* const kAYFactoryManagerCatigoryModel = @"Model";

static NSString* const kAYFactoryManagerCommandTypeInit = @"Init";
static NSString* const kAYFactoryManagerCommandTypePush = @"Push";
static NSString* const kAYFactoryManagerCommandTypePop = @"Pop";
static NSString* const kAYFactoryManagerCommandTypePopToRoot = @"PopToRoot";
static NSString* const kAYFactoryManagerCommandTypeShowModule = @"ShowModule";
static NSString* const kAYFactoryManagerCommandTypeShowModuleUp = @"ShowModuleUp";
static NSString* const kAYFactoryManagerCommandTypeAlertView = @"AlertView";
static NSString* const kAYFactoryManagerCommandTypeAPN = @"APN";
static NSString* const kAYFactoryManagerCommandTypeDefaultController = @"DefaultController";
static NSString* const kAYFactoryManagerCommandTypeDefaultFacade = @"DefaultFacade";
static NSString* const kAYFactoryManagerCommandTypeModule = @"Module";          // 处理单一功能的Command
static NSString* const kAYFactoryManagerCommandTypeRemote = @"Remote";          // 处理一个服务器访问
static NSString* const kAYFactoryManagerCommandTypeView = @"View";              // 用户controller控制View
static NSString* const kAYFactoryManagerCommandTypeViewNotify = @"View Notify"; // 用户View callback Controller
static NSString* const kAYFactoryManagerCommandTypeNotify = @"Notify";          // 用户model对controller的notify

#define COMMAND(TYPE, NAME)     [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryCommand type:TYPE name:NAME]
#define MODULE(NAME)            COMMAND(kAYFactoryManagerCommandTypeModule, NAME)
#define REMOTE(NAME)            COMMAND(kAYFactoryManagerCommandTypeRemote, NAME)
#define PUSH                    COMMAND(kAYFactoryManagerCommandTypePush, kAYFactoryManagerCommandTypePush)
#define POP                     COMMAND(kAYFactoryManagerCommandTypePop, kAYFactoryManagerCommandTypePop)
#define POPTOROOT               COMMAND(kAYFactoryManagerCommandTypePopToRoot, kAYFactoryManagerCommandTypePopToRoot)
#define SHOWMODULE              COMMAND(kAYFactoryManagerCommandTypeShowModule, kAYFactoryManagerCommandTypeShowModule)
#define SHOWMODULEUP            COMMAND(kAYFactoryManagerCommandTypeShowModuleUp, kAYFactoryManagerCommandTypeShowModuleUp)

#define CONTROLLER(TYPE, NAME)  [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryController type:TYPE name:NAME]
#define DEFAULTCONTROLLER(NAME) [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryController type:kAYFactoryManagerCommandTypeDefaultController name:NAME]

#define FACADE(TYPE, NAME)      [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryFacade type:TYPE name:NAME]
#define DEFAULTFACADE(NAME)     [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryFacade type:kAYFactoryManagerCommandTypeDefaultFacade name:NAME]

#define VIEW(TYPE, NAME)        [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryView type:TYPE name:NAME]
#define DELEGATE(TYPE, NAME)    [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryDelegate type:TYPE name:NAME]

#define MODEL                   [[AYFactoryManager sharedInstance] enumObjectWithCatigory:kAYFactoryManagerCatigoryModel type:kAYFactoryManagerCatigoryModel name:kAYFactoryManagerCatigoryModel]
#define LOGINMODEL              FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"LoginModel")
#define OWNERQUERYMODEL         FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"OwnerQueryModel")
#define OWNERQUERYPUSHMODEL     FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"OwnerQueryPushModel")
#define HOMECONTENTMODEL        FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"HomeQueryModel")
#define CHATSESSIONMODEL        FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"ChatSessionModel")

#define HOST                    ([[AYFactoryManager sharedInstance] queryServerHostRoute])

#define PNGRESOURCE(NAME)       ([[AYResourceManager sharedInstance] enumResourceImageWithName:NAME andExtension:@"png"])
#define GIFRESOURCE(NAME)       ([[AYResourceManager sharedInstance] enumGIFResourceURLWithName:NAME])


#ifdef DEBUG
#define CHECKCMD(CMD)           if (CMD == nil) {\
                                    NSLog(@"cmd name is %@", command_name); \
                                    [[[UIAlertView alloc]initWithTitle:@"error" message:@"cmd not register" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];}
#define CHECKFACADE(CMD)        if (CMD == nil) {\
                                    NSLog(@"cmd name is %@", facade_name); \
                                    [[[UIAlertView alloc]initWithTitle:@"error" message:@"facade not register" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];}
#else
#define CHECKCMD(CMD)
#define CHECKFACADE(CMD)
#endif

#define CURRENUSER(USER)            do { \
                                        id<AYFacadeBase> f_login_model = LOGINMODEL; \
                                        id<AYCommand> cmd = [f_login_model.commands objectForKey:@"QueryCurrentLoginUser"]; \
                                        [cmd performWithResult:&USER]; \
                                    } while(0);


#endif /* AYCommandDefines_h */
