//
//  AYSetNevigationBarTitleCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSetNevigationBarTitleView.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import "AYResourceManager.h"
#import "AYControllerActionDefines.h"
#import "AYControllerBase.h"

@implementation AYSetNevigationBarTitleView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;

- (void)postPerform {
    self.text = @"创建个人信息";
    self.font = [UIFont systemFontOfSize:18.f];
    [self sizeToFit];
}

- (void)performWithResult:(NSObject**)obj {

}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
