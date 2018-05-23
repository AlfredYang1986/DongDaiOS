//
//  AYCoursePayPriceView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCoursePayPriceView.h"

@implementation AYCoursePayPriceView

@synthesize myTextField = _myTextField;


- (instancetype)initWithTitle:(NSString *)title and:(NSString *)placeholder andFont:(UIFont *)font {
    
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor garyBackground]];
        [self.layer setCornerRadius:4];
        [self.layer setMasksToBounds:YES];
        
        UILabel *head = [UILabel creatLabelWithText:title textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(16);
            make.centerY.equalTo(self);
            
        }];
        [head setFont:font];
        
        _myTextField = [[UITextField alloc] init];
        [self addSubview:_myTextField];
        
        [_myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-16);
            make.width.mas_equalTo(56);
            make.centerY.equalTo(self);
            
        }];
        
        [_myTextField setDelegate:self];
        [_myTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_myTextField setFont:[UIFont boldFont:22]];
        
        
        UILabel *placeHolder = [UILabel creatLabelWithText:placeholder textColor:[UIColor gary217] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentRight];
        
        [self addSubview:placeHolder];
        
        [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self->_myTextField.mas_left).offset(-4);
            make.centerY.equalTo(self);
            
        }];
        
        [placeHolder setFont:[UIFont regularFont:15]];
        
        
    }
    return self;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length + string.length > 4) {
        
        return NO;
        
    }
    
    if (textField.text.length < range.location + range.length) {
        
        return NO;
        
    }
    
    return YES;
    
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//    
//    
//    
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    
//    if (![myTextField isExclusiveTouch]) {
//        
//        [myTextField resignFirstResponder];
//        
//    }
//    
//    
//}


@end
