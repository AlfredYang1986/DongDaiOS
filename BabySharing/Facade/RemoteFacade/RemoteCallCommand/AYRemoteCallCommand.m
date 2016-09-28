//
//  AYRemoteCallCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "RemoteInstance.h"
#import "AYViewBase.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"

@implementation AYRemoteCallCommand

@synthesize para = _para;
@synthesize route = _route;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    @throw [[NSException alloc]initWithName:@"error" reason:@"异步调用函数不能调用同步函数" userInfo:nil];
}

- (void)beforeAsyncCall {
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallStartFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
}

- (void)endAsyncCall {
    
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallEndFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"request confirm code from sever: %@", args);

    [self beforeAsyncCall];
    dispatch_queue_t rq = dispatch_queue_create("remote call", nil);
    dispatch_async(rq, ^{
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingPrettyPrinted error:&error];

        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:self.route]];
        NSLog(@"request result from sever: %@", result);

        dispatch_async(dispatch_get_main_queue(), ^{
           
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                NSDictionary* reVal = [result objectForKey:@"result"];
                block(YES, reVal);
            } else {
                NSDictionary* reError = [result objectForKey:@"error"];
                block(NO, reError);
            }
           
            [self endAsyncCall];
        });
    });
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeRemote;
}
@end
