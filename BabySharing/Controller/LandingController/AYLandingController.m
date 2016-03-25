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

#define INPUT_VIEW_TOP_MARGIN       ([UIScreen mainScreen].bounds.size.height / 6.0)
#define INPUT_VIEW_START_POINT      (title.frame.origin.y + title.frame.size.height + INPUT_VIEW_TOP_MARGIN)

@implementation AYLandingController

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
   
    NSLog(@"command are : %@", self.commands);
    NSLog(@"facade are : %@", self.facades);
    NSLog(@"view are : %@", self.views);
}

//- (void)btnSelected {
//    NSLog(@"btn selected");
//    id<AYFacadeBase> facade = [self.facades objectForKey:@"SNSWechat"];
////    id<AYCommand> cmd = [facade.commands objectForKey:@"LoginSNSWithQQ"];
//    id<AYCommand> cmd = [facade.commands objectForKey:@"LoginSNSWithWechat"];
//    NSString* result = nil;
//    [cmd performWithResult:&result];
////    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"解耦合重构" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////    [view show];
//}

#pragma mark -- views layouts
- (id)LandingTitleLayout:(UIView*)view {
    NSLog(@"Landing Title view layout");
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.center = CGPointMake(width / 2, LOGO_TOP_MARGIN + view.bounds.size.height / 2);
    return nil;
}

- (id)LandingInputLayout:(UIView*)view {
    NSLog(@"Landing Input View view layout");
    CGFloat last_height = view.bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView* title = [self.views objectForKey:@"LandingTitle"];
    view.frame = CGRectMake(0, INPUT_VIEW_START_POINT, width, last_height);
    return nil;
}

- (id)LandingSNSLayout:(UIView*)view {
//    view.delegate = self;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat sns_height = view.bounds.size.height;
    view.frame = CGRectMake(0, height - sns_height, width, sns_height);
    return nil;
}
@end
