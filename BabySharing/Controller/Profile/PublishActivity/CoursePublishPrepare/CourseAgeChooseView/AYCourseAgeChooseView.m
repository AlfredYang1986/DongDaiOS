//
//  AYCourseAgeChooseView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCourseAgeChooseView.h"
#import "AYAgeView.h"
#import "AYAgePickView.h"

@implementation AYCourseAgeChooseView{
    
    AYAgeView *low;
    AYAgeView *high;
    
}

@synthesize pickView = _pickView;
@synthesize ageMin = _ageMin;
@synthesize ageMax = _ageMax;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
    
    
}
-(void)initialize {
    
    
    UILabel *head = [UILabel creatLabelWithText:@"本次招生的孩子年龄是" textColor:[UIColor black] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:head];
    
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(40);
        make.left.mas_equalTo(20);
        
    }];
    [head setFont:[UIFont mediumFont:24.0]];
    
    UILabel *tip = [UILabel creatLabelWithText:@"不同孩子年龄的课程可能会对应不同的收费" textColor:[UIColor gary166] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(head);
        make.top.equalTo(head.mas_bottom).offset(2);
        
    }];
    
    [tip setFont:[UIFont regularFontSF:15.0f]];
    
    low = [[AYAgeView alloc] init];
    [self addSubview:low];
    
    [low mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tip.mas_bottom).offset(40);
        make.left.equalTo(tip);
        make.width.mas_equalTo((SCREEN_WIDTH - 40 - 57) / 2);
        make.height.mas_equalTo(64);
    }];
    UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickView)];
    [low addGestureRecognizer:tap_1];
    
    high = [[AYAgeView alloc] init];
    [self addSubview:high];
    
    [high mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(self -> low);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self -> low);
        
    }];
    
    UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickView)];
    [high addGestureRecognizer:tap_2];
    
    UIView *to = [[UIView alloc] init];
    [self addSubview:to];
    [to mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(3);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self -> low);
        
    }];
    
    [to setBackgroundColor:[UIColor black]];
    
}

-(void) showPickView {
    
    if (!_pickView.isShowed) {
        
        _pickView = [AYAgePickView show];
        [_pickView setDelegate:self];
        
    }
    
}

- (void)AYAgePickViewDidUpdateAge:(NSInteger)l and:(NSInteger)h {
    
    _ageMax = h;
    
    _ageMin = l;
    
    [low setAgeWith:[NSString stringWithFormat:@"%ld.5",l]];
    
    [high setAgeWith:[NSString stringWithFormat:@"%ld.5",h]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AYCourseAgePickViewDidUpdateAge" object:nil];
    
    
}




@end
