//
//  AYRemoteCallQueryCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallQueryCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "RemoteInstance.h"
#import "Tools.h"
#import "AYViewBase.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"

@implementation AYRemoteCallQueryCommand
- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"request confirm code from sever: %@", args);
    
    /**
     * 1. create a view and block user interactions
     */
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallStartFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
    
    /**
     * 2. call remote
     */
    dispatch_queue_t rq = dispatch_queue_create("remote call", nil);
    dispatch_async(rq, ^{
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:self.route]];
        NSLog(@"request result from sever: %@", result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                block(YES, result);
            } else {
                NSDictionary* reError = [result objectForKey:@"error"];
                block(NO, reError);
            }
            
            SEL sel = NSSelectorFromString(kAYRemoteCallEndFuncName);
            Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
            if (m) {
                id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
                func(cur, sel, name);
            }
        });
    });
}
@end
