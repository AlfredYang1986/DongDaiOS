//
//  AYViewCommandBase.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYViewCommand.h"
#import "AYCommandDefines.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation AYViewCommand

@synthesize para = _para;
@synthesize view = _view;
@synthesize method_name = _method_name;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    if ([self checkForArgs]) {
        NSLog(@"view : %@ and target : %@", _view, _method_name);
     
        SEL sel = NSSelectorFromString(_method_name);
        Method m = class_getClassMethod([((UIView*)_view) class], sel);
        IMP imp = method_getImplementation(m);
        id (*func)(id, SEL, ...) = imp;
        *obj = func(_view, sel);
    }
}

- (BOOL)checkForArgs {
    return _view != nil && _method_name != nil;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandView;
}
@end
