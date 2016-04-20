//
//  AYTagPreviewView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagPreviewView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"

@implementation AYTagPreviewView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)layoutSubviews {
    UILabel* label = [self viewWithTag:-99];
    label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

#pragma mark -- commands
- (void)postPerform {
    UILabel* label = [[UILabel alloc]init];
    label.text = @"记录时刻，标记生活";
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    label.tag = -99;
    [self addSubview:label];
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
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
@end
