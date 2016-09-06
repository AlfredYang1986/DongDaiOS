//
//  AYHomeLikesItemCell.m
//  BabySharing
//
//  Created by Alfred Yang on 6/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeLikesItemCell.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYHomeLikesItemCell {
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
    //    self.layer.doubleSided = NO;
    self.backgroundColor = [Tools garyBackgroundColor];
    
    mainImageView = [[UIImageView alloc]init];
    mainImageView.backgroundColor = [Tools garyBackgroundColor];
    [self addSubview:mainImageView];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(7.5);
        make.left.equalTo(self).offset(7.5);
        make.right.equalTo(self).offset(-7.5);
        make.height.mas_equalTo(92);
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel = [Tools setLabelWith:titleLabel andText:nil andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainImageView.mas_bottom).offset(15);
        make.left.equalTo(mainImageView);
        make.right.equalTo(mainImageView);
    }];
    
    star_rang_icon = [[UIImageView alloc]init];
    [self addSubview:star_rang_icon];
    star_rang_icon.image = IMGRESOURCE(@"star_rang_5");
    [star_rang_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(80, 11));
    }];
    
    contentCountlabel = [[UILabel alloc]init];
    contentCountlabel = [Tools setLabelWith:contentCountlabel andText:nil andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:contentCountlabel];
    [contentCountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(star_rang_icon);
        make.left.equalTo(star_rang_icon.mas_right).offset(5);
    }];
    
    psLabel = [[UILabel alloc]init];
    psLabel = [Tools setLabelWith:psLabel andText:nil andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:psLabel];
    [psLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(star_rang_icon);
        make.left.equalTo(contentCountlabel.mas_right).offset(5);
    }];
}

@end
