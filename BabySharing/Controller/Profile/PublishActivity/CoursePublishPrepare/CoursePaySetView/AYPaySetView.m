//
//  AYPaySetView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYPaySetView.h"

@implementation AYPaySetView{
    
    UILabel *title;
    UIImageView *icon;
    
}


- (instancetype)initWithTitle:(NSString *)s {
    
    self = [super init];
    
    if (self) {
        
        [self.layer setCornerRadius:4];
        [self.layer setMasksToBounds:YES];
        
        
        [self setBackgroundColor:[UIColor garyBackground]];
        
        title = [UILabel creatLabelWithText:s textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(16);
            make.centerY.equalTo(self);
            
        }];
        
        [title setFont:[UIFont mediumFont:15]];
        
        icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-16);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13);
            
        }];
        
        [icon setImage:IMGRESOURCE(@"details_icon_arrow_right")];
        
    }
    return self;
    
}

- (void)setTitle:(NSString *)s {
    
    
    [title setText:s];
    
    
}

- (void)selected {
    
    [title setTextColor:[UIColor white]];
    
    [self setBackgroundColor:[UIColor theme]];
    
    [icon setImage:IMGRESOURCE(@"icon_arrow_r_white")];
    
    
    
}

- (void)unselected {
    
    
    [title setTextColor:[UIColor black]];
    
    [self setBackgroundColor:[UIColor garyBackground]];
    
    
}

@end
