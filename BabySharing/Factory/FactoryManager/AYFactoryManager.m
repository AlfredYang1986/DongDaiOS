//
//  AYFactoryManager.m
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFactoryManager.h"
#import "GDataXMLNode.h"
#import "AYFactory.h"
#import "AYCommandDefines.h"

#import "CommonCrypto/CommonDigest.h"
#import <objc/runtime.h>

static NSString* controller_file_name = @"controller";
static NSString* command_file_name = @"command";
static NSString* facade_file_name = @"facade";
static NSString* view_file_name = @"view";
static NSString* model_file_name = @"model";
static NSString* remote_file_name = @"remote";

static NSString* config_file_extention = @"xml";

static AYFactoryManager* instance = nil;

@implementation AYFactoryManager {
    NSMutableDictionary* factories;
    
    GDataXMLDocument* doc_controller;
    GDataXMLDocument* doc_command;
    GDataXMLDocument* doc_facade;
    GDataXMLDocument* doc_view;
    GDataXMLDocument* doc_model;
    
    NSString* host_route;
}

#pragma mark -- init
+ (AYFactoryManager*)sharedInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+ (id) allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)init {
    @synchronized(self) {
        self = [super init];
        if (self) {
            factories = [[NSMutableDictionary alloc]init];
            [self loadControllersConfigs];
            [self loadCommandsConfigs];
            [self loadFacadeConfigs];
            [self loadViewConfigs];
            [self loadModelConfigs];
            [self loadHostConfigs];
        }
        return self;
    }
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark -- load configs
- (GDataXMLDocument*)loadConfigWithName:(NSString*)fileName andExtention:(NSString*)extention {
    NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:extention];
    return [[GDataXMLDocument alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding  error:NULL];
}

- (void)loadControllersConfigs {
    if (doc_controller == nil)
        doc_controller = [self loadConfigWithName:controller_file_name andExtention:config_file_extention];
}

- (void)loadCommandsConfigs {
    if (doc_command == nil)
        doc_command = [self loadConfigWithName:command_file_name andExtention:config_file_extention];
}

- (void)loadFacadeConfigs {
    if (doc_facade == nil)
        doc_facade = [self loadConfigWithName:facade_file_name andExtention:config_file_extention];
}

- (void)loadViewConfigs {
    if (doc_view == nil)
        doc_view = [self loadConfigWithName:view_file_name andExtention:config_file_extention];
}

- (void)loadModelConfigs {
    if (doc_model == nil)
        doc_model = [self loadConfigWithName:model_file_name andExtention:config_file_extention];
}

- (void)loadHostConfigs {
    GDataXMLDocument* doc_remote = [self loadConfigWithName:remote_file_name andExtention:config_file_extention];
#ifdef SANDBOX
    NSArray* arr = [doc_remote nodesForXPath:@"//sandbox" error:nil];
#else
    NSArray* arr = [doc_remote nodesForXPath:@"//remote" error:nil];
#endif
    if (arr.count == 1) {
        host_route = [[arr.lastObject attributeForName:@"host"] stringValue];
    } else @throw [[NSException alloc]initWithName:@"Error" reason:@"remote config file error" userInfo:nil];
}

#pragma mark -- query Commands
- (id)enumObjectWithCatigory:(NSString*)cat type:(NSString*)type name:(NSString*)name {
    id result = nil;
    NSString* key = [AYFactoryManager md5:[[cat stringByAppendingString:type] stringByAppendingString:name]];
    id<AYFactory> fac = [factories objectForKey:key];
    if (fac == nil) {
        if ([cat isEqualToString:kAYFactoryManagerCatigoryCommand]) {
            NSArray* arr = nil;
            if ([type isEqualToString:kAYFactoryManagerCommandTypeModule]) {
                arr = [doc_command nodesForXPath:[[@"//command[@name='" stringByAppendingString:name] stringByAppendingString:@"']"] error:NULL];
            } else if ([type isEqualToString:kAYFactoryManagerCommandTypeRemote]) {
                arr = [doc_command nodesForXPath:[[@"//command[@name='" stringByAppendingString:name] stringByAppendingString:@"']"] error:NULL];
            } else {
                arr = [doc_command nodesForXPath:[[@"//command[@name='" stringByAppendingString:[name lowercaseString]] stringByAppendingString:@"']"] error:NULL];
            }
            
            NSLog(@"arr is : %@", arr);
            if (arr.count == 1) {
                
                NSString* factoryName = [[arr.lastObject attributeForName:@"factory"] stringValue];
                Class c = NSClassFromString(factoryName);
                if (c == nil) {
                    @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
                }
                Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
                IMP im = method_getImplementation(m);
                fac = im(c, @selector(factoryInstance));
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:name forKey:@"name"];
                
                NSString* desController = [[arr.lastObject attributeForName:@"controller"] stringValue];
                if (desController != nil) {
                    [dic setObject:desController forKey:@"controller"];
                }
                
                if ([type isEqualToString:kAYFactoryManagerCommandTypeRemote]) {
                    [dic setValue:[arr.lastObject attributeForName:@"route"].stringValue forKey:@"route"];
                }

                fac.para = [dic copy];

            } else @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
        
        } else if ([cat isEqualToString:kAYFactoryManagerCatigoryController]) {
            NSArray* arr = [doc_controller nodesForXPath:[[@"//controller[@name='" stringByAppendingString:name] stringByAppendingString:@"']"] error:NULL];
            NSLog(@"controller arr is : %@", arr);
            if (arr.count == 1) {
               
                GDataXMLElement* node = arr.lastObject;
                NSString* factoryName = [[node attributeForName:@"factory"] stringValue];
                Class c = NSClassFromString(factoryName);
                if (c == nil) {
                    @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
                }
                Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
                IMP im = method_getImplementation(m);
                fac = im(c, @selector(factoryInstance));
               
                NSArray* cmds = [node nodesForXPath:@"command" error:nil];
                NSLog(@"controller commands : %@", cmds);
               
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];

                NSMutableDictionary* cmd_dic = [[NSMutableDictionary alloc]init];
                for (GDataXMLElement* iter in cmds) {
                    id<AYCommand> cmd = COMMAND([iter attributeForName:@"type"].stringValue, [iter attributeForName:@"name"].stringValue);
                    [cmd_dic setValue:cmd forKey:[iter attributeForName:@"name"].stringValue];
                }
                
                NSArray* facades = [node nodesForXPath:@"facade" error:nil];
                NSLog(@"controller facade: %@", cmds);
                
                NSMutableDictionary* facades_dic = [[NSMutableDictionary alloc]init];
                for (GDataXMLElement* iter in facades) {
                    id<AYCommand> cmd = FACADE([iter attributeForName:@"type"].stringValue, [iter attributeForName:@"name"].stringValue);
                    [facades_dic setValue:cmd forKey:[iter attributeForName:@"name"].stringValue];
                }
                
                NSArray* views = [node nodesForXPath:@"view" error:nil];
                NSLog(@"controller views: %@", views);

                NSMutableDictionary* views_dic = [[NSMutableDictionary alloc]init];
                for (GDataXMLElement* iter in views) {
                    id<AYCommand> cmd = VIEW([iter attributeForName:@"type"].stringValue, [iter attributeForName:@"name"].stringValue);
                    [views_dic setValue:cmd forKey:[iter attributeForName:@"name"].stringValue];
                }
                
                [dic setValue:[cmd_dic copy] forKey:@"commands"];
                [dic setValue:[facades_dic copy] forKey:@"facades"];
                [dic setValue:[views_dic copy] forKey:@"views"];
                [dic setValue:name forKey:@"controller"];
                fac.para = [dic copy];
                
            } else @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
       
        } else if ([cat isEqualToString:kAYFactoryManagerCatigoryFacade]) {
            
            NSArray* arr = [doc_facade nodesForXPath:[[@"//facade[@name='" stringByAppendingString:name] stringByAppendingString:@"']"] error:NULL];
            NSLog(@"facade arr is : %@", arr);
            if (arr.count == 1) {
                
                GDataXMLElement* node = arr.lastObject;
                NSString* factoryName = [[node attributeForName:@"factory"] stringValue];
                Class c = NSClassFromString(factoryName);
                if (c == nil) {
                    @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
                }
                Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
                IMP im = method_getImplementation(m);
                fac = im(c, @selector(factoryInstance));
                
                NSArray* cmds = [node nodesForXPath:@"command" error:nil];
                NSLog(@"controller commands : %@", cmds);
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                
                NSMutableDictionary* cmd_dic = [[NSMutableDictionary alloc]init];
                for (GDataXMLElement* iter in cmds) {
                    id<AYCommand> cmd = COMMAND([iter attributeForName:@"type"].stringValue, [iter attributeForName:@"name"].stringValue);
                    [cmd_dic setValue:cmd forKey:[iter attributeForName:@"name"].stringValue];
                }
                
                [dic setValue:[cmd_dic copy] forKey:@"commands"];
                [dic setValue:name forKey:@"facade"];
                fac.para = [dic copy];
                
            } else @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
        
        } else if ([cat isEqualToString:kAYFactoryManagerCatigoryView]) {
            
            NSArray* arr = [doc_view nodesForXPath:[[@"//view[@name='" stringByAppendingString:name] stringByAppendingString:@"']"] error:NULL];
            NSLog(@"view arr is : %@", arr);
            if (arr.count == 1) {
                
                GDataXMLElement* node = arr.lastObject;
                NSString* factoryName = [[node attributeForName:@"factory"] stringValue];
                Class c = NSClassFromString(factoryName);
                if (c == nil) {
                    @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
                }
                Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
                IMP im = method_getImplementation(m);
                fac = im(c, @selector(factoryInstance));
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];

                NSMutableArray * cmd_dic = [[NSMutableArray alloc]init];
                NSArray* cmds = [node nodesForXPath:@"command" error:nil];
                NSLog(@"controller commands : %@", cmds);

                for (GDataXMLElement* iter in cmds) {
                    NSString* cmd = [iter attributeForName:@"message"].stringValue;
                    [cmd_dic addObject:cmd];
                }
                
                [dic setValue:name forKey:@"view"];
                [dic setValue:[cmd_dic copy] forKey:@"commands"];
                fac.para = [dic copy];
                
            } else @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
        
        } else if ([cat isEqualToString:kAYFactoryManagerCatigoryModel]) {
            
            NSArray* arr = [doc_model nodesForXPath:@"//model[@name='model']" error:NULL];
            NSLog(@"model arr is : %@", arr);
            if (arr.count == 1) {
                
                GDataXMLElement* node = arr.lastObject;
                NSString* factoryName = [[node attributeForName:@"factory"] stringValue];
                Class c = NSClassFromString(factoryName);
                if (c == nil) {
                    @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
                }
                Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
                IMP im = method_getImplementation(m);
                fac = im(c, @selector(factoryInstance));
               
                NSArray* cmds = [node nodesForXPath:@"command" error:nil];
                NSLog(@"controller commands : %@", cmds);
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                
                NSMutableDictionary* cmd_dic = [[NSMutableDictionary alloc]init];
                for (GDataXMLElement* iter in cmds) {
                    id<AYCommand> cmd = COMMAND([iter attributeForName:@"type"].stringValue, [iter attributeForName:@"name"].stringValue);
                    [cmd_dic setValue:cmd forKey:[iter attributeForName:@"name"].stringValue];
                }
                
                NSArray* facades = [node nodesForXPath:@"facade" error:nil];
                NSLog(@"controller facade: %@", cmds);
                
                NSMutableDictionary* facades_dic = [[NSMutableDictionary alloc]init];
                for (GDataXMLElement* iter in facades) {
                    id<AYCommand> cmd = FACADE([iter attributeForName:@"type"].stringValue, [iter attributeForName:@"name"].stringValue);
                    [facades_dic setValue:cmd forKey:[iter attributeForName:@"name"].stringValue];
                }
                
                [dic setValue:[facades_dic copy] forKey:@"facades"];
                [dic setValue:[cmd_dic copy] forKey:@"commands"];
                fac.para = [dic copy];
                
            } else @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
        }
       
        [factories setValue:fac forKey:key];
    }
    
    result = [fac createInstance];
    return result;
}

- (NSString*)queryServerHostRoute {
    return host_route;
}

+ (NSString*)md5:(NSString *)inPutText {
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end