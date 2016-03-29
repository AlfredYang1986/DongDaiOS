//
//  AYSetNevigationBarLeftBtnCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSetNevigationBarLeftBtnView.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import "AYControllerActionDefines.h"
#import "AYResourceManager.h"
#import "AYControllerBase.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define FAKE_BAR_HEIGHT         44
#define STATUS_BAR_HEIGHT       20

#define BACK_BTN_LEFT_MARGIN    16 + 10

@implementation AYSetNevigationBarLeftBtnView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;


- (void)postPerform {
    self.frame = CGRectMake(0, 0, 25, 25);
    CALayer * layer_btn = [CALayer layer];
    layer_btn.contents = (id)PNGRESOURCE(@"dongda_back").CGImage;
    layer_btn.frame = CGRectMake(0, 0, 25, 25);
    [self.layer addSublayer:layer_btn];
//    self.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    [self addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchUpInside];
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

- (void)didPopViewController {
    NSLog(@"pop command");
   
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [_controller performForView:self andFacade:nil andMessage:@"Pop" andArgs:dic];
}
@end
