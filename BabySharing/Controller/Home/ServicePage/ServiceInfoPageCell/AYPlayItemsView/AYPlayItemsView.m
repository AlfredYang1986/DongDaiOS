//
//  AYPlayItemsView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPlayItemsView.h"

@implementation AYPlayItemsView {
	UIButton *iconBtn;
}

- (instancetype)initWithTitle:(NSString*)title andIconName:(NSString*)iconName {
    self = [super init];
    if (self) {
		
		iconBtn = [[UIButton alloc] init];
		[iconBtn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
		[iconBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_enable", iconName]] forState:UIControlStateSelected];
		iconBtn.userInteractionEnabled = NO;
		[self addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UILabel *titleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools garyColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconBtn.mas_bottom).offset(12);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)setEnableStatusWith:(BOOL)isEnable {
	
	iconBtn.selected = isEnable;
	
}

@end
