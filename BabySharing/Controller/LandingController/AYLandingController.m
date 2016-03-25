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

@implementation AYLandingController {
    CGRect keyBoardFrame;
    CGFloat modify;
    CGFloat diff;
    BOOL isUpAnimation;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
   
    isUpAnimation = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    NSLog(@"command are : %@", self.commands);
    NSLog(@"facade are : %@", self.facades);
    NSLog(@"view are : %@", self.views);
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

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

#pragma mark -- move views
- (void)keyBoardWillShow:(NSNotification *)notification {
    if (isUpAnimation) {
        return;
    }
    
    UIView* inputView = [self.views objectForKey:@"LandingInput"];
    UIView* title = [self.views objectForKey:@"LandingTitle"];
    
    isUpAnimation = !isUpAnimation;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    CGFloat maxY = CGRectGetMaxY(inputView.frame);
    diff = self.view.frame.size.height - maxY - keyBoardFrame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        inputView.center = CGPointMake(inputView.center.x, inputView.center.y + diff);
        title.alpha = 0.f;
//        title.center = CGPointMake(title.center.x, title.center.y + diff);
//        slg.center = CGPointMake(slg.center.x, slg.center.y + diff);
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    if (!isUpAnimation) {
        return;
    }
    UIView* inputView = [self.views objectForKey:@"LandingInput"];
    UIView* title = [self.views objectForKey:@"LandingTitle"];

    isUpAnimation = !isUpAnimation;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    [UIView animateWithDuration:0.3 animations:^{
        inputView.center = CGPointMake(inputView.center.x, inputView.center.y - diff);
        title.alpha = 1.f;
//        title.center = CGPointMake(title.center.x, title.center.y - diff);
//        slg.center = CGPointMake(slg.center.x, slg.center.y - diff);
    }];
}

- (void)handleTap:(UITapGestureRecognizer*)gueture {
    [self.view becomeFirstResponder];
}
@end
