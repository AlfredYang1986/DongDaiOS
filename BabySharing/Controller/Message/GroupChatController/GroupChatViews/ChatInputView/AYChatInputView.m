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
#import "Tools.h"

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
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [self.layer addSublayer:line];
    
    UIButton* sendBtn = [[UIButton alloc]init];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [sendBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(didSendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    
    inputView = [[UITextView alloc]init];
    inputView.delegate = self;
    inputView.backgroundColor = [UIColor clearColor];
    inputView.scrollEnabled = YES;
    inputView.font = [UIFont systemFontOfSize:14.f];
    inputView.showsVerticalScrollIndicator = NO;
    inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    inputView.returnKeyType = UIReturnKeySend;
    [self addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(sendBtn.mas_left).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UIImageView* img = [[UIImageView alloc]init];
    UIImage *bg = [UIImage imageNamed:@"group_chat_input_bg"];
    bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    img.image = bg;
    [self addSubview:img];
    [self sendSubviewToBack:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(inputView).insets(UIEdgeInsetsMake(-3, 0, -3, 0));
    }];
    
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

- (void)didSendMessageBtnClick {
    
    if ([inputView.text isEqualToString:@""]) {
        return;
    }
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendMessage:"];
    id args = inputView.text;
    [cmd performWithResult:&args];
    inputView.text = @"";
    
    [inputView resignFirstResponder];
}

- (id)setJoinerCount:(id)args {
    group_count.string = [NSString stringWithFormat:@"%d", ((NSNumber*)args).intValue];
    return nil;
}

- (id)resignFocus {
    [inputView resignFirstResponder];
    return nil;
}

- (id)regInputDelegate:(id)args {
    id<UITextViewDelegate> del = (id<UITextViewDelegate>)args;
    inputView.delegate = del;
    return nil;
}
@end
