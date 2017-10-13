//
//  AYSpecialTMAndStateView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSpecialTMAndStateView.h"

@implementation AYSpecialTMAndStateView

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
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



@end
