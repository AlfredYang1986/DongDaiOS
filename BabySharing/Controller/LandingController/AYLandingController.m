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
#import "AYViewBase.h"

typedef enum : NSUInteger {
    LandingStatusPrepare,
    LandingStatusReady,
    LandingStatusLoading,
} LandingStatus;

#define LOGO_TOP_MARGIN 97

#define INPUT_VIEW_TOP_MARGIN       ([UIScreen mainScreen].bounds.size.height / 6.0)
#define INPUT_VIEW_START_POINT      (title.frame.origin.y + title.frame.size.height + INPUT_VIEW_TOP_MARGIN)

@interface AYLandingController ()
@property (nonatomic, setter=setCurrentStatus:) LandingStatus landing_status;
@end

@implementation AYLandingController {
    CGRect keyBoardFrame;
    CGFloat modify;
    CGFloat diff;
    BOOL isUpAnimation;
}

@synthesize landing_status = _landing_status;

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

- (void)postPerform {
    self.landing_status = LandingStatusPrepare;
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
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
    NSLog(@"Landing SNS View view layout");
//    view.delegate = self;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat sns_height = view.bounds.size.height;
    view.frame = CGRectMake(0, height - sns_height, width, sns_height);
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    NSLog(@"Landing Loading View view layout");

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, height);
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

#pragma mark -- actions
- (void)handleTap:(UITapGestureRecognizer*)gueture {
    id<AYViewBase> view = [self.views objectForKey:@"LandingInput"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
}

#pragma mark -- status
- (void)setCurrentStatus:(LandingStatus)new_status {
    _landing_status = new_status;
    
    UIView* inputView = [self.views objectForKey:@"LandingInput"];
    UIView* sns_view = [self.views objectForKey:@"LandingSNS"];
    UIView* loading_view = [self.views objectForKey:@"Loading"];
    
    switch (_landing_status) {
        case LandingStatusReady: {
            inputView.hidden = NO;
            sns_view.hidden = NO;
            loading_view.hidden = YES;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"stopGif"] performWithResult:nil];
            }
            break;
        case LandingStatusPrepare:
        case LandingStatusLoading: {
            inputView.hidden = YES;
            sns_view.hidden = YES;
            loading_view.hidden = NO;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"startGif"] performWithResult:nil];
            }
            break;
        default:
            @throw [[NSException alloc]initWithName:@"Error" reason:@"登陆状态设置错误" userInfo:nil];
            break;
    }
}
@end
