//
//  AYChatInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChatInputView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"

#define INPUT_CONTAINER_HEIGHT  49

#define USER_BTN_WIDTH          40
#define USER_BTN_HEIGHT         23

#define BACK_BTN_WIDTH          23
#define BACK_BTN_HEIGHT         23
#define BOTTOM_MARGIN           10.5

#define INPUT_HEIGHT            37
    
#define INPUT_CONTAINER_HEIGHT  49

@interface AYChatInputView () <UITextViewDelegate>

@end

@implementation AYChatInputView {
    CATextLayer* group_count;
    UITextView* inputView;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.backgroundColor = [UIColor clearColor];
    
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, (INPUT_CONTAINER_HEIGHT - BACK_BTN_HEIGHT) / 2, BACK_BTN_WIDTH, BACK_BTN_HEIGHT)];
    backBtn.layer.borderColor = [UIColor blueColor].CGColor;
    [backBtn addTarget:self action:@selector(backBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:PNGRESOURCE(@"dongda_back") forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    inputView = [[UITextView alloc]init];
    CGFloat input_width = [UIScreen mainScreen].bounds.size.width - 8 - BACK_BTN_WIDTH - BOTTOM_MARGIN - USER_BTN_WIDTH - BOTTOM_MARGIN - 8;
    inputView.frame = CGRectMake(8 + BACK_BTN_WIDTH + BOTTOM_MARGIN, (INPUT_CONTAINER_HEIGHT - INPUT_HEIGHT) / 2 - 2, input_width, INPUT_HEIGHT);
    inputView.delegate = self;
    inputView.backgroundColor = [UIColor clearColor];
    inputView.inputView.backgroundColor = [UIColor redColor];
    inputView.scrollEnabled = NO;
    
    UIImageView* img = [[UIImageView alloc]init];
    img.image = PNGRESOURCE(@"group_chat_input_bg");
    img.frame = CGRectMake(0, 0, input_width, INPUT_HEIGHT);
    [inputView addSubview:img];
    [inputView sendSubviewToBack:img];
    
    [self addSubview:inputView];
    
    UIButton* userBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - USER_BTN_WIDTH - BOTTOM_MARGIN, (INPUT_CONTAINER_HEIGHT - BACK_BTN_HEIGHT) / 2, USER_BTN_WIDTH, USER_BTN_HEIGHT)];
    [userBtn addTarget:self action:@selector(inputView2UserInfo) forControlEvents:UIControlEventTouchDown];
    CALayer* layer = [CALayer layer];
    layer.contents = (id)PNGRESOURCE(@"group_chat_head").CGImage;
    layer.frame = CGRectMake(0, 0, 16, 16);
    layer.position = CGPointMake(12, USER_BTN_HEIGHT / 2);
    [userBtn.layer addSublayer: layer];
    
    if (group_count == nil) {
        group_count = [CATextLayer layer];
//        group_count.string = [NSString stringWithFormat:@"%d", _joiner_count.intValue];
        group_count.string = [NSString stringWithFormat:@"%d", 0];
        group_count.foregroundColor = [UIColor colorWithWhite:0.2902 alpha:1.f].CGColor;
        group_count.fontSize = 14.f;
        group_count.contentsScale = 2.f;
        group_count.alignmentMode = @"center";
        group_count.frame = CGRectMake(0 + 16 + 8, 0, 30, USER_BTN_HEIGHT);
        group_count.position = CGPointMake(0 + 16 + 14, USER_BTN_HEIGHT / 2 + 3);
        [userBtn.layer addSublayer:group_count];
    }
    
    [self addSubview:userBtn];
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
- (void)backBtnSelected {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didSelectedBackBtn"];
    [cmd performWithResult:nil];
}

- (void)inputView2UserInfo {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didSelectedUserInfoBtn"];
    [cmd performWithResult:nil];
}

- (id)resignFocus {
    [inputView resignFirstResponder];
    return nil;
}
@end
