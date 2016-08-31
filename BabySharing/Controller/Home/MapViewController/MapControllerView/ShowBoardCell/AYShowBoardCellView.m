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
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"

@implementation AYShowBoardCellView{
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(12.5);
            make.left.equalTo(self).offset(12.5);
            make.size.mas_equalTo(CGSizeMake(100, 82));
        }];
        
//        _distanceLabel = [[UILabel alloc]init];
//        _distanceLabel.text = @"距离您约0km";
//        _distanceLabel.font = [UIFont systemFontOfSize:13.f];
//        _distanceLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.f];
//        [self addSubview:_distanceLabel];
//        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(10);
//            make.right.equalTo(self).offset(-10);
//        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"一句话了解妈妈";
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_starRangImage.mas_bottom).offset(10);
//            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(12.5);
            make.left.equalTo(_imageView.mas_right).offset(12.5);
            make.right.equalTo(self).offset(-12.5);
        }];
        
        _starRangImage = [[UIImageView alloc]init];
        _starRangImage.image = IMGRESOURCE(@"star_rang_1");
        [self addSubview:_starRangImage];
        [_starRangImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.bottom.equalTo(_imageView).offset(0);
            make.size.mas_equalTo(CGSizeMake(90, 14));
        }];
        
        _contentCount = [[UILabel alloc]init];
        _contentCount.text = @"13";
        _contentCount.font = [UIFont systemFontOfSize:14.f];
        _contentCount.textColor = [Tools colorWithRED:155 GREEN:155 BLUE:155 ALPHA:1.f];
        [self addSubview:_contentCount];
        [_contentCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_starRangImage.mas_right).offset(10);
            make.centerY.equalTo(_starRangImage);
        }];
        
        _infoLabel = [[UILabel alloc]init];
        _infoLabel = [Tools setLabelWith:_infoLabel andText:@"家庭看护" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_infoLabel];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_starRangImage.mas_top).offset(-10);
            make.left.equalTo(_starRangImage);
        }];
        
//        _iconImage = [[UIImageView alloc]init];
//        _iconImage.image = IMGRESOURCE(@"tab_found_selected");
//        [self addSubview: _iconImage];
//        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_titleLabel);
//            make.bottom.equalTo(self).offset(-12.5);
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
//        
//        _friendsLabel = [[UILabel alloc]init];
//        _friendsLabel.text = @"0个共同好友";
//        _friendsLabel.font = [UIFont systemFontOfSize:12.f];
//        _friendsLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
//        [self addSubview:_friendsLabel];
//        [_friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconImage.mas_right).offset(12.5);
//            make.centerY.equalTo(_iconImage);
//        }];
//        _iconImage.hidden = YES;
//        _friendsLabel.hidden = YES;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

}

- (void)setContentInfo:(NSDictionary *)contentInfo {
    _contentInfo = contentInfo;
    
    _titleLabel.text = [_contentInfo objectForKey:@"title"];
    
    NSString* photo_name = [[_contentInfo objectForKey:@"images"] objectAtIndex:0];
    NSMutableDictionary* dic_img = [[NSMutableDictionary alloc]init];
    [dic_img setValue:photo_name forKey:@"image"];
    [dic_img setValue:@"img_thum" forKey:@"expect_size"];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    [cmd performWithResult:[dic_img copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            _imageView.image = img;
        }else{
            [_imageView setImage:IMGRESOURCE(@"sample_image")];
        }
    }];
    
//    NSDictionary *dic_loc = [self.contentInfo objectForKey:@"location"];
//    NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
//    NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
//    CLLocationDistance meters = [self.location distanceFromLocation:loc];
//    _distanceLabel.text = [NSString stringWithFormat:@"距离您约%.2fkm",(float)meters * 0.001];
    
}


#pragma mark -- tools
-(void)setImageAndSelectImage:(UIButton*)button WithName:(NSString*)imagename{
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imagename]] forState:UIControlStateSelected];
}
@end
