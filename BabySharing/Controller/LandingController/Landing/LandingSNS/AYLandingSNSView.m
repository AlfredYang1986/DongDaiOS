//
//  AYLandingSNSView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingSNSView.h"
#import "AYCommandDefines.h"
#import "AYControllerBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#define BASICMARGIN     8

#define SNS_BUTTON_WIDTH                    36
#define SNS_BUTTON_HEIGHT                   SNS_BUTTON_WIDTH

#define SNS_BUTTON_MARGIN                   50

#define SNS_WECHAT                          0
#define SNS_QQ                              1
#define SNS_WEIBO                           2

#define SNS_COUNT                           3

#define INPUT_MARGIN                        32.5

#define MARGIN_MODIFY                       5

@implementation AYLandingSNSView {
    UIView* split_img;
    NSArray* sns_btns;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    self.bounds = CGRectMake(0, 0, width, 36);
    
    UIButton* wechat_btn = [[UIButton alloc]init];
    [self addSubview:wechat_btn];
    [wechat_btn setBackgroundImage:PNGRESOURCE(@"wechat_icon") forState:UIControlStateNormal];
    [wechat_btn addTarget:self action:@selector(wechatBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
    wechat_btn.clipsToBounds = YES;
    [wechat_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_offset(SNS_BUTTON_WIDTH);
        make.height.mas_offset(SNS_BUTTON_HEIGHT);
    }];
    
    UIButton* qq_btn = [[UIButton alloc]init];
    [qq_btn setBackgroundImage:PNGRESOURCE(@"qq_icon") forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(qqBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
    [self addSubview:qq_btn];
    [qq_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wechat_btn.mas_left).offset(-SNS_BUTTON_MARGIN);
        make.centerY.equalTo(wechat_btn);
        make.size.equalTo(wechat_btn);
    }];
    
    UIButton* weibo_btn = [[UIButton alloc]init];
    [weibo_btn setBackgroundImage:PNGRESOURCE(@"weibo_icon") forState:UIControlStateNormal];
    [weibo_btn addTarget:self action:@selector(weiboBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
    [self addSubview:weibo_btn];
    [weibo_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechat_btn.mas_right).offset(SNS_BUTTON_MARGIN);
        make.centerY.equalTo(wechat_btn);
        make.size.equalTo(wechat_btn);
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

- (void)qqBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:@"SNSQQ" andMessage:@"LoginSNSWithQQ" andArgs:nil];
}

- (void)weiboBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:@"SNSWeibo" andMessage:@"LoginSNSWithWeibo" andArgs:nil];
}

- (void)wechatBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:@"SNSWechat" andMessage:@"LoginSNSWithWechat" andArgs:nil];
}
@end
