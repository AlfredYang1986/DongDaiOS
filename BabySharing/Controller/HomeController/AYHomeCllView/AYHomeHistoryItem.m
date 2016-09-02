//
//  AYHomeHistoryItem.m
//  BabySharing
//
//  Created by Alfred Yang on 2/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeHistoryItem.h"
#import "Tools.h"
#import "Masonry.h"

@implementation AYHomeHistoryItem {
    UIImageView *mainImageView;
    UILabel *titleLabel;
    UIImageView *star_rang_icon;
    UILabel *contentCountlabel;
    
    UILabel *psLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.layer.doubleSided = NO;
    
    mainImageView = [[UIImageView alloc]init];
    mainImageView.backgroundColor = [Tools garyBackgroundColor];
    [self addSubview:mainImageView];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(64);
    }];
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
    _itemInfo = itemInfo;
    
    
}

@end
