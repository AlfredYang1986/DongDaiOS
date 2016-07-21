//
//  OptionOfPlayingView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "OptionOfPlayingView.h"
#import "Tools.h"
#import "Masonry.h"
#import "AYSetNapCostController.h"

@implementation OptionOfPlayingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithTitle:(NSString *)title andIndex:(NSInteger)index{
    self = [super init];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]init];
        [self addSubview:titleLabel];
        titleLabel = [Tools setLabelWith:titleLabel andText:title andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];
        
        _optionBtn = [[UIButton alloc]init];
        [self addSubview:_optionBtn];
        _optionBtn.tag = index;
        [_optionBtn setImage:[UIImage imageNamed:@"tab_found"] forState:UIControlStateNormal];
        [_optionBtn setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateSelected];
//        [_optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
    }
    return self;
}

-(void)didOptionBtnClick:(UIButton*)btn{
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
