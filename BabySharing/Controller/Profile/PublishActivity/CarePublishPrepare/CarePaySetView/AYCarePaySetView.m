//
//  AYCarePaySetView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCarePaySetView.h"
#import "AYPaySetView.h"
@implementation AYCarePaySetView {
    
    AYPaySetView *flexible;
    AYPaySetView *fixed;
    
}
@synthesize delegate = _delegate;


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UILabel *head = [UILabel creatLabelWithText:@"该课程可以接受的付费方式" textColor:[UIColor black] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(40);
            
        }];
        
        [head setFont:[UIFont boldFont:24]];
        
        flexible = [[AYPaySetView alloc] initWithTitle:@"灵活"];
        [self addSubview:flexible];
        
        [flexible mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(head.mas_bottom).offset(40);
            make.height.mas_equalTo(56);
            
        }];
        
        UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payFlexible)];
        [flexible addGestureRecognizer:tap_1];
        
        
        
        fixed = [[AYPaySetView alloc] initWithTitle:@"固定"];
        [self addSubview:fixed];
        
        [fixed mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.height.equalTo(self -> flexible);
            make.top.equalTo(self -> flexible.mas_bottom).offset(16);
            
        }];
        
        UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payFixed)];
        [fixed addGestureRecognizer:tap_2];
        
        
    }
    return self;
}

-(void) payFlexible {
    
    [_delegate payFlexible];
    
}

-(void) payFixed {
    
    [_delegate payFixed];
    
}

- (void)selectFixed {
    
    [fixed selected];
    
}

- (void)selectFlexible {
    
    [flexible selected];
    
}

@end
