//
//  AYLineView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYLineView.h"

@implementation AYLineView {
    
    NSInteger num;
    
    
}

@synthesize step = _step;

- (instancetype)initWithNumber:(NSInteger)count {
    
    num = count;
    
    CGFloat margin = 2;
    
    CGFloat width = (SCREEN_WIDTH - (count - 1) * margin) / count;
    
    self = [super init];
    if (self) {
        
        for (int i = 0 ; i < count ; i ++) {
            
            UIView *line = [[UIView alloc] init];
            
            [self addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(i * width + i * margin);
                make.top.bottom.equalTo(self);
                make.width.mas_equalTo(width);
                
            }];
            
            line.tag = i + 1;
            [line setBackgroundColor:[UIColor garyLine]];
            
            
        }
        
    }
    
    return self;
}




- (void)setStep:(NSInteger)step {
    
    _step = step;
    
    for (int i = 0; i < num; i ++) {
        
        UIView * view = [self viewWithTag:i + 1];
        
        if (i < step + 1) {
            
            [view setBackgroundColor:[UIColor theme]];
            
        }else {
            
            [view setBackgroundColor:[UIColor garyLine]];
            
        }
        
        //[view setNeedsLayout];
        //[view setNeedsDisplay];
    }
    
}


@end
