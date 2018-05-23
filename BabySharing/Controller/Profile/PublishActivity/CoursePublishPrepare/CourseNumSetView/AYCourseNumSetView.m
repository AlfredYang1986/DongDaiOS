//
//  AYCourseNumSetView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCourseNumSetView.h"
#import "CustomTextField.h"

@implementation AYCourseNumSetView {
    
    CustomTextField *minTextField;
    CustomTextField *maxTextField;
    
    
}

@synthesize maxNum = _maxNum;
@synthesize minNum = _minNum;

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



- (void)initialize {
    
    
    UILabel *head = [UILabel creatLabelWithText:@"课程人数设置" textColor:[UIColor black] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:head];
    
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(44);
        
    }];
    
    [head setFont:[UIFont boldFont:24]];
    
    
    UIView *bgView_1 = [[UIView alloc] init];
    [self addSubview:bgView_1];
    
    [bgView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(64);
        make.top.equalTo(head.mas_bottom).offset(40);
        
    }];
    
    [bgView_1 setBackgroundColor:[UIColor garyBackground]];
    [bgView_1.layer setCornerRadius:4];
    [bgView_1.layer setMasksToBounds:YES];
    
    UIView *bgView_2 = [[UIView alloc] init];
    [self addSubview:bgView_2];
    
    [bgView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(64);
        make.top.equalTo(bgView_1.mas_bottom).offset(16);
        
    }];
    
    [bgView_2 setBackgroundColor:[UIColor garyBackground]];
    [bgView_2.layer setCornerRadius:4];
    [bgView_2.layer setMasksToBounds:YES];
    
    
    UILabel *min = [UILabel creatLabelWithText:@"最少开班人数" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [bgView_1 addSubview:min];
    
    [min mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
        make.centerY.equalTo(bgView_1);
        
    }];
    
    [min setFont:[UIFont regularFontSF:15]];
    
    UILabel *max = [UILabel creatLabelWithText:@"最大满班人数" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [bgView_2 addSubview:max];
    
    [max mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
        make.centerY.equalTo(bgView_2);
        
    }];
    
    [max setFont:[UIFont regularFont:15.0f]];
    
    minTextField = [[CustomTextField alloc] init];
    [bgView_1 addSubview:minTextField];
    
    [minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-16);
        make.centerY.equalTo(bgView_1);
        make.width.mas_equalTo(150);
        
    }];
    
    [minTextField setFont:[UIFont boldFont:22]];
    [minTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName : [UIColor gary217],NSFontAttributeName : [UIFont regularFont:15]}]];
    [minTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [minTextField setTextAlignment:NSTextAlignmentRight];
    
    [minTextField setDelegate:self];
    
    maxTextField = [[CustomTextField alloc] init];
    [bgView_2 addSubview:maxTextField];
    
    [maxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-16);
        make.centerY.equalTo(bgView_2);
        make.width.mas_equalTo(150);
        
    }];
    
    [maxTextField setFont:[UIFont boldFont:22]];
    [maxTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName : [UIColor gary217],NSFontAttributeName : [UIFont regularFont:15]}]];
    [maxTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [maxTextField setTextAlignment:NSTextAlignmentRight];
    [maxTextField setDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn)];
    
    [self addGestureRecognizer:tap];
}


-(void)textFieldShouldReturn {
    
    [maxTextField resignFirstResponder];
    [minTextField resignFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField.text.length + string.length > 5) {
        
        return NO;
        
    }
    
    if (textField.text.length < range.location + range.length) {
        
        return NO;
        
    }
    
    
    
    return YES;
    
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    
    
    if (![maxTextField.text isEqual: @""] && ![minTextField.text isEqual: @""]) {
        
        
        _minNum = [minTextField.text integerValue];
        _maxNum = [maxTextField.text integerValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseTextFieldDidEndEditing" object:nil];
    }
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (![maxTextField isExclusiveTouch]) {
        
        [maxTextField resignFirstResponder];
        
    }
    
    if (![minTextField isExclusiveTouch]) {
        
        [minTextField resignFirstResponder];
        
    }
    
    
    
}


@end
