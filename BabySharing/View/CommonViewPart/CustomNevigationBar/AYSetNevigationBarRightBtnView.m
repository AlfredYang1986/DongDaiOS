//
//  AYSetNevigationBarRightBtnView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNevigationBarRightBtnView.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import "AYControllerActionDefines.h"
#import "AYResourceManager.h"
#import "AYControllerBase.h"

#define FAKE_BAR_HEIGHT         44
#define STATUS_BAR_HEIGHT       20

#define BACK_BTN_LEFT_MARGIN    16 + 10

@implementation AYSetNevigationBarRightBtnView {
    CALayer* layer_btn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    self.frame = CGRectMake(0, 0, 25, 25);
    layer_btn = [CALayer layer];
    layer_btn.contents = (id)PNGRESOURCE(@"privacy_more").CGImage;
    layer_btn.frame = CGRectMake(0, 0, 25, 25);
    [self.layer addSublayer:layer_btn];
    //    self.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    [self addTarget:self action:@selector(rightItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)rightItemBtnClick{
    NSLog(@"right item btn click");
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"rightItemBtnClick"];
    [cmd performWithResult:nil];
}

- (id)changeTextBtn:(NSString*)text {
    [layer_btn removeFromSuperlayer];
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
    [self sizeToFit];
    return nil;
}

@end
