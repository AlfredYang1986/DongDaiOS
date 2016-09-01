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
    UILabel *costLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        UILabel *xFriend = [[UILabel alloc]init];
//        xFriend = [Tools setLabelWith:xFriend andText:@"0个共同好友" andTextColor:[UIColor whiteColor] andFontSize:12.f andBackgroundColor:[UIColor clearColor] andTextAlignment:0];
//        [self addSubview:xFriend];
//        [xFriend mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-18);
//            make.top.equalTo(self).offset(39);
//        }];
//        
//        _friendsImage = [[UIImageView alloc]init];
//        [_friendsImage setBackgroundColor:[UIColor orangeColor]];
//        _friendsImage.layer.cornerRadius = 14.f;
//        _friendsImage.clipsToBounds = YES;
//        [self addSubview:_friendsImage];
//        [_friendsImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(xFriend.mas_left).offset(-12.5);
//            make.centerY.equalTo(xFriend);
//            make.size.mas_equalTo(CGSizeMake(28, 28));
//        }];
//        _friendsImage.userInteractionEnabled = YES;
//        
//        xFriend.hidden = YES;
//        _friendsImage.hidden = YES;
        
    }
    return self;
}

-(void)setCell_info:(NSDictionary *)cell_info {
    _cell_info = cell_info;
    
    NSArray *images = [_cell_info objectForKey:@"images"];
    
    if ([[images firstObject] isKindOfClass:[NSString class]]) {
        NSString *PRE = @"http://www.altlys.com:9000/query/downloadFile/";
        //    NSString *PRE = @"http://192.168.3.60:9000/query/downloadFile/";
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 0; i < images.count; ++i) {
            NSString *obj = images[i];
            obj = [PRE stringByAppendingString:obj];
            [tmp addObject:obj];
        }
        
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) delegate:self placeholderImage:IMGRESOURCE(@"sample_image")];
        cycleScrollView.imageURLStringsGroup = [tmp copy];
    } else {
        
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) shouldInfiniteLoop:YES imageNamesGroup:[_cell_info objectForKey:@"images"]];
        cycleScrollView.localizationImageNamesGroup = [_cell_info objectForKey:@"images"];
        cycleScrollView.delegate = self;
    }
    
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.currentPageDotColor = [Tools themeColor];
    cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    [self addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.autoScrollTimeInterval = 99999.0;   //99999秒 滚动一次 ≈ 不自动滚动
    [cycleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 225));
        make.bottom.equalTo(self);
    }];
    
    _popImage = [[UIButton alloc]init];
    [_popImage setImage:IMGRESOURCE(@"bar_left_white") forState:UIControlStateNormal];
    [self addSubview:_popImage];
    [_popImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18);
        make.top.equalTo(self).offset(25);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    costLabel = [[UILabel alloc]init];
    costLabel = [Tools setLabelWith:costLabel andText:@"Service Price" andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.2f] andTextAlignment:NSTextAlignmentCenter];
    [self addSubview:costLabel];
    [costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(125, 35));
    }];
    
    costLabel.text = [NSString stringWithFormat:@"¥ %.f／小时",((NSString*)[_cell_info objectForKey:@"price"]).floatValue];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
