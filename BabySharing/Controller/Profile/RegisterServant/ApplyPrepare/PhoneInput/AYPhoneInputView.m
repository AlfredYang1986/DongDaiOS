//
//  AYPhoneInputView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYPhoneInputView.h"
#import "AYFacadeBase.h"
@implementation AYPhoneInputView {
    
    UITextField *phone;
    
}


- (instancetype)initWithName:(NSString *)name city:(NSString *)city {
    
    self = [super init];
    
    if (self) {
        
        UILabel *head = [UILabel creatLabelWithText:[NSString stringWithFormat:@"非常好，来自%@的%@\n我们怎样可以联系到你？",city, name] textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(40);
        
        }];
        
        UILabel *tip = [UILabel creatLabelWithText:@"手机号" textColor:[UIColor gary166] font:[UIFont regularFont:15.0f] backgroundColor:nil textAlignment:NSTextAlignmentRight];
        
        [self addSubview:tip];
        
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.equalTo(head.mas_bottom).offset(80);
            make.width.mas_equalTo(48);
            
        }];
        
        phone = [[UITextField alloc] init];
        [self addSubview:phone];
        
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(tip.mas_right).offset(8);
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(tip);
            
        }];
        
        [phone setDelegate:self];
        [phone setFont:[UIFont regularFont:22]];
        [phone setKeyboardType:UIKeyboardTypeNumberPad];
        
        
        
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self -> phone);
            make.top.equalTo(self -> phone.mas_bottom).offset(16);
            make.height.mas_equalTo(1);
            
        }];
        
        [line setBackgroundColor:[UIColor garyLine]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn)];
        
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:phone];

    }
    
    return self;
    
}


- (void)textFieldTextDidChange:(NSNotification*)notification {
    
    if (notification.object == phone) {
        
        NSString *string = ((UITextField*)notification.object).text;
        
        [_delegate updatePhone:@"" valid:NO];
        
        if (string.length == 11) {
            
            if (![[string substringWithRange:NSMakeRange(3, 1)] isEqualToString:@" "]) {
                
                string = [[[string substringToIndex:3] stringByAppendingString:@" "] stringByAppendingString:[string substringFromIndex:3]];
                
                NSString *subs = [string substringWithRange:NSMakeRange(8, 1)];
                
                if (![subs isEqualToString:@" "]) {
                    string = [[[string substringToIndex:8] stringByAppendingString:@" "] stringByAppendingString:[string substringFromIndex:8]];
                    phone.text = string;
                }
            }
            
            
            
        } else if (phone.text.length >= 13) {
            
                if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,6,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:phone.text]) {
                
                    [phone resignFirstResponder];
                    NSString *title = @"手机号码输入错误";
                    AYShowBtmAlertView(title, BtmAlertViewTypeHideWithAction)

                    return;
                
                }else {

                    NSString *phoneNum = [phone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    [_delegate updatePhone:phoneNum valid:YES];
                    
                }
        
        }
        
    }
    
}





-(void)textFieldShouldReturn {
    
    [phone resignFirstResponder];
    
}

- (void)touchesEnded:(NSSet<UITouch*> *)touches withEvent:(UIEvent *)event {
    
    
    if (![phone isExclusiveTouch]) {
        
        [phone resignFirstResponder];
        
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![phone.text isEqual:@""]) {
        
        //[_delegate updatePhone:phone.text];
        NSLog(@"%@",phone.text);
        
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField == phone) {
        
        if (phone.text.length >= 13 && ![string isEqualToString:@""]){
            
            return NO;
            
        } else {
            
            NSString *tmp = phone.text;
            
            if ((tmp.length == 3 || tmp.length == 8) && ![string isEqualToString:@""]) {
                
                tmp = [tmp stringByAppendingString:@" "];
                
                phone.text = tmp;
                
            }
            return YES;
        }
        
        
    } else{
        
        return YES;
        
    }
    
    
    
    
}



@end
