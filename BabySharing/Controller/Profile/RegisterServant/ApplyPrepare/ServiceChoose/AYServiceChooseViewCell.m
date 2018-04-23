//
//  AYServiceChooseViewCell.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYServiceChooseViewCell.h"

@implementation AYServiceChooseViewCell {
    
    UILabel *titleLabel;
    UIView *content;
    
}

- (void)setCategory:(NSString *)category {
    
    _category = category;
    
    [titleLabel setText:_category];
    
}

- (void)setIsSelected:(Boolean)isSelected {
    
    _isSelected = isSelected;
    
    if (_isSelected) {
        
        [content setBackgroundColor:[UIColor theme]];
        
        [titleLabel setTextColor:[UIColor white]];
        
        
    }else {
        
        [content setBackgroundColor:[UIColor garyBackground]];
        
        [titleLabel setTextColor:[UIColor gary166]];
        
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _isSelected = NO;
        
        content = [[UIView alloc] init];
        
        [self.contentView addSubview:content];
        
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            
        }];
        
        
        [content.layer setCornerRadius:4.0f];
        [content.layer setMasksToBounds:YES];
        [content setBackgroundColor:[UIColor garyBackground]];
        
        titleLabel = [UILabel creatLabelWithText:@"" textColor:[UIColor gary166] font:[UIFont mediumFontSF:17.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [content addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.left.mas_equalTo(20);
            
        }];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
