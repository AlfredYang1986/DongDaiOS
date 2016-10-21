//
//  AYPlayItemsView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPlayItemsView.h"
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

@implementation AYPlayItemsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _item_icon = [[UIImageView alloc]init];
        [self addSubview:_item_icon];
        [_item_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        _item_name = [[UILabel alloc]init];
        _item_name = [Tools setLabelWith:_item_name andText:nil andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        _item_name.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12.f];
        [self addSubview:_item_name];
        [_item_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_item_icon.mas_bottom).offset(7);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _item_name.text = self.item_name.text;
    _item_icon.image = self.item_icon.image;
}

@end
