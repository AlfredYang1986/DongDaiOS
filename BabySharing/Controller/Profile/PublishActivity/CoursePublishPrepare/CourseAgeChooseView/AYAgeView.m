//
//  AYAgeView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYAgeView.h"

@implementation AYAgeView

@synthesize placeholder = _placeholder;
@synthesize age = _age;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor gary250]];
        
        [self.layer setCornerRadius:4];
        [self.layer setMasksToBounds:YES];
        
        _placeholder = [UILabel creatLabelWithText:@"请选择" textColor:[UIColor lightGary] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        
        [self addSubview:_placeholder];
        
        [_placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.left.mas_equalTo(32);
            
        }];
        
        [_placeholder setFont:[UIFont regularFont:15.0]];
        
        _age = [UILabel creatLabelWithText:@"10.5" textColor:[UIColor black] fontSize:22.0f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [self addSubview:_age];
        
        [_age mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.left.mas_equalTo(33);
            
        }];
        
        [_age setFont:[UIFont boldFont:22.0]];
        
        [_age setHidden:YES];
        
        UILabel *unit = [UILabel creatLabelWithText:@"岁" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:unit];
        
        [unit mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-33);
            
        }];
        
        [unit setFont:[UIFont regularFont:15.0f]];
        
        
    }
    return self;
}

- (void)setAgeWith:(NSString *)age {
    
    [_placeholder setHidden:YES];
    [_age setHidden:NO];
    [_age setText:age];
    
}

@end
