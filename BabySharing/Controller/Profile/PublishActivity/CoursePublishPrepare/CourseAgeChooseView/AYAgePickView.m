//
//  AYAgePickView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYAgePickView.h"

static int flag = 10000;

@implementation AYAgePickView {
    
    UIPickerView * picker;
    
    UIButton *done;
    
    NSInteger lowIndex;
    
    NSInteger highIndex;
    
    NSArray *array;
    
    
}

- (BOOL)isShowed {
    
    AYAgePickView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:flag];
    
    return [view isKindOfClass:[AYAgePickView classForCoder]];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialization];
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initialization];
        
    }
    return self;
}


-(void)initialization {
    
    lowIndex = 0;
    highIndex = 0;
    
    array = @[@"0",@"0.5",@"1",@"1.5",@"2",@"2.5",@"3",@"3.5",@"4",@"4.5",@"5",@"5.5",@"6",@"7",@"8",@"9",@"10",
        @"11",@"12",@"13",@"14",@"15"];
    
    picker = [[UIPickerView alloc] init];
    [self addSubview:picker];
    
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.top.mas_equalTo(32);
        
    }];
    
    picker.delegate = self;
    picker.dataSource = self;
    
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self -> picker.mas_top);
        make.left.right.equalTo(self);
        
    }];
    
    [line setBackgroundColor:[UIColor line]];
    
    done = [UIButton creatBtnWithTitle:@"完成" titleColor:[UIColor theme] fontSize:15.0f backgroundColor:nil];
    [self addSubview:done];
    
    [done mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(50);
        make.bottom.equalTo(line.mas_top).offset(-10);
    }];
    
    [done.titleLabel setFont:[UIFont regularFontSF:15.0]];
    [done.titleLabel setTextAlignment:NSTextAlignmentRight];
    [done addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *to = [[UIView alloc] init];
    [picker addSubview:to];
    
    [to mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self -> picker);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(11);
        
    }];
    [to setBackgroundColor:[UIColor black]];
    
    
    
}

+ (AYAgePickView *)show {
    
    AYAgePickView *agePickView = [[AYAgePickView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
    [agePickView setTag: flag];
    
    [[UIApplication sharedApplication].keyWindow addSubview:agePickView];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [agePickView setFrame: CGRectMake(0, SCREEN_HEIGHT - (250), SCREEN_WIDTH, 250)];
        
    } completion:nil];
    
    return agePickView;
    
    
}


-(void)dismiss {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
        
        
    } completion:^(BOOL success) {
        
        if (success) {
            
            [self removeFromSuperview];
            
        }
        
        
    }];

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 19;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return SCREEN_WIDTH / 2;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 35;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return [array objectAtIndex:row];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        if (lowIndex != row) {
            
            lowIndex = row;
            
        }
        
        if(lowIndex > highIndex) {
            
            [picker selectRow:(lowIndex) inComponent:1 animated:true];
            highIndex = lowIndex;
            
        }
        
        
        
    }
    
    if (component == 1) {
        
        if (highIndex != row) {
            
            highIndex = row;
            
        }
        
        if(highIndex < lowIndex) {
            
            [picker selectRow:(highIndex) inComponent:0 animated:true];
            lowIndex = highIndex;
            
        }
        
        
        
    }
    
    double low = ((NSString *)[array objectAtIndex:lowIndex]).doubleValue;
    double high = ((NSString *)[array objectAtIndex:highIndex]).doubleValue;
    
    [_delegate AYAgePickViewDidUpdateAge:low and:high];
    
    
}

@end
