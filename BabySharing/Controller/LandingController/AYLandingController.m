//
//  AYLandingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingController.h"
#import "AYLogicFacade.h"
#import <objc/runtime.h>

#define LOGO_TOP_MARGIN 97

@implementation AYLandingController

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
   
    NSLog(@"command are : %@", self.commands);
    NSLog(@"facade are : %@", self.facades);
    NSLog(@"view are : %@", self.views);
}

- (void)btnSelected {
    NSLog(@"btn selected");
    id<AYFacadeBase> facade = [self.facades objectForKey:@"SNSWechat"];
//    id<AYCommand> cmd = [facade.commands objectForKey:@"LoginSNSWithQQ"];
    id<AYCommand> cmd = [facade.commands objectForKey:@"LoginSNSWithWechat"];
    NSString* result = nil;
    [cmd performWithResult:&result];
//    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"解耦合重构" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [view show];
}

#pragma mark -- views layouts
- (id)LandingTitleLayout:(UIView*)view {
    NSLog(@"Landing Title view layout");
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.center = CGPointMake(width / 2, LOGO_TOP_MARGIN + view.bounds.size.height / 2);
    
    return nil;
}
@end
