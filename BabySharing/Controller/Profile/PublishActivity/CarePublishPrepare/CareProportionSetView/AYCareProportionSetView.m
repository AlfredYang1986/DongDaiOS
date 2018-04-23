//
//  AYCareProportionSetView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCareProportionSetView.h"

@implementation AYCareProportionSetView {
    
    UITextField *teacher;
    UITextField *student;
    UITextField *people;
    
}
@synthesize teacherNum = _teacherNum;
@synthesize studentNum = _studentNum;
@synthesize peopleNum = _peopleNum;

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
    
    UILabel *head = [UILabel creatLabelWithText:@"该年龄段师生配比" textColor:[UIColor black] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:head];
    
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(40);
        
    }];
    [head setFont:[UIFont mediumFont:24]];
    
    CGFloat width = (SCREEN_WIDTH - 40 - 58) / 2;
    
    teacher = [[UITextField alloc] init];
    [self addSubview:teacher];
    [teacher setFont:[UIFont boldFont:22]];
    [teacher mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.equalTo(head.mas_bottom).offset(40);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(64);
        
    }];
    
    [teacher.layer setCornerRadius:4];
    [teacher.layer setMasksToBounds:YES];
    
    [teacher setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"老师数量" attributes:@{NSForegroundColorAttributeName : [UIColor gary217],NSFontAttributeName : [UIFont regularFont:15]}]];
    
    [teacher setTextAlignment:NSTextAlignmentCenter];
    [teacher setKeyboardType:UIKeyboardTypeNumberPad];
    [teacher setBackgroundColor:[UIColor garyBackground]];
    
    
    [teacher setDelegate:self];
    
   
    
    student = [[UITextField alloc] init];
    [self addSubview:student];
    [student setFont:[UIFont boldFont:22]];
    [student mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self -> teacher);
        make.right.mas_equalTo(-20);
        make.size.equalTo(self -> teacher);
        
    }];
    
    [student.layer setCornerRadius:4];
    [student.layer setMasksToBounds:YES];
    
    [student setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"孩子数量" attributes:@{NSForegroundColorAttributeName : [UIColor gary217],NSFontAttributeName : [UIFont regularFont:15]}]];
    [student setTextAlignment:NSTextAlignmentCenter];
    [student setKeyboardType:UIKeyboardTypeNumberPad];
    [student setBackgroundColor:[UIColor garyBackground]];
    
    
    [student setDelegate:self];
    
    UILabel *rate = [UILabel creatLabelWithText:@":" textColor:[UIColor black] fontSize:22.0f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:rate];
    
    [rate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self -> teacher);
        make.centerX.equalTo(self);
        
    }];
    
    [rate setFont:[UIFont boldFont:22]];
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(64);
        make.top.equalTo(self -> teacher.mas_bottom).offset(40);
    }];
    
    [view setBackgroundColor:[UIColor garyBackground]];
    
    [view.layer setCornerRadius:4];
    [view.layer setMasksToBounds:YES];
    
    UILabel *peopleLabel = [UILabel creatLabelWithText:@"场地容纳人数" textColor:[UIColor black] font:[UIFont regularFontSF:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [view addSubview:peopleLabel];
    
    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
        make.centerY.equalTo(view);
        
    }];
    
    people = [[UITextField alloc] init];
    [view addSubview:people];
    [people setFont:[UIFont boldFont:22]];
    [people mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-16);
        make.centerY.equalTo(view);
        
    }];
    [people setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName : [UIColor gary217],NSFontAttributeName : [UIFont regularFont:15]}]];
    [people setTextAlignment:NSTextAlignmentRight];
    [people setKeyboardType:UIKeyboardTypeNumberPad];
    [people setDelegate:self];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn)];
    
    [self addGestureRecognizer:tap];
    
    
    
    
}

-(void)textFieldShouldReturn {
    
    [teacher resignFirstResponder];
    [student resignFirstResponder];
    [people resignFirstResponder];
    
    
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
    
    
    if (![teacher.text isEqual: @""] && ![student.text isEqual: @""] && ![people.text isEqual:@""]) {
        
        
        _teacherNum = [teacher.text integerValue];
        _studentNum = [student.text integerValue];
        _peopleNum = [people.text integerValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CareTextFieldDidEndEditing" object:nil];
    }
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (![teacher isExclusiveTouch]) {
        
        [teacher resignFirstResponder];
        
    }
    
    if (![student isExclusiveTouch]) {
        
        [student resignFirstResponder];
        
    }
    
    
    
}


@end
