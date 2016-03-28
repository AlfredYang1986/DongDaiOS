//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserInfoInputController.h"

#define NEXT_BTN_MARGIN_BOTTOM  80

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define SCREEN_PHOTO_TOP_MARGIN                 SCREEN_HEIGHT / 6
#define SCREEN_PHOTO_WIDTH                      100
#define SCREEN_PHOTO_HEIGHT                     100

#define SCREEN_PHOTO_2_GENDER_BTN_MARGIN        30

#define GENDER_BTN_WIDTH                        38
#define GENDER_BTN_HEIGHT                       GENDER_BTN_WIDTH

#define FATHER_ICON_WIDTH                       11.5
#define FATHER_ICON_HEIGHT                      FATHER_ICON_WIDTH

#define GENDER_BTN_BETWEEN_MARGIN               SCREEN_WIDTH / 4

#define INPUT_VIEW_2_SCREEN_PHOTO_MARGIN        (SCREEN_HEIGHT / 15 - 5)

#define TICK_BTN_WIDTH                          17
#define TICK_BTN_HEIGHT                         TICK_BTN_WIDTH

#define TICK_BTN_2_PRIVACY_MARGIN               10

@implementation AYUserInfoInputController {
    CGRect keyBoardFrame;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    id<AYCommand> nav_btn_cmd = [self.commands objectForKey:@"SetNevigationBarLeftBtn"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [nav_btn_cmd performWithResult:&dic];
    
    id<AYCommand> nav_title_cmd = [self.commands objectForKey:@"SetNevigationBarTitle"];
    NSMutableDictionary* dic_title = [[NSMutableDictionary alloc]init];
    [dic_title setValue:self forKey:kAYControllerActionSourceControllerKey];
    [nav_title_cmd performWithResult:&dic_title];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    /**
     * input method
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
//    inputView.isMoved = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark -- views layouts
- (id)UserScreenPhoteSelectLayout:(UIView*)view {
    return nil;
}

- (id)UserInfoInputLayout:(UIView*)view {
//    [view setUpWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT + INPUT_VIEW_2_SCREEN_PHOTO_MARGIN + view.frame.size.height / 2);
    return nil;
}

#pragma mark -- keyboard
- (void)keyboardDidShow:(NSNotification*)notification {
    UIView *result = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    for (UIView *tmpWindow in windowsArray) {
        NSArray *viewArray = [tmpWindow subviews];
        for (UIView *tmpView  in viewArray) {
            NSLog(@"%@", [NSString stringWithUTF8String:object_getClassName(tmpView)]);
            // if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIInputSetContainerView"]) {
                result = tmpView;
                break;
            }
        }
        
        if (result != nil) {
            break;
        }
    }
    
    //    keyboardView = result;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - (inputView.frame.size.height + inputView.frame.origin.y);
//    if (!inputView.isMoved) {
//        [self moveView:-height];
//    }
}

- (void)keyboardWasChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
}

- (void)keyboardDidHidden:(NSNotification*)notification {
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - (inputView.frame.size.height + inputView.frame.origin.y);
//    if (inputView.isMoved) {
//        [self moveView:height];
//    }
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
}
@end
