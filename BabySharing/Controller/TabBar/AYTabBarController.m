//
//  AYTabBarController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTabBarController.h"
#import "AYCommandDefines.h"

// test
#import "AYTestTabBarController.h"

@implementation AYTabBarController

@synthesize para = _para;

@synthesize commands = _commands;
@synthesize facades = _facades;
@synthesize views = _views;
@synthesize delegates = _delegates;

#pragma mark -- commands
- (NSString*)getControllerName {
    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TabBar"] stringByAppendingString:kAYFactoryManagerControllersuffix];
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    *obj = self;
}

- (id)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {
    @throw [[NSException alloc]initWithName:@"error" reason:@"不要在苹果自建Controller中调用Command函数" userInfo:nil];
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    UIViewController *c1=[[AYTestTabBarController alloc]init];
    c1.view.backgroundColor=[UIColor greenColor];
    c1.tabBarItem.title=@"消息";
    c1.tabBarItem.image=[UIImage imageNamed:@"tab_recent_nor"];
    c1.tabBarItem.badgeValue=@"123";
   
    self.viewControllers = [NSArray arrayWithObjects:c1, nil];
}
@end
