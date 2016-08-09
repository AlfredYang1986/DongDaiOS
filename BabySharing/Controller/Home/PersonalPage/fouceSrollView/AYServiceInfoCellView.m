//
//  AYServiceInfoCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceInfoCellView.h"
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
#import <MapKit/MapKit.h>

#import "AYPlayItemsView.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define WIDTH               SCREEN_WIDTH - 18*2

@interface AYServiceInfoCellView ()
@property (nonatomic, strong) CLGeocoder *gecoder;
@end

@implementation AYServiceInfoCellView{
    UILabel *aboutMMIntru;
    UILabel *aboutMMDesc;
    UITextView *aboutMMIntruText;
    UILabel *contextlabel;
    
    UIView *playItems;
    UIView *safeDevices;
    
    NSArray *options_title_cans;
    NSArray *options_title_capacity;
}
//@synthesize aboutMMIntru = _aboutMMIntru;

-(CLGeocoder *)gecoder{
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc]init];
    }
    return _gecoder;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel = [Tools setLabelWith:_titleLabel andText:@"一句话了解妈妈" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(30);
            make.left.equalTo(self).offset(18);
        }];
        
        _starRangImage = [[UIImageView alloc]init];
        _starRangImage.image = IMGRESOURCE(@"star_rang_5");
        [self addSubview:_starRangImage];
        [_starRangImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(90, 14));
        }];
        
        UILabel *countLabel = [[UILabel alloc]init];
        countLabel = [Tools setLabelWith:countLabel andText:@"(0)" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        countLabel.text = @"(00)";
        [self addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_starRangImage);
            make.left.equalTo(_starRangImage.mas_right).offset(10);
        }];
        
        /*************************/
        UIView *line01 = [[UIView alloc]init];
        line01.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
        [self addSubview:line01];
        [line01 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_starRangImage.mas_bottom).offset(28);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@1);
        }];
        
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.backgroundColor = [UIColor orangeColor];
        _photoImageView.layer.cornerRadius = 30.f;
        _photoImageView.clipsToBounds = YES;
        _photoImageView.image = IMGRESOURCE(@"lol");
        [self addSubview:_photoImageView];
        [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.top.equalTo(line01.mas_bottom).offset(25);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UILabel *MMLabel = [[UILabel alloc]init];
        MMLabel = [Tools setLabelWith:MMLabel andText:@"看护妈妈：" andTextColor:[Tools blackColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:MMLabel];
        [MMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_photoImageView.mas_centerY).offset(-6);
            make.left.equalTo(_photoImageView.mas_right).offset(15);
        }];
        
        _MMAdressLabel = [[UILabel alloc]init];
        _MMAdressLabel = [Tools setLabelWith:_MMAdressLabel andText:@"三元桥，朝阳区" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:_MMAdressLabel];
        [_MMAdressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(MMLabel.mas_bottom).offset(12);
            make.left.equalTo(MMLabel);
        }];
        
        _recallPersent = [[UILabel alloc]init];
        _recallPersent = [Tools setLabelWith:_recallPersent andText:@"回复率：100%" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:_recallPersent];
        [_recallPersent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(MMLabel);
            make.right.equalTo(self).offset(-18);
        }];
        
        aboutMMIntru = [[UILabel alloc]init];
        aboutMMIntru = [Tools setLabelWith:aboutMMIntru andText:@"" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        aboutMMIntru.numberOfLines = 3.f;
        [self addSubview:aboutMMIntru];
        [aboutMMIntru mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImageView.mas_bottom).offset(15);
            make.left.equalTo(_titleLabel);
            make.width.mas_equalTo(WIDTH);
        }];
        
        _readMore = [[UIButton alloc]init];
        [_readMore setTitle:@"阅读更多" forState:UIControlStateNormal];
        [_readMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        _readMore.titleLabel.textAlignment = NSTextAlignmentLeft;
        _readMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_readMore];
        [_readMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(aboutMMIntru.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 16));
        }];
        [_readMore addTarget:self action:@selector(didReadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _takeOffMore = [[UIButton alloc]init];
        [_takeOffMore setTitle:@"收起" forState:UIControlStateNormal];
        [_takeOffMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        _takeOffMore.titleLabel.textAlignment = NSTextAlignmentLeft;
        _takeOffMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _takeOffMore.hidden = YES;
        [self addSubview:_takeOffMore];
        [_takeOffMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(aboutMMIntru.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(30, 16));
        }];
        [_takeOffMore addTarget:self action:@selector(didTakeOffMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /*************************************/
        UILabel *familyLabel = [[UILabel alloc]init];
        familyLabel = [Tools setLabelWith:familyLabel andText:@"家庭成员描述：" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:familyLabel];
        [familyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_readMore.mas_bottom).offset(25);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(WIDTH, 64));
        }];
        
        CALayer* line02 = [CALayer layer];
        line02.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor;
        line02.frame = CGRectMake(0, 0, WIDTH, 1);
        [familyLabel.layer addSublayer:line02];
        CALayer* line03 = [CALayer layer];
        line03.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor;
        line03.frame = CGRectMake(0, 63, WIDTH, 1);
        [familyLabel.layer addSublayer:line03];
        /*************************************/
        
        playItems = [[UIView alloc]init];
        [self addSubview:playItems];
        [playItems mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(familyLabel.mas_bottom).offset(0);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(WIDTH, 100));
        }];
        UIButton *morePlayItems = [[UIButton alloc]init];
        [morePlayItems setImage:IMGRESOURCE(@"chan_group_back") forState:UIControlStateNormal];
        [playItems addSubview:morePlayItems];
        [morePlayItems mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(playItems);
            make.right.equalTo(playItems);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        CALayer* line04 = [CALayer layer];
        line04.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor;
        line04.frame = CGRectMake(0, 99, WIDTH, 1);
        [playItems.layer addSublayer:line04];
        
        
        /*************************************/
        UILabel *contentCount = [[UILabel alloc]init];
        contentCount = [Tools setLabelWith:contentCount andText:@"0条评论 * 0个共同好友" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:contentCount];
        [contentCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(playItems.mas_bottom).offset(25);
            make.left.equalTo(_titleLabel);
        }];
        
        UIImageView *oneStarRangImage = [[UIImageView alloc]init];
        oneStarRangImage.image = [UIImage imageNamed:@"star_rang_1"];
        [self addSubview:oneStarRangImage];
        [oneStarRangImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentCount.mas_bottom).offset(10);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(90, 14));
        }];
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.backgroundColor = [UIColor orangeColor];
        iconImageView.layer.cornerRadius = 18.5f;
        iconImageView.clipsToBounds = YES;
