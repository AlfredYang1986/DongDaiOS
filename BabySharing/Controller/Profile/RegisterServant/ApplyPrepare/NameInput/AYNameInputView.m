//
//  AYNameInputView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYNameInputView.h"



@implementation AYNameInputView {
    
    UITextField * name;
    UITextField * brand;
    
}

@synthesize delegate = _delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *time = [NSDate getTheTimeBucket];
        
        UILabel *head = [UILabel creatLabelWithText:[NSString stringWithFormat:@"%@\n我该怎么称呼你？",time] textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(40);
            
        }];
        
        name = [[UITextField alloc] init];
        
        [self addSubview:name];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(head.mas_bottom).offset(35);
            make.height.mas_equalTo(30);
            
        }];
        
        [name setDelegate:self];
        [name setReturnKeyType:UIReturnKeyNext];
        [name setFont:[UIFont regularFontSF:15.0f]];
        [name setContentVerticalAlignment:(UIControlContentVerticalAlignmentBottom)];
        
        UIView *line_1 = [[UIView alloc] init];
        
        [self addSubview:line_1];
        
        [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self -> name);
            make.height.mas_equalTo(1);
            make.top.equalTo(self -> name.mas_bottom).offset(10);
            
        }];
        
        [line_1 setBackgroundColor:[UIColor garyLine]];
        
        UILabel *brandLabel = [UILabel creatLabelWithText:@"如果有品牌名称,也请告诉我们" textColor:[UIColor black] font:[UIFont mediumFont:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:brandLabel];
        
        [brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.equalTo(line_1).offset(64);
        }];
        
        brand = [[UITextField alloc] init];
        
        [self addSubview:brand];
        
        [brand mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(brandLabel).offset(40);
            make.height.mas_equalTo(30);
            
        }];
        
        [brand setDelegate:self];
        [brand setReturnKeyType:UIReturnKeyDone];
        [brand setFont:[UIFont regularFontSF:15.0f]];
        [brand setContentVerticalAlignment:(UIControlContentVerticalAlignmentBottom)];
        
        UIView *line_2 = [[UIView alloc] init];
        
        [self addSubview:line_2];
        
        [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self -> brand);
            make.height.mas_equalTo(1);
            make.top.equalTo(self -> brand.mas_bottom).offset(10);
            
        }];
        
        [line_2 setBackgroundColor:[UIColor garyLine]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn)];
        
        [self addGestureRecognizer:tap];

        
    }
    
    return self;
    
    
}

-(void)textFieldShouldReturn {
    
    [name resignFirstResponder];
    [brand resignFirstResponder];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == name) {
        
        [name resignFirstResponder];
        [brand becomeFirstResponder];
        
    }else if(textField == brand) {
        
        [brand resignFirstResponder];
        
    }
    
    return YES;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (![name isExclusiveTouch]) {
        
        [name resignFirstResponder];
        
    }
    
    if (![brand isExclusiveTouch]) {
        
        [brand resignFirstResponder];
        
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![name.text isEqual:@""]) {
        
        [_delegate updateName:name.text andBrand:brand.text];
        
    }
    
    if(![name.text isEqual:@""] && ![name.text isEqual:@""]) {
        
        
        [_delegate updateName:name.text andBrand:brand.text];
        
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
