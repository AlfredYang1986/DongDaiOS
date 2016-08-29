//
//  AYPayOptionView.m
//  BabySharing
//
//  Created by Alfred Yang on 29/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPayOptionView.h"
#import "AYCommandDefines.h"
#import "Tools.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"

#define WIDTH  self.frame.size.width
#define HEIGHT self.frame.size.height
#define MARGIN 10.f

@implementation AYPayOptionView {
    NSString *dayDate;
    NSString *post_time;
    NSString *get_time;
    
    UILabel *costLabel;
    UILabel *dateLabel;
    
    UIButton *selectedpay01;
    
    UIButton *morePayWay;
    /******/
    UILabel *payTitle02;
    UIImageView *payIcon02;
    UIButton *selectedPay02;
    
    UIView *line02;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    
    UILabel *costHead = [[UILabel alloc]init];
    costHead = [Tools setLabelWith:costHead andText:@"价格" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [self addSubview:costHead];
    [costHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
    }];
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    line.backgroundColor = [Tools garyColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(costHead.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@1);
    }];
    
    UILabel *costTitle = [[UILabel alloc]init];
    [self addSubview:costTitle];
    costTitle = [Tools setLabelWith:costTitle andText:@"费用" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [costTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.top.equalTo(line.mas_bottom).offset(15);
    }];
    
    costLabel = [[UILabel alloc]init];
    [self addSubview:costLabel];
    costLabel = [Tools setLabelWith:costLabel andText:@"¥ 120" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(costTitle);
    }];
    
    UIView *rule = [[UIView alloc]init];
    [self addSubview:rule];
    rule.backgroundColor = [Tools garyBackgroundColor];
    [rule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(costTitle.mas_bottom).offset(20);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@10);
    }];
    
    /**************************/
    UILabel *PayHead = [[UILabel alloc]init];
    PayHead = [Tools setLabelWith:PayHead andText:@"付款" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [self addSubview:PayHead];
    [PayHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rule.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
    }];
    
    UIView *line00 = [[UIView alloc]init];
    [self addSubview:line00];
    line00.backgroundColor = [Tools garyColor];
    [line00 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PayHead.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *payIcon01 = [[UIImageView alloc]initWithImage:IMGRESOURCE(@"tab_found_selected")];
    [self addSubview:payIcon01];
    [payIcon01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line00.mas_bottom).offset(20);
        make.left.equalTo(self).offset(25);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *payTitle01 = [[UILabel alloc]init];
    [self addSubview:payTitle01];
    payTitle01 = [Tools setLabelWith:payTitle01 andText:@"支付宝" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [payTitle01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payIcon01.mas_right).offset(10);
        make.centerY.equalTo(payIcon01);
    }];
    
    selectedpay01 = [[UIButton alloc]init];
    [self addSubview:selectedpay01];
    [selectedpay01 setImage:IMGRESOURCE(@"tab_found") forState:UIControlStateNormal];
    [selectedpay01 setImage:IMGRESOURCE(@"tab_found_selected") forState:UIControlStateSelected];
    [selectedpay01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payIcon01);
        make.right.equalTo(self).offset(-25);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIView *line01 = [[UIView alloc]init];
    [self addSubview:line01];
    line01.backgroundColor = [Tools garyColor];
    [line01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payTitle01.mas_bottom).offset(20);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.mas_equalTo(0.5);
    }];
    
    /*--------------------------*/
    
    morePayWay = [[UIButton alloc]init];
    [self addSubview:morePayWay];
    [morePayWay setTitle:@"更多支付方式" forState:UIControlStateNormal];
    [morePayWay setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [morePayWay setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    morePayWay.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [morePayWay setImage:IMGRESOURCE(@"landing_input_triangle") forState:UIControlStateNormal];
    [morePayWay setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
    [morePayWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line01.mas_bottom).offset(20);
        make.left.equalTo(line01);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    morePayWay.hidden = NO;
    [morePayWay addTarget:self action:@selector(showMorePayWay:) forControlEvents:UIControlEventTouchDown];
    /*--------------------------*/
    
    payIcon02 = [[UIImageView alloc]initWithImage:IMGRESOURCE(@"tab_found_selected")];
    [self addSubview:payIcon02];
    [payIcon02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line01.mas_bottom).offset(20);
        make.left.equalTo(line01);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    payTitle02 = [[UILabel alloc]init];
    [self addSubview:payTitle02];
    payTitle02  = [Tools setLabelWith:payTitle02 andText:@"微信" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [payTitle02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payIcon02.mas_right).offset(10);
        make.centerY.equalTo(payIcon02);
    }];
    
    selectedPay02 = [[UIButton alloc]init];
    [self addSubview:selectedPay02];
    [selectedPay02 setImage:IMGRESOURCE(@"tab_found") forState:UIControlStateNormal];
    [selectedPay02 setImage:IMGRESOURCE(@"tab_found_selected") forState:UIControlStateSelected];
    [selectedPay02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payIcon02);
        make.right.equalTo(line01);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [selectedpay01 addTarget:self action:@selector(didChangePayWay:) forControlEvents:UIControlEventTouchUpInside];
    [selectedPay02 addTarget:self action:@selector(didChangePayWay:) forControlEvents:UIControlEventTouchUpInside];
    
    line02 = [[UIView alloc]init];
    [self addSubview:line02];
    line02.backgroundColor = [Tools garyColor];
    [line02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payIcon02.mas_bottom).offset(20);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    payIcon02.hidden = YES;
    payTitle02.hidden = YES;
    selectedPay02.hidden = YES;
    line02.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -- commands
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
- (void)showMorePayWay:(UIButton*)btn {
    payIcon02.hidden = NO;
    payTitle02.hidden = NO;
    selectedPay02.hidden = NO;
    line02.hidden = NO;
    
    morePayWay.hidden = YES;
}

- (void)didChangePayWay:(UIButton*)btn {
    if (btn == selectedpay01) {
        selectedpay01.selected = YES;
        selectedPay02.selected = NO;
    } else {
        selectedPay02.selected = YES;
        selectedpay01.selected = NO;
    }
}

#pragma mark -- notifies
-(id)queryDateSetAlready{
    
    return dateLabel.text;
}

@end
