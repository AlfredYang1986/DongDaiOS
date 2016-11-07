//
//  AYPlayItemsView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPlayItemsView.h"

@implementation AYPlayItemsView

- (instancetype)initWithTitle:(NSString*)title andIconName:(NSString*)iconName {
    self = [super init];
    if (self) {
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:iconName];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        UILabel *titleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(icon.mas_bottom).offset(7);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
