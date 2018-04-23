//
//  AYTipView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYTipView.h"

@implementation AYTipView {
    
    UILabel *care;
    UILabel *careContent;
    UILabel *course;
    UILabel *courseContent;
    UILabel *experience;
    UILabel *experienceContent;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        care = [UILabel creatLabelWithText:@"看顾" textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:care];
        
        [care mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(16);
        }];
        
        careContent = [UILabel creatLabelWithText:@"噶考虑过建档立卡国家根据，打个卡了。国际嘎达科技的噶破打开。打个卡的京东到家，的感慨；大概；就" textColor:[UIColor gary115] font:[UIFont regularFontSF:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:careContent];
        
        [careContent mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self -> care.mas_bottom).offset(8);
            
        }];
        [careContent setNumberOfLines:0];
        
        course = [UILabel creatLabelWithText:@"课程" textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:course];
        
        [course mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.equalTo(self -> careContent.mas_bottom).offset(42);
            
        }];
        
        courseContent = [UILabel creatLabelWithText:@"噶考虑过建档立卡国家根据，打个卡了。国际嘎达科技的噶破打开。打个卡的京东到家，的感慨；大概；就" textColor:[UIColor gary115] font:[UIFont regularFontSF:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:courseContent];
        
        [courseContent mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self -> course.mas_bottom).offset(8);
            
        }];
        [courseContent setNumberOfLines:0];
        
        experience = [UILabel creatLabelWithText:@"课程" textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:experience];
        
        [experience mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.equalTo(self -> courseContent.mas_bottom).offset(42);
            
        }];
        
        experienceContent = [UILabel creatLabelWithText:@"噶考虑过建档立卡国家根据，打个卡了。国际嘎达科技的噶破打开。打个卡的京东到家，的感慨；大概；就" textColor:[UIColor gary115] font:[UIFont regularFontSF:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:experienceContent];
        
        [experienceContent mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self -> experience.mas_bottom).offset(8);
            
        }];
        [experienceContent setNumberOfLines:0];
        
    }
    return self;
}

@end
