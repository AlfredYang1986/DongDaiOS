//
//  AYSetNevigationBarLeftBtnCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSetNevigationBarLeftBtnCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import "AYControllerAcitionDefines.h"
#import "AYResourceManager.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define FAKE_BAR_HEIGHT         44
#define STATUS_BAR_HEIGHT       20

#define BACK_BTN_LEFT_MARGIN    16 + 10

@implementation AYSetNevigationBarLeftBtnCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    UIViewController* controller = [dic objectForKey:kAYControllerActionSourceControllerKey];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    CALayer * layer_btn = [CALayer layer];
    layer_btn.contents = (id)PNGRESOURCE(@"dongda_back").CGImage;
    layer_btn.frame = CGRectMake(0, 0, 25, 25);
    [barBtn.layer addSublayer:layer_btn];
    barBtn.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchUpInside];
    
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (void)didPopViewController {
    NSLog(@"pop command");
}
@end
