//
//  AYCoursePaySetView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCoursePaySetView.h"
#import "AYPaySetView.h"

@implementation AYCoursePaySetView {
    
    AYPaySetView *byTime;
    AYPaySetView *byMember;
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
        
        byTime = [[AYPaySetView alloc] initWithTitle:@"按次"];
        [self addSubview:byTime];
        
        [byTime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(head.mas_bottom).offset(40);
            make.height.mas_equalTo(56);
            
        }];
        
        UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payByTime)];
        [byTime addGestureRecognizer:tap_1];
        
        
        
        byMember = [[AYPaySetView alloc] initWithTitle:@"会员制"];
        [self addSubview:byMember];
        
        [byMember mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.height.equalTo(self -> byTime);
            make.top.equalTo(self -> byTime.mas_bottom).offset(16);
            
        }];
        
        UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payByMember)];
        [byMember addGestureRecognizer:tap_2];

        
    }
    return self;
}

-(void) payByTime {
    
    [_delegate payByTime];
    
}

-(void) payByMember {
    
    [_delegate payByMember];
    
}

- (void)selectByTime {
    
    [byTime selected];
    
}

- (void)selectByMember {
    
    [byMember selected];
    
}


@end
