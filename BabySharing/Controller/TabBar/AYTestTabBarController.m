//
//  AYTestTabBarController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTestTabBarController.h"

@implementation AYTestTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* l = [[UILabel alloc]init];
    l.text = @"登录成功";
    [l sizeToFit];
    l.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self.view addSubview:l];
}
@end
