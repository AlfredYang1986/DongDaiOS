//
//  AYApplySuccessView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYApplySuccessView.h"
#import "AYShadowRadiusView.h"

@implementation AYApplySuccessView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        UIImageView *icon = [[UIImageView alloc] init];
        
        [self addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.width.mas_equalTo(31);
            make.top.mas_equalTo(31);
            make.centerX.equalTo(self);
            
        }];
        
        [icon setImage:IMGRESOURCE(@"succeed_white")];
        
        UILabel *head = [UILabel creatLabelWithText:@"咚哒已经收到了你的申请\n我们会尽快与你联系" textColor:[UIColor white] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.top.equalTo(icon.mas_bottom).offset(46);
            
        }];
        
        AYShadowRadiusView *shadowView = [[AYShadowRadiusView alloc] initWithRadius:4 offSet:(CGSizeMake(-1, 10)) blur:3.0f color:[UIColor shadowColor]];
        
        [self addSubview:shadowView];
        
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(head.mas_bottom).offset(80);
            make.height.mas_equalTo(270);
            
        }];
        
        UILabel *tip = [UILabel creatLabelWithText:@"你也可以通过添加咚哒微信号\n联系我们" textColor:[UIColor gary115] font:[UIFont regularFont:17.0f] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        
        [shadowView addSubview:tip];
        
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(20);
            make.centerX.equalTo(shadowView);
            
        }];
        
        UIImageView *qrCode = [[UIImageView alloc] init];
        [shadowView addSubview:qrCode];
        
        [qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.width.mas_equalTo(99);
            make.centerX.equalTo(shadowView);
            make.top.equalTo(tip.mas_bottom).offset(19);
            
        }];
        
        [qrCode setImage:IMGRESOURCE(@"qrcode")];
        
        UIImageView *wechat = [[UIImageView alloc] init];
        [self addSubview:wechat];
        
        [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.width.mas_equalTo(20);
            make.centerX.equalTo(shadowView).offset(-55);
            make.centerY.equalTo(shadowView.mas_bottom).offset(-40);
            
        }];
        
        [wechat setImage:IMGRESOURCE(@"wechat_Shape")];
        [wechat setContentMode:(UIViewContentModeScaleAspectFit)];
        
        UILabel *name = [UILabel creatLabelWithText:@"dxjmama" textColor:[UIColor black] font:[UIFont mediumFont:24.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [shadowView addSubview:name];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(wechat);
            make.centerX.equalTo(shadowView).offset(20);
            
        }];
        [name setIsCopyable:YES];

        
    }
    return self;
}


@end
