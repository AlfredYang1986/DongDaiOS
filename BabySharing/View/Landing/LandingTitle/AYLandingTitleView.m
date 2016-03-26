//
//  AYLandingTitleView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingTitleView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"

#define LOGO_WIDTH     150
#define LOGO_HEIGHT     50

@implementation AYLandingTitleView

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;

- (void)postPerform {
    self.image = PNGRESOURCE(@"login_logo");
    self.bounds = CGRectMake(0, 0, LOGO_WIDTH, LOGO_HEIGHT);
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
