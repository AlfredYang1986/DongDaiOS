//
//  AYGroupChatController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYGroupChatController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#define BACK_BTN_WIDTH          23
#define BACK_BTN_HEIGHT         23
#define BOTTOM_MARGIN           10.5

#define INPUT_HEIGHT            37

#define INPUT_CONTAINER_HEIGHT  49

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

#define USER_BTN_WIDTH          40
#define USER_BTN_HEIGHT         23


#define USER_INFO_PANE_HEIGHT               194
#define USER_INFO_PANE_MARGIN               10.5
#define USER_INGO_PANE_BOTTOM_MARGIN        4
#define USER_INFO_PANE_WIDTH                width - 2 * USER_INFO_PANE_MARGIN
#define USER_INFO_CONTAINER_HEIGHT          USER_INFO_PANE_HEIGHT

#define USER_INFO_BACK_BTN_HEIGHT           30
#define USER_INFO_BACK_BTN_WIDTH            30

static NSString* const kAYGroupChatControllerMessageTable = @"Table";
static NSString* const kAYGroupChatControllerUserInfoTable = @"Table2";

@implementation AYGroupChatController {
    CGRect keyBoardFrame;
}
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIView* img = [self.views objectForKey:@"Image"];
    [self.view sendSubviewToBack:img];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];
   
    UIView* view_table = [self.views objectForKey:@"Table"];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [view_table addGestureRecognizer:tap];
}

#pragma mark -- layouts
- (id)GroupChatHeaderLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSNumber* height = nil;
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"querGroupChatViewHeight"];
    [cmd performWithResult:&height];
    
    view.frame = CGRectMake(0, 0, width, height.floatValue);
//    view.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor greenColor];
    
    NSString* str = @"Alfred Test";
    id<AYCommand> cmd_test = [((id<AYViewBase>)view).commands objectForKey:@"setGroupChatViewInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:str forKey:@"theme"];
    [cmd_test performWithResult:&dic];
    
    return nil;
}

- (id)ImageLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, height);
    ((UIImageView*)view).image = PNGRESOURCE(@"group_chat_bg_img");
    return nil;
}

- (id)TableLayout:(UIView*)view {
    
//    view.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor redColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;  // 去除表框
#define MARGIN_BETWEEN_TABVIEW_2_HEADER         20
#define MARGIN_BETWEEN_TABVIEW_2_BOTTOM         10
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSNumber* header_height = nil;
    
    id<AYViewBase> header = [self.views objectForKey:@"GroupChatHeader"];
    id<AYCommand> cmd = [header.commands objectForKey:@"querGroupChatViewHeight"];
    [cmd performWithResult:&header_height];
    
    view.frame = CGRectMake(0, header_height.floatValue + MARGIN_BETWEEN_TABVIEW_2_HEADER, width, height - header_height.floatValue - INPUT_CONTAINER_HEIGHT - MARGIN_BETWEEN_TABVIEW_2_BOTTOM - MARGIN_BETWEEN_TABVIEW_2_HEADER);
    return nil;
}

- (id)ChatInputLayout:(UIView*)view {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, height - INPUT_CONTAINER_HEIGHT, SCREEN_WIDTH, INPUT_CONTAINER_HEIGHT);
    view.backgroundColor = [UIColor yellowColor];
    return nil;
}

#pragma mark -- notifications

#pragma mark -- actions
#pragma mark -- get input view height
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
    
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    if (inputContainer.frame.origin.y + inputContainer.frame.size.height == height) {
//        [self moveView:-keyBoardFrame.size.height];
//    }
    
    //    if (isEmoji) {
    //        [emoji removeFromSuperview];
    //        emoji.frame = keyBoardFrame;
    //        [keyboardView addSubview:emoji];
    //        [keyboardView bringSubviewToFront:emoji];
    //    }
}

- (void)keyboardWasChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
}

- (void)keyboardDidHidden:(NSNotification*)notification {
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    if (inputContainer.frame.origin.y + inputContainer.frame.size.height != height) {
//        [self moveView:keyBoardFrame.size.height];
//    }
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
//    if (inputView.isFirstResponder) {
//        [inputView resignFirstResponder];
//    }
}
@end
