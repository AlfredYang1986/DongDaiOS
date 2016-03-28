//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserInfoInputController.h"

@implementation AYUserInfoInputController {
    CGRect keyBoardFrame;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    NSLog(@"UserInfoInputController viewDidLoad %@", self);
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
