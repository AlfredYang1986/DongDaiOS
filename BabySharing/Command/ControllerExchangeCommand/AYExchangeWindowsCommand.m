//
//  AYExchangeWindowsCommand.m
//  BabySharing
//
//  Created by BM on 8/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYExchangeWindowsCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation AYExchangeWindowsCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"exchange window command perfrom");

    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionExchangeWindowsModuleValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"exchange windows 只能出来push 操作" userInfo:nil];
    }
    
//    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
    AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
    
//    if (source.navigationController == nil) {
//        @throw [[NSException alloc]initWithName:@"error" reason:@"push command source controler 必须是一个navigation controller" userInfo:nil];
//    }
    
    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
    if (tmp != nil) {
        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
        [dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
        [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        [des performWithResult:&dic_init];
    }
    
//    des.hidesBottomBarWhenPushed = YES;
//    [source.navigationController pushViewController:des animated:YES];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    app.window = [[UIWindow alloc] initWithFrame:screenBounds];
    [app.window makeKeyAndVisible];
    
    app.window.rootViewController = des;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

