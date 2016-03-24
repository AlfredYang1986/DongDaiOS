//
//  AYLandingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingController.h"

@implementation AYLandingController

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
   
    NSLog(@"command are : %@", self.commands);
    NSLog(@"facade are : %@", self.facades);
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(btnSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnSelected {
    NSLog(@"btn selected");
    id<AYCommand> cmd = [self.facades objectForKey:@"LoginSNSWithQQ"];
    NSString* result = nil;
    [cmd performWithResult:&result];
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"解耦合重构" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [view show];
}
@end
