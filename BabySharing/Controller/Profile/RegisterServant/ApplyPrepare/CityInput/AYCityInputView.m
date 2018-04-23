//
//  AYCityInputView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCityInputView.h"

@implementation AYCityInputView {
    
    UITextField *city;
    
}

@synthesize delegate = _delegate;

- (instancetype)initWithName:(NSString *)name {
    
    self = [super init];
    if (self) {
        
        UILabel *head = [UILabel creatLabelWithText:[NSString stringWithFormat:@"你好，%@\n你的服务所在的城市？",name] textColor:[UIColor black] font:[UIFont mediumFont:22] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(40);
            
        }];
        
        city = [[UITextField alloc] init];
        [self addSubview:city];
        
        [city mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(head.mas_bottom).offset(75);
            make.height.mas_equalTo(30);
            
        }];
        [city setDelegate:self];
        [city setReturnKeyType:UIReturnKeyDone];
        [city setFont:[UIFont regularFontSF:15.0f]];
        [city setContentVerticalAlignment:(UIControlContentVerticalAlignmentBottom)];
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self -> city);
            make.top.equalTo(self -> city.mas_bottom).offset(16);
            make.height.mas_equalTo(1);
            
        }];
        
        [line setBackgroundColor:[UIColor garyLine]];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn)];
        
        [self addGestureRecognizer:tap];


        
    }
    return self;
    
}


-(void)textFieldShouldReturn {
    
    [city resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == city) {
        
        [city resignFirstResponder];
        
    }
    
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (![city isExclusiveTouch]) {
        
        [city resignFirstResponder];
        
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![city.text isEqual:@""]) {
        
        [_delegate updateCity:city.text];
        
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField.text.length + string.length > 20) {
        
        return NO;
        
    }
    
    if (textField.text.length < range.location + range.length) {
        
        return NO;
        
    }
    
    
    return YES;
    
    
}


@end