//        iconImageView.image = [UIImage imageNamed:@"tab_found_selected"];
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(oneStarRangImage.mas_bottom).offset(30);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(37, 37));
        }];
        
        UILabel *contentName = [[UILabel alloc]init];
        contentName = [Tools setLabelWith:contentName andText:@"田小飞" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:contentName];
        [contentName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(iconImageView.mas_centerY).offset(-8);
            make.top.equalTo(iconImageView);
            make.left.equalTo(iconImageView.mas_right).offset(15);
        }];
        
        UILabel *baby = [[UILabel alloc]init];
        baby = [Tools setLabelWith:baby andText:@"0岁宝宝" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:baby];
        [baby mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentName.mas_bottom).offset(6);
            make.left.equalTo(contentName);
        }];
        UILabel *contentDate = [[UILabel alloc]init];
        contentDate = [Tools setLabelWith:contentDate andText:@"2016年6月12日" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:contentDate];
        [contentDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentName);
            make.right.equalTo(self).offset(-18);
        }];
        
        contextlabel = [[UILabel alloc]init];
        contextlabel.text = @"";
        contextlabel.textColor = [Tools blackColor];
        contextlabel.font = [UIFont systemFontOfSize:14.f];
        
        contextlabel.numberOfLines = 2.f;
        [self addSubview:contextlabel];
        [contextlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(15);
            make.left.equalTo(_titleLabel);
            make.width.mas_equalTo(WIDTH);
        }];
        _showMore = [[UIButton alloc]init];
        [_showMore setTitle:@"更多评价" forState:UIControlStateNormal];
        [_showMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        _showMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_showMore];
        [_showMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contextlabel.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 16));
        }];
        /*************************************/
        
        safeDevices = [[UIView alloc]init];
        [self addSubview:safeDevices];
        [safeDevices mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_showMore.mas_bottom).offset(25);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(WIDTH, 100));
        }];
        UIButton *moreSafeDevices = [[UIButton alloc]init];
        [moreSafeDevices setImage:IMGRESOURCE(@"chan_group_back") forState:UIControlStateNormal];
        [safeDevices addSubview:moreSafeDevices];
        [moreSafeDevices mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(safeDevices);
            make.right.equalTo(safeDevices);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        CALayer* line05 = [CALayer layer];
        line05.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor;
        line05.frame = CGRectMake(0, 0, WIDTH, 1);
        [safeDevices.layer addSublayer:line05];
        CALayer* line06 = [CALayer layer];
        line06.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor;
        line06.frame = CGRectMake(0, 99, WIDTH, 1);
        [safeDevices.layer addSublayer:line06];
        
        /*************************************/
        UIEdgeInsets iamgeInsets = UIEdgeInsetsMake(-10, 6, 10, -6);
        UIEdgeInsets titleInsets = UIEdgeInsetsMake(30, -50, -30, 0);
        
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setImage:IMGRESOURCE(@"service_calendar") forState:UIControlStateNormal];
        _chatBtn.imageEdgeInsets = iamgeInsets;
        [_chatBtn setTitle:@"TA的日程" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _chatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _chatBtn.titleEdgeInsets = titleInsets;
        [self addSubview:_chatBtn];
        [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeDevices.mas_bottom).offset(25);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(75, 80));
        }];
        
        _dailyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dailyBtn setImage:IMGRESOURCE(@"service_fee") forState:UIControlStateNormal];
        _dailyBtn.imageEdgeInsets = iamgeInsets;
        [_dailyBtn setTitle:@"费用说明" forState:UIControlStateNormal];
        [_dailyBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
        _dailyBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _dailyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dailyBtn.titleEdgeInsets = titleInsets;
        [self addSubview:_dailyBtn];
        [_dailyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chatBtn);
            make.right.equalTo(_chatBtn.mas_left).offset(-SCREEN_WIDTH*0.13);
            make.size.equalTo(_chatBtn);
        }];
        
        _costBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_costBtn setImage:IMGRESOURCE(@"service_chat") forState:UIControlStateNormal];
        _costBtn.imageEdgeInsets = iamgeInsets;
        [_costBtn setTitle:@"退订政策" forState:UIControlStateNormal];
        [_costBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
        _costBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _costBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _costBtn.titleEdgeInsets = titleInsets;
        [self addSubview:_costBtn];
        [_costBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chatBtn);
            make.left.equalTo(_chatBtn.mas_right).offset(SCREEN_WIDTH*0.13);
            make.size.equalTo(_chatBtn);
        }];
        
        /*************************/
    }
    return self;
}

