//
//  AYProfilePublishCellView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYProfilePublishCellView.h"

@implementation AYProfilePublishCellView

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIView *content = [[UIView alloc] init];
        
        [self.contentView addSubview:content];
        
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(64);
            make.center.equalTo(self.contentView);
            
        }];
        
        [content setBackgroundColor:[UIColor theme]];
        [content.layer setCornerRadius:4.0f];
        [content.layer setMasksToBounds:YES];
        
        UILabel *titleLabel = [UILabel creatLabelWithText:@"发布招生" textColor:[UIColor white] font:[UIFont mediumFont:18.0f] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        
        [content addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(content);
            
        }];
        
        
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}


@end
