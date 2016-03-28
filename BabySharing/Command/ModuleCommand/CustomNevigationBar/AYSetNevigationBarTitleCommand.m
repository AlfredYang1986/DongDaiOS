//
//  AYSetNevigationBarTitleCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSetNevigationBarTitleCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import "AYResourceManager.h"
#import "AYControllerAcitionDefines.h"

@implementation AYSetNevigationBarTitleCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    UIViewController* controller = [dic objectForKey:kAYControllerActionSourceControllerKey];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"创建个人信息";
    label.font = [UIFont systemFontOfSize:18.f];
    [label sizeToFit];
    controller.navigationItem.titleView = label;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (void)didPopViewController {
    NSLog(@"pop command");
}
@end
