//
//  AYPublishContainerView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPublishContainerView.h"
#import "AYCommandDefines.h"

#define FAKE_NAVIGATION_BAR_HEIGHT  64
#define BOTTON_BAR_HEIGHT           (149.0 / 667.0) * [UIScreen mainScreen].bounds.size.height
#define CARD_CONTENG_MARGIN             10.5

//@interface AYPublishContainerView () <UITextViewDelegate>
//@end

@implementation AYPublishContainerView {
    UITextView* descriptionView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle

#pragma mark -- commands
- (void)postPerform {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat img_height = width - 10.5 * 2; //width * aspectRatio;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0, img_height , width - 2 * CARD_CONTENG_MARGIN, height - img_height - FAKE_NAVIGATION_BAR_HEIGHT - BOTTON_BAR_HEIGHT - CARD_CONTENG_MARGIN)];
    descriptionView.font = [UIFont systemFontOfSize:15.0];
    //    _descriptionView.delegate = self;
    descriptionView.editable = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextViewTextDidChangeNotification object:descriptionView];
    //    [self.view addSubview:_descriptionView];
    
    UIView *view = [[UIView alloc] initWithFrame:descriptionView.frame];
    view.backgroundColor = [UIColor whiteColor];
    descriptionView.frame = CGRectInset(CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)), 9, 7);
    [view addSubview:descriptionView];
    [self addSubview:view];
    
    UILabel* placeholder = [[UILabel alloc]init];
    placeholder.font = [UIFont systemFontOfSize:15.0];
    placeholder.textColor = [UIColor colorWithRed:155.0 / 255.0 green:155.0 / 255.0 blue:155.0 / 255.0 alpha:1.0];
    placeholder.numberOfLines = 2;
    placeholder.text = @"一句话传递你的主张(18个字)";
    placeholder.textAlignment = NSTextAlignmentCenter;
    [placeholder sizeToFit];
    placeholder.frame = CGRectMake(12, img_height + 13, placeholder.frame.size.width, placeholder.frame.size.height);
    [self addSubview:placeholder];
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
- (void)textFieldChanged:(NSNotification*)notify {
    
}

#pragma mark -- messages
- (id)resignFirstResponed {
    [descriptionView resignFirstResponder];
    return nil;
}
@end
