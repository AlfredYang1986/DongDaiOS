//
//  AYLoadingView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoadingView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "UIGifView.h"

@implementation AYLoadingView {
    UIGifView* gif;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
   
    NSURL* url = GIFRESOURCE(@"home_refresh");
    gif = [[UIGifView alloc]initWithCenter:CGPointMake(width / 2, height / 2) fileURL:url andSize:CGSizeMake(30, 30)];
    [self addSubview:gif];
    
    self.userInteractionEnabled = NO;
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

- (id)startGif {
    [gif startGif];
    return nil;
}

- (id)stopGif {
    [gif stopGif];
    return nil;
}


@end
