//
//  AYProfileOrigCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 7/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYProfileOrigCellView.h"
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

@implementation AYProfileOrigCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [Tools blackColor];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
        }];
        
        _bottom_line = [[UIView alloc]init];
        [self addSubview:_bottom_line];
        _bottom_line.backgroundColor = [UIColor lightGrayColor];
        [_bottom_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-1);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setDic_info:(NSDictionary *)dic_info{
    _dic_info = dic_info;
    
    _titleLabel.text = [dic_info objectForKey:@"title"];
    if (((NSNumber*)[dic_info objectForKey:@"isLast"]).boolValue) {
        _bottom_line.hidden = YES;
    }
}
@end
