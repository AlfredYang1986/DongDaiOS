//
//  AYTestTabBarController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTestTabBarController.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacade.h"

@implementation AYTestTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* l = [[UILabel alloc]init];
    l.text = @"登录成功";
    [l sizeToFit];
    l.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self.view addSubview:l];
    
    AYFacade* f = LOGINMODEL;
    id<AYCommand> cmd = [f.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
    NSLog(@"current login user is %@", obj);
}
@end
