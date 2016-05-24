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
#import "AYFactoryManager.h"

#import "WeiboSDK.h"
// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "Providers.h"
#import "Providers+ContextOpt.h"
#import "AYModelFacade.h"
#import "AYQueryModelDefines.h"

#define BOTTON_BAR_HEIGHT           (149.0 / 667.0) * [UIScreen mainScreen].bounds.size.height
#define SNS_BUTTON_WIDTH            25
#define SNS_BUTTON_HEIGHT           SNS_BUTTON_WIDTH
@interface AYSharingSNSView(){
    BOOL isClickAleart;
}

@end

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
   
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    isClickAleart = NO;
    
    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"多平台同步分享";
    [label sizeToFit];
    [self addSubview:label];
//    label.center = CGPointMake(width / 2, BOTTON_BAR_HEIGHT / 3);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset( - BOTTON_BAR_HEIGHT / 6);
    }];
    
//    UIButton* wechat_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    UIButton* wechat_btn = [[UIButton alloc] init];
    wechat_btn.tag = 11;
    [self addSubview:wechat_btn];
    UIImage * wechat_image = PNGRESOURCE(@"friendShip");
    UIImage * wechat_image_click = PNGRESOURCE(@"friendShip_select");
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn setBackgroundImage:wechat_image_click forState:UIControlStateSelected];
    [wechat_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
//    wechat_btn.center = CGPointMake(width / 2 , BOTTON_BAR_HEIGHT * 2 / 3);
    [wechat_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(BOTTON_BAR_HEIGHT / 6);
        make.width.mas_offset(SNS_BUTTON_WIDTH);
        make.height.mas_offset(SNS_BUTTON_HEIGHT);
    }];
    
    UIButton* qq_btn = [[UIButton alloc]init];
    qq_btn.tag = 10;
    [self addSubview:qq_btn];
    UIImage * qq_image = PNGRESOURCE(@"login_qq");
    UIImage * qq_image_click = PNGRESOURCE(@"login_qq_clicked");
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn setBackgroundImage:qq_image_click forState:UIControlStateSelected];
    [qq_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
//    qq_btn.center = CGPointMake(width / 2 / 2, BOTTON_BAR_HEIGHT * 2 / 3);
    [qq_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wechat_btn.mas_left).offset(-80);
        make.centerY.equalTo(wechat_btn);
        make.size.equalTo(wechat_btn);
    }];
    
    // 同步到微博
    UIButton* weibo_btn = [[UIButton alloc]init];
    weibo_btn.tag = 12;
    [self addSubview:weibo_btn];
    UIImage * weibo_image = PNGRESOURCE(@"login_weibo");
    UIImage * weibo_image_click = PNGRESOURCE(@"login_weibo_clicked");
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn setBackgroundImage:weibo_image_click forState:UIControlStateSelected];
    [weibo_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
//    weibo_btn.center = CGPointMake(width * 0.75, BOTTON_BAR_HEIGHT * 2 / 3);
    [weibo_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechat_btn.mas_right).offset(80);
        make.centerY.equalTo(wechat_btn);
        make.size.equalTo(wechat_btn);
    }];
    
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
- (void)SNSBtnSelected:(UIButton*)btn {
    
    UIButton* qq = [self viewWithTag:10];
    UIButton* weixin = [self viewWithTag:11];
    UIButton* weibo = [self viewWithTag:12];
    
    if (btn.tag == 10 ) {
        if (weibo.selected || weixin.selected) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经选择了同步分享平台" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            return;
        }
        btn.selected = !btn.selected;
        NSMutableDictionary* qq_dic = [[NSMutableDictionary alloc]init];
        [qq_dic setValue:[NSNumber numberWithBool:btn.selected] forKey:@"BtnSelected"];
        id<AYCommand> cmd = [self.notifies objectForKey:@"SharingSNSWithQQ:"];
        [cmd performWithResult:&qq_dic];
    }
    if (btn.tag == 11 ) {
        if (weibo.selected || qq.selected) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经选择了同步分享平台" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            return;
        }
        btn.selected = !btn.selected;
        NSMutableDictionary* wechat_dic = [[NSMutableDictionary alloc]init];
        [wechat_dic setValue:[NSNumber numberWithBool:btn.selected] forKey:@"BtnSelected"];
        id<AYCommand> cmd = [self.notifies objectForKey:@"SharingSNSWithWechat:"];
        [cmd performWithResult:&wechat_dic];
    }
    if (btn.tag == 12 ) {
        if (qq.selected || weixin.selected) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经选择了同步分享平台" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            return;
        }
        AYModelFacade* fl = LOGINMODEL;
        CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:fl.doc.managedObjectContext];
        NSString* user_id = tmp.who.user_id;
        Providers* cur = [Providers enumProvideInContext:fl.doc.managedObjectContext ByName:@"weibo" andCurrentUserID:user_id];
        if (cur == nil) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"微博同步分享请先绑定微博或用微博登录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            return;
        }
        btn.selected = !btn.selected;
        NSMutableDictionary* weibo_dic = [[NSMutableDictionary alloc]init];
        [weibo_dic setValue:[NSNumber numberWithBool:btn.selected] forKey:@"BtnSelected"];
        id<AYCommand> cmd = [self.notifies objectForKey:@"SharingSNSWithWeibo:"];
        [cmd performWithResult:&weibo_dic];
    }
    
    
    
}
@end
