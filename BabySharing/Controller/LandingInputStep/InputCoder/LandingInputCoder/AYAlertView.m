//
//  AYAlertView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAlertView.h"
#import "Tools.h"
#import "Masonry.h"

@implementation AYAlertView

- (instancetype)initWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor{
    self = [super init];
    if (self) {
//        self.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
        self.layer.cornerRadius = 20.f;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5];
        
        _titleLabel = [UILabel new];
        _titleLabel = [Tools setLabelWith:_titleLabel andText:title andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [_titleLabel sizeToFit];
        _titleSize = _titleLabel.frame.size;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
