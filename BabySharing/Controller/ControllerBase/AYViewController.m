//
//  AYViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYViewLayoutDefines.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"
#import <objc/runtime.h>
#import "AYRemoteCallCommand.h"
#import "AYNotifyDefines.h"
#import "AYRemoteCallDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"

@implementation AYViewController
@synthesize para = _para;

@synthesize commands = _commands;
@synthesize views = _views;
@synthesize delegates = _delegates;
@synthesize facades = _facades;

- (NSString*)getControllerName {
//    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"Landing"] stringByAppendingString:kAYFactoryManagerControllersuffix];
    return NSStringFromClass([self class]);
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (void)viewDidLoad {
    NSLog(@"command are : %@", self.commands);
    NSLog(@"facade are : %@", self.facades);
    NSLog(@"view are : %@", self.views);
    NSLog(@"delegates are : %@", self.delegates);
    
    for (NSString* view_name in self.views.allKeys) {
        NSLog(@"view name is : %@", view_name);
        SEL selector = NSSelectorFromString([[view_name stringByAppendingString:kAYViewLayoutSuffix] stringByAppendingString:@":"]);
        IMP imp = [self methodForSelector:selector];
        id (*func)(id, SEL, ...) = imp;
        UIView* view = [self.views objectForKey:view_name];
        func(self, selector, view);
        ((id<AYViewBase>)view).controller = self;
        [self.view addSubview:view];
    }
    
    for (id<AYDelegateBase> delegate in self.delegates.allValues) {
        delegate.controller = self;
    }
}

- (void)dealloc {
    for (id<AYCommand> facade in self.facades.allValues) {
        NSMutableDictionary* reg = [[NSMutableDictionary alloc]init];
        [reg setValue:kAYNotifyActionKeyReceive forKey:kAYNotifyActionKey];
        [reg setValue:kAYNotifyFunctionKeyUnregister forKey:kAYNotifyFunctionKey];
        
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:self forKey:kAYNotifyControllerKey];
        
        [reg setValue:[args copy] forKey:kAYNotifyArgsKey];
        
        [facade performWithResult:&reg];
    }
    
    AYModel* m = MODEL;
    NSMutableDictionary* reg = [[NSMutableDictionary alloc]init];
    [reg setValue:kAYNotifyActionKeyReceive forKey:kAYNotifyActionKey];
    [reg setValue:kAYNotifyFunctionKeyUnregister forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:self forKey:kAYNotifyControllerKey];
    [reg setValue:[args copy] forKey:kAYNotifyArgsKey];
    [m performWithResult:&reg];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    for (id<AYCommand> cmd in self.commands.allValues) {
        [cmd postPerform];
    }

    for (id<AYCommand> cmd in self.facades.allValues) {
        [cmd postPerform];
    }
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    *obj = self;
}

- (id)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {
    id<AYCommand> cmd = nil;
    if (facade_name == nil) {
        cmd = [self.commands objectForKey:command_name];
        CHECKCMD(cmd);
    } else {
        id<AYFacadeBase> facade = [self.facades objectForKey:facade_name];
        CHECKFACADE(facade);
        cmd = [facade.commands objectForKey:command_name];
        CHECKCMD(cmd);
    }
    
    if ([cmd isKindOfClass:[AYRemoteCallCommand class]]) {
        dispatch_queue_t q = dispatch_queue_create("remote call", nil);
        dispatch_async(q, ^{
            [((AYRemoteCallCommand*)cmd) performWithResult:args andFinishBlack:^(BOOL success, NSDictionary * result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SEL selector = NSSelectorFromString([[command_name stringByAppendingString:kAYRemoteCallResultKey] stringByAppendingString:kAYRemoteCallResultArgsKey]);
                    IMP imp = [self methodForSelector:selector];
                    if (imp) {
                        id (*func)(id, SEL, ...) = imp;
                        func(self, selector, success, result);
                    }
                });
            }];
        });
    
    } else {
        [cmd performWithResult:&args];
    }
    return (id)args;
}
@end