-(void)setService_info:(NSDictionary *)service_info{
    _service_info = service_info;
    self.titleLabel.text = [_service_info objectForKey:@"title"];
    //        aboutMMIntru.text = [_service_info objectForKey:@"description"];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    /** 行高 */
    paraStyle.lineSpacing = 8;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic_format = @{NSParagraphStyleAttributeName:paraStyle};
    
    if (_takeOffMore.hidden) {
        NSString *desc = [_service_info objectForKey:@"description"];
        if (desc.length > 60) {
            desc = [desc substringToIndex:60];
            desc = [desc stringByAppendingString:@"..."];
        }
        
        NSAttributedString *descAttri = [[NSAttributedString alloc]initWithString:desc attributes:dic_format];
        aboutMMIntru.attributedText = descAttri;
        
    }
    
    NSString *contentString = [_service_info objectForKey:@"description"];
    if (contentString.length > 46) {
        contentString = [contentString substringToIndex:46];
        contentString = [contentString stringByAppendingString:@"..."];
    }
    contextlabel.attributedText = [[NSAttributedString alloc]initWithString:contentString attributes:dic_format];
    
    NSDictionary *dic_loc = [_service_info objectForKey:@"location"];
    NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
    NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    [self.gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pl = [placemarks firstObject];
        NSLog(@"%@",pl.addressDictionary);
        _MMAdressLabel.text = [NSString stringWithFormat:@"%@,%@",pl.thoroughfare,pl.subLocality];
    }];
    
    options_title_cans = @[@"看书",@"做瑜伽",@"做蛋糕",@"玩玩具",@"画画"];
    options_title_capacity = @[@"安全桌角",@"安全插座",@"急救包",@"无烟",@"安全护栏",@"宠物",@"防摔地板"];
    
    long options = ((NSNumber*)[_service_info objectForKey:@"cans"]).longValue;
    CGFloat offsetX = 0;
    for (int i = 0; i < 4; ++i) {
        long note_pow = pow(2, i);
        if ((options & note_pow)) {
            AYPlayItemsView *item = [[AYPlayItemsView alloc]initWithFrame:CGRectMake(offsetX, 25, 50, 55)];
            item.item_icon.image = IMGRESOURCE(@"tab_found");
            item.item_name.text = options_title_cans[i];
            [playItems addSubview:item];
            offsetX += 85;
        }
    }
    
    {
        long options = ((NSNumber*)[_service_info objectForKey:@"capacity"]).longValue;
        CGFloat offsetX = 0;
        for (int i = 0; i < 4; ++i) {
            long note_pow = pow(2, i);
            if ((options & note_pow)) {
                AYPlayItemsView *item = [[AYPlayItemsView alloc]initWithFrame:CGRectMake(offsetX, 25, 50, 55)];
                item.item_icon.image = IMGRESOURCE(@"tab_found");
                item.item_name.text = options_title_capacity[i];
                [safeDevices addSubview:item];
                offsetX += 85;
            }
        }
    }

}

-(void)layoutSubviews{
    [super layoutSubviews];

}


//More
-(void)didReadMoreClick:(UIButton*)btn{
    aboutMMIntru.numberOfLines = 6.f;
    
    _readMore.hidden = YES;
    _takeOffMore.hidden = NO;
    NSString *desc = [_service_info objectForKey:@"description"];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    /** 行高 */
    paraStyle.lineSpacing = 8;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic_format = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *descAttri = [[NSAttributedString alloc]initWithString:desc attributes:dic_format];
    aboutMMIntru.attributedText = descAttri;
    NSLog(@"%@",aboutMMIntru.attributedText);
    
}
-(void)didTakeOffMoreClick:(UIButton*)btn{
    _readMore.hidden = NO;
    _takeOffMore.hidden = YES;
    aboutMMIntru.numberOfLines = 3.f;
}
@end
/********* ********/

