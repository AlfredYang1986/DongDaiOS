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

static NSString* controller_file_name = @"controller";
static NSString* command_file_name = @"command";
static NSString* facade_file_name = @"facade";

static NSString* config_file_extention = @"xml";

static AYFactoryManager* instance = nil;


@implementation AYFactoryManager {
    NSMutableDictionary* factories;
    
    GDataXMLDocument* doc_controller;
    GDataXMLDocument* doc_command;
    GDataXMLDocument* doc_facade;
}

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
        }
        return self;
    }
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

/**
 * load configs files
 */
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

- (id)enumObjectWithCatigory:(NSString*)cat type:(NSString*)type name:(NSString*)name {
    id result = nil;
    NSString* key = [AYFactoryManager md5:[[cat stringByAppendingString:type] stringByAppendingString:name]];
//    NSString* key = [AYFactoryManager md5:[cat stringByAppendingString:name]];
    id<AYFactory> fac = [factories objectForKey:key];
    if (fac == nil) {
//        if ([cat isEqualToString:@"Command"]) {
        if ([cat isEqualToString:kAYFactoryManagerCatigoryCommand]) {
            NSArray* arr = nil;
            if ([type isEqualToString:kAYFactoryManagerCommandModule]) {
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
                fac = [[c alloc] init];
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:name forKey:@"name"];
                
                NSString* desController = [[arr.lastObject attributeForName:@"controller"] stringValue];
                if (desController != nil) {
                    [dic setObject:desController forKey:@"controller"];
                }

                fac.para = [dic copy];

            } else @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
        
//        } else if ([cat isEqualToString:@"Controller"]) {
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
                fac = [[c alloc] init];
               
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
                    id<AYCommand> cmd = FACADE([iter attributeForName:@"name"].stringValue);
                    [facades_dic setValue:cmd forKey:[iter attributeForName:@"name"].stringValue];
                }
                
               
                [dic setValue:[cmd_dic copy] forKey:@"commands"];
                [dic setValue:[facades_dic copy] forKey:@"facades"];
                [dic setValue:name forKey:@"controller"];
                fac.para = [dic copy];
                
            } else @throw [NSException exceptionWithName:@"Error" reason:@"wrong config files" userInfo:nil];
       
//        } else if ([cat isEqualToString:@"Facade"]) {
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
                fac = [[c alloc] init];
                
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
        }
       
        [factories setValue:fac forKey:key];
    }
    
    result = [fac createInstance];
    return result;
}

- (id<AYCommand>)enumCommandWithType:(NSString*)command_type andName:(NSString*)command_name {
    NSDictionary* t = [factories objectForKey:@"Command"];
    NSDictionary* ct = [t objectForKey:command_type];
    return [ct objectForKey:command_name];
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