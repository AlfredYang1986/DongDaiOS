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

@implementation AYViewController
@synthesize para = _para;

@synthesize commands = _commands;
@synthesize views = _views;
@synthesize facades = _facades;

- (NSString*)getControllerName {
//    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"Landing"] stringByAppendingString:kAYFactoryManagerControllersuffix];
    return NSStringFromClass([self class]);
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (void)viewDidLoad {
//    self.view.backgroundColor = [UIColor redColor];
    
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
//    [self postPerform];
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

- (void)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {
    if (facade_name == nil) {
        id<AYCommand> cmd = [self.commands objectForKey:command_name];
        CHECKCMD(cmd);
        cmd.para = args;
        [cmd performWithResult:nil];
    } else {
        id<AYFacadeBase> facade = [self.facades objectForKey:facade_name];
        CHECKFACADE(facade);
        id<AYCommand> cmd = [facade.commands objectForKey:command_name];
        CHECKCMD(cmd);
        cmd.para = args;
        [cmd performWithResult:nil];
    }
}

@end
