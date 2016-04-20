//
//  AYSharingSNSView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSharingSNSView.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"

#define BOTTON_BAR_HEIGHT           (149.0 / 667.0) * [UIScreen mainScreen].bounds.size.height
#define SNS_BUTTON_WIDTH            25
#define SNS_BUTTON_HEIGHT           SNS_BUTTON_WIDTH

@implementation AYSharingSNSView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle

#pragma mark -- commands
- (void)postPerform {
//    SNS_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height - BOTTON_BAR_HEIGHT, width, BOTTON_BAR_HEIGHT)];
//    self.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"多平台同步分享";
    [label sizeToFit];
    CGFloat margin = 0;
    label.center = CGPointMake(width / 2, BOTTON_BAR_HEIGHT / 3);
    [self addSubview:label];
    
    margin -= 20;
    
    UIButton* qq_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    UIImage * qq_image = PNGRESOURCE(@"login_qq");
    UIImage * qq_image_click = PNGRESOURCE(@"login_qq_clicked");
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn setBackgroundImage:qq_image_click forState:UIControlStateSelected];
    [qq_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
    qq_btn.center = CGPointMake(width / 2 / 2, BOTTON_BAR_HEIGHT * 2 / 3);
    [self addSubview:qq_btn];
    
    UIButton* wechat_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    UIImage * wechat_image = PNGRESOURCE(@"friendShip");
    UIImage * wechat_image_click = PNGRESOURCE(@"friendShip_select");
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn setBackgroundImage:wechat_image_click forState:UIControlStateSelected];
    [wechat_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
    wechat_btn.center = CGPointMake(width / 2 , BOTTON_BAR_HEIGHT * 2 / 3);
    [self addSubview:wechat_btn];
    
    // 同步到微博
    UIButton* weibo_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    UIImage * weibo_image = PNGRESOURCE(@"login_weibo");
    UIImage * weibo_image_click = PNGRESOURCE(@"login_weibo_clicked");
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn setBackgroundImage:weibo_image_click forState:UIControlStateSelected];
    [weibo_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
    weibo_btn.center = CGPointMake(width * 0.75, BOTTON_BAR_HEIGHT * 2 / 3);
    [self addSubview:weibo_btn];
    
//    sns_buttons = @[wechat_btn, weibo_btn, qq_btn];
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
- (void)SNSBtnSelected:(UIButton*)sender {
    sender.selected = !sender.selected;
}
@end
