//
//  AYShowBoardCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShowBoardCellView.h"
#import "AYCommandDefines.h"
#import "Tools.h"
#import "AYAnnonation.h"

@implementation AYShowBoardCellView{
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"lol"];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(130, 80));
        }];
        
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.text = @"距离您约0km";
        _distanceLabel.font = [UIFont systemFontOfSize:13.f];
        _distanceLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.f];
        [self addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        
        _fiveStarBtn = [[UIButton alloc]init];
        [self addSubview:_fiveStarBtn];
        [self setImageAndSelectImage:_fiveStarBtn WithName:@"tab_found"];
        [_fiveStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(_distanceLabel.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _fourStarBtn = [[UIButton alloc]init];
        [self addSubview:_fourStarBtn];
        [self setImageAndSelectImage:_fourStarBtn WithName:@"tab_found"];
        [_fourStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_fiveStarBtn.mas_left).offset(-5);
            make.centerY.equalTo(_fiveStarBtn);
            make.size.equalTo(_fiveStarBtn);
        }];
        
        _threeStarBtn = [[UIButton alloc]init];
        [self addSubview:_threeStarBtn];
        [self setImageAndSelectImage:_threeStarBtn WithName:@"tab_found"];
        [_threeStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_fourStarBtn.mas_left).offset(-5);
            make.centerY.equalTo(_fiveStarBtn);
            make.size.equalTo(_fiveStarBtn);
        }];
        
        _twoStarBtn = [[UIButton alloc]init];
        [self addSubview:_twoStarBtn];
        [self setImageAndSelectImage:_twoStarBtn WithName:@"tab_found"];
        [_twoStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_threeStarBtn.mas_left).offset(-5);
            make.centerY.equalTo(_fiveStarBtn);
            make.size.equalTo(_fiveStarBtn);
        }];
        
        _oneStarBtn = [[UIButton alloc]init];
        [self addSubview:_oneStarBtn];
        [self setImageAndSelectImage:_oneStarBtn WithName:@"tab_found"];
        [_oneStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_twoStarBtn.mas_left).offset(-5);
            make.centerY.equalTo(_fiveStarBtn);
            make.size.equalTo(_fiveStarBtn);
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"一句话了解妈妈";
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fiveStarBtn.mas_bottom).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        
        _friendsLabel = [[UILabel alloc]init];
        _friendsLabel.text = @"0个共同好友";
        _friendsLabel.font = [UIFont systemFontOfSize:12.f];
        _friendsLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
        [self addSubview:_friendsLabel];
        [_friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        }];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.contentInfo) {
        _titleLabel.text = [self.contentInfo objectForKey:@"title"];
        
        NSDictionary *dic_loc = [self.contentInfo objectForKey:@"location"];
        NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
        NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
        CLLocationDistance meters = [self.location distanceFromLocation:loc];
        _distanceLabel.text = [NSString stringWithFormat:@"距离您约%.2fkm",(float)meters * 0.001];
    }
}


#pragma mark -- tools
-(void)setImageAndSelectImage:(UIButton*)button WithName:(NSString*)imagename{
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imagename]] forState:UIControlStateSelected];
}
@end
