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
#define INPUT_HEIGHT            33
#define INPUT_CONTAINER_HEIGHT  49
#define InputViewheight             64

@implementation AYChatInputView {
    CATextLayer* group_count;
    
    UIButton* sendBtn;
    UITextView* inputView;
    UILabel *placeHoldeLabel;
    
    CGFloat height_note;
    CGFloat keyBoardHeight;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
    line.backgroundColor = [Tools garyLineColor].CGColor;
    [self.layer addSublayer:line];
    
    sendBtn = [[UIButton alloc]init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [sendBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[Tools colorWithRED:176 GREEN:241 BLUE:236 ALPHA:1.f] forState:UIControlStateDisabled];
    [sendBtn addTarget:self action:@selector(didSendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 34));
    }];
    sendBtn.enabled = NO;
//    sendBtn.layer.cornerRadius = 2.f;
//    sendBtn.layer.borderColor = [Tools themeColor].CGColor;
//    sendBtn.layer.borderWidth = 1.f;
//    sendBtn.clipsToBounds = YES;
    
    inputView = [[UITextView alloc]init];
    inputView.delegate = self;
    inputView.backgroundColor = [UIColor clearColor];
    inputView.scrollEnabled = NO;
    inputView.font = [UIFont systemFontOfSize:14.f];
    inputView.showsVerticalScrollIndicator = YES;
    inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    inputView.returnKeyType = UIReturnKeySend;
    [self addSubview:inputView];
    [self bringSubviewToFront:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-70);
        make.height.mas_equalTo(INPUT_HEIGHT);
    }];
    height_note = INPUT_HEIGHT;
    
    placeHoldeLabel = [Tools creatLabelWithText:@"请输入" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:placeHoldeLabel];
    [placeHoldeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView);
        make.left.equalTo(inputView).offset(5);
    }];
    
//    UIImageView* img = [[UIImageView alloc]init];
//    UIImage *bg = [UIImage imageNamed:@"group_chat_input_bg"];
//    bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
//    img.image = bg;
//    [self addSubview:img];
//    [self sendSubviewToBack:img];
//    [img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(inputView).insets(UIEdgeInsetsMake(-3, 0, -3, 0));
//    }];
    
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

- (id)sendHeightNote:(NSNumber*)args {
    keyBoardHeight = args.floatValue;
    return nil;
}

#pragma mark -- uitextView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        if ([textView.text isEqualToString:@""]) {
            
        } else {
            id<AYCommand> cmd = [self.notifies objectForKey:@"sendMessage:"];
            id args = textView.text;
            [cmd performWithResult:&args];
            
            placeHoldeLabel.hidden = NO;
            textView.text = @"";
//            [textView resignFirstResponder];
            self.frame = CGRectMake(0, SCREEN_HEIGHT - InputViewheight - keyBoardHeight, SCREEN_WIDTH, InputViewheight);
            [inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-70);
                make.height.mas_equalTo(INPUT_HEIGHT);
            }];
            
            height_note = INPUT_HEIGHT;
        }
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([inputView.text isEqualToString:@""]) {
        placeHoldeLabel.hidden = NO;
        sendBtn.enabled = NO;
    } else {
        sendBtn.enabled = YES;
        placeHoldeLabel.hidden = YES;
    }
    
    CGSize maxSize = CGSizeMake(inputView.bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [inputView sizeThatFits:maxSize];
    
    if (newSize.height >= 66.5) {
        inputView.scrollEnabled = YES;
        return;
    }
    
    if (height_note != newSize.height) {
        
        self.frame = CGRectMake(0, self.frame.origin.y - (newSize.height-height_note) , SCREEN_WIDTH, self.frame.size.height + (newSize.height-height_note) );
        [inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-70);
            make.height.mas_equalTo(newSize.height);
        }];
        height_note = newSize.height;
    }
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
    
    placeHoldeLabel.hidden = NO;
    inputView.text = @"";
//    [inputView resignFirstResponder];
    self.frame = CGRectMake(0, SCREEN_HEIGHT - InputViewheight - keyBoardHeight, SCREEN_WIDTH, InputViewheight);
    [inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-70);
        make.height.mas_equalTo(INPUT_HEIGHT);
    }];
    height_note = INPUT_HEIGHT;
}

#pragma mark -- notifies
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
