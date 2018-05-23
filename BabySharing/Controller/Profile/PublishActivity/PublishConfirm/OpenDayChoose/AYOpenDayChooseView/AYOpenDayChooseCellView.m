//
//  AYOpenDayChooseCellView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYOpenDayChooseCellView.h"

@implementation AYOpenDayChooseCellView {
    
    UILabel *dayLabel;
    
    
}

- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    
    if (isSelected) {
        
        NSAttributedString *s = [[NSAttributedString alloc]initWithString:self.day attributes:@{NSForegroundColorAttributeName:[UIColor lightGary],NSStrikethroughColorAttributeName:[UIColor lightGary],NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick|NSUnderlinePatternSolid)}];
        
        [dayLabel setAttributedText:s];
        
    }else {
        
        [dayLabel setAttributedText:[[NSAttributedString alloc]initWithString:self.day]];
        
    }
    
    
}

- (void)setDay:(NSString *)day {
    
    _day = day;

    
    [dayLabel setAttributedText:[[NSAttributedString alloc]initWithString:day]];
    
    if (self.isGone) {
        
        [dayLabel setTextColor:[UIColor lightGary]];
        
    }
    
}

- (void)setIsGone:(BOOL)isGone {
    
    _isGone = isGone;
    
    if (self.isGone) {
        
        [dayLabel setTextColor:[UIColor lightGary]];
        
    }else {
        
        [dayLabel setTextColor:[UIColor black]];
        
    }
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initialize];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
        
    }
    return self;
}

-(void)initialize {
    
    dayLabel = [UILabel creatLabelWithText:@"1" textColor:[UIColor black] font:[UIFont regularFont:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:dayLabel];
    
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.contentView);
        
    }];
}

- (void)today {
    
    [dayLabel setText:@"今"];
    [dayLabel setTextColor:[UIColor redColor]];
    
}



@end
