//
//  AYFouceCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFouceCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define WIDTH               SCREEN_WIDTH - 15*2

@implementation AYFouceCellView{
    SDCycleScrollView *cycleScrollView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) shouldInfiniteLoop:YES imageNamesGroup:_imageNameArr];
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) delegate:self placeholderImage:nil];
//        cycleScrollView.delegate = self;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.currentPageDotColor = [Tools themeColor];
        cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        [self addSubview:cycleScrollView];
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.autoScrollTimeInterval = 4.0;
        
        _popImage = [[UIImageView alloc]init];
        _popImage.image = IMGRESOURCE(@"bar_left_white");
        [self addSubview:_popImage];
        [_popImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(18);
            make.top.equalTo(self).offset(38);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        _popImage.userInteractionEnabled = YES;
        
        UILabel *xFriend = [[UILabel alloc]init];
        xFriend = [Tools setLabelWith:xFriend andText:@"0个共同好友" andTextColor:[UIColor whiteColor] andFontSize:12.f andBackgroundColor:[UIColor clearColor] andTextAlignment:0];
        [self addSubview:xFriend];
        [xFriend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-18);
            make.top.equalTo(self).offset(39);
        }];
        
        _friendsImage = [[UIImageView alloc]init];
        [_friendsImage setBackgroundColor:[UIColor orangeColor]];
        _friendsImage.layer.cornerRadius = 14.f;
        _friendsImage.clipsToBounds = YES;
        [self addSubview:_friendsImage];
        [_friendsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(xFriend.mas_left).offset(-12.5);
            make.centerY.equalTo(xFriend);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        _friendsImage.userInteractionEnabled = YES;
        
        UILabel *costLabel = [[UILabel alloc]init];
        costLabel = [Tools setLabelWith:costLabel andText:[NSString stringWithFormat:@"¥ %.1f／小时",80.f] andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.2f] andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:costLabel];
        [costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(125, 35));
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    cycleScrollView.localizationImageNamesGroup = _imageNameArr;
}

@end
/********* ********/



