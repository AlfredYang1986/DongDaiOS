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
#import <objc/message.h>
#import "AYRemoteCallCommand.h"
#import "AYNotifyDefines.h"
#import "AYRemoteCallDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"

#import "MBProgressHUD.h"

@implementation AYViewController{
    int count_loading;
    int time_count;
    NSTimer *timer_loding;
}


@synthesize para = _para;

@synthesize commands = _commands;
@synthesize views = _views;
@synthesize delegates = _delegates;
@synthesize facades = _facades;

@synthesize loading = _loading;

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
    
    count_loading = 0;
    
    for (NSString* view_name in self.views.allKeys) {
        NSLog(@"view name is : %@", view_name);
        SEL selector = NSSelectorFromString([[view_name stringByAppendingString:kAYViewLayoutSuffix] stringByAppendingString:@":"]);
        id (*func)(id, SEL, id) = (id(*)(id, SEL, id))[self methodForSelector:selector];
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
    [self clearController];
}

- (void)clearController {
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
                        id (*func)(id, SEL, BOOL, NSDictionary*)= (id (*)(id, SEL, BOOL, NSDictionary*))imp;
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

- (id)startRemoteCall:(id)obj {
//    count_loading ++;
//    
////        _loading = VIEW(@"Loading", @"Loading");
//    id<AYViewBase> loading = [self.views objectForKey:@"Loading"];
//    if (!loading) {
//        @throw [[NSException alloc]initWithName:@"configs no loadingView " reason:@"configs no loadingView " userInfo:nil];
//    }
//    ((UIView*)_loading).tag = -9999;
//    [self.view addSubview:((UIView*)loading)];
//    
//    id<AYCommand> cmd = [loading.commands objectForKey:@"startGif"];
//    [cmd performWithResult:nil];
//    
    
    time_count = 30;            //star a new remote, so reset time count to 30
    if (count_loading == 0) {
        time_count = 30;
        timer_loding = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [timer_loding fire];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
    }
    count_loading++;
    return nil;
}

- (id)endRemoteCall:(id)obj {
//    count_loading --;
//    if (count_loading == 0) {
//        
//        id<AYViewBase> loading = [self.views objectForKey:@"Loading"];
//        if (!loading) {
//            @throw [[NSException alloc]initWithName:@"configs no loadingView " reason:@"configs no loadingView " userInfo:nil];
//        }
//        id<AYCommand> cmd = [loading.commands objectForKey:@"stopGif"];
//        [cmd performWithResult:nil];
//        [((UIView*)_loading) removeFromSuperview];
//    }
    
    count_loading --;
    if (count_loading == 0) {
        [timer_loding invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
    
    return nil;
}

- (void)timerRun {
    time_count -- ;
    if (time_count == 0) {
        [timer_loding invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (id)OrderAccomplished:(id)args {
    
    UIViewController *activeVC = [Tools activityViewController];
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"CommentService");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:activeVC forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
    
    return nil;
}

@end
