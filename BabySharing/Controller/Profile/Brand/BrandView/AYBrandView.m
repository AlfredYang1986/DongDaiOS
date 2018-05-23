//
//  AYBrandView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYBrandView.h"

@implementation AYBrandView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIImageView *icon = [[UIImageView alloc] init];
        
        [self addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(14);
            make.centerX.equalTo(self);
            make.height.width.mas_equalTo(72);
            
        }];
        
        [icon setImage:IMGRESOURCE(@"wechat_Shape")];
        [icon.layer setBorderColor:[UIColor gary217].CGColor];
        [icon.layer setBorderWidth:1];
        [icon.layer setCornerRadius:4.0f];
        [icon.layer setMasksToBounds:YES];
        
        [icon setContentMode:(UIViewContentModeScaleAspectFit)];
        
        UILabel *head = [UILabel creatLabelWithText:@"智优机器人" textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.top.equalTo(icon.mas_bottom).offset(16);
            
        }];
        
        UILabel *about = [UILabel creatLabelWithText:@"关于品牌" textColor:[UIColor black] font:[UIFont mediumFont:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:about];
        
        [about mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.equalTo(head.mas_bottom).offset(47);
        }];
        
        UILabel *content = [UILabel creatLabelWithText:@"品牌名称是发了空间发拉萨，反馈卡奥拉夫都是扣罚款。罚款联发科，打过来扩大及卡黄金进口。噶几哦刚打开来得及，更多；两个健康咖喱感觉到拉看见啦改革的。" textColor:[UIColor gary115] font:[UIFont regularFontSF:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:content];
        
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(about.mas_bottom).offset(16);
            
        }];
        
        [content setNumberOfLines:0];
        
        
    }
    return self;
}

@end
