//
//  AYHomeHistoryItem.m
//  BabySharing
//
//  Created by Alfred Yang on 2/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeHistoryItem.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYHomeHistoryItem {
    UIImageView *mainImageView;
    UILabel *titleLabel;
    UIImageView *star_rang_icon;
    
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
    mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    mainImageView.clipsToBounds = YES;
    [self addSubview:mainImageView];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(92);
    }];
    
    titleLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
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
        make.size.mas_equalTo(CGSizeMake(70.5, 11));
    }];
    
    psLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:psLabel];
    [psLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(star_rang_icon);
        make.left.equalTo(star_rang_icon.mas_right).offset(5);
        make.right.lessThanOrEqualTo(mainImageView);
    }];
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
    _itemInfo = itemInfo;
    
    NSString* photo_name = [[_itemInfo objectForKey:@"images"] objectAtIndex:0];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    [mainImageView sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
               placeholderImage:IMGRESOURCE(@"default_image")];
    
    NSString *title = [_itemInfo objectForKey:@"title"];
    titleLabel.text = title;
    
//    star_rang_icon.image = IMGRESOURCE(@"star_rang_5");
//    contentCountlabel.text = @"12";
    
    NSArray *points = [_itemInfo objectForKey:@"points"];
    if (points.count == 0) {
        star_rang_icon.hidden = YES;
        [psLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_bottom).offset(10);
            make.left.equalTo(titleLabel).offset(0);
            make.right.lessThanOrEqualTo(mainImageView);
        }];
    } else {
        star_rang_icon.hidden = NO;
        CGFloat sumPoint  = 0;
        for (NSNumber *point in points) {
            sumPoint += point.floatValue;
        }
        CGFloat average = sumPoint / points.count;
        
        int mainRang = (int)average;
        NSString *rangImageName = [NSString stringWithFormat:@"star_rang_%d",mainRang];
        CGFloat tmpCompare = average + 0.5f;
        if ((int)tmpCompare > mainRang) {
            rangImageName = [rangImageName stringByAppendingString:@"_"];
        }
        star_rang_icon.image = IMGRESOURCE(rangImageName);
    }
    
    
    NSArray *options_title_cans = kAY_service_options_title_course;
    long options = ((NSNumber*)[_itemInfo objectForKey:@"cans"]).longValue;
    for (int i = 0; i < options_title_cans.count; ++i) {
        long note_pow = pow(2, i);
        if ((options & note_pow)) {
            NSString *psInfo = [NSString stringWithFormat:@"%@",options_title_cans[i]];
            psLabel.text = psInfo;
            break;
        }
    }
}

@end
