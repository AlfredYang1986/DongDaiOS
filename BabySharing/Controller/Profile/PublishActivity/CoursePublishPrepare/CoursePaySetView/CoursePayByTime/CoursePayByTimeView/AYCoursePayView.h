//
//  AYCoursePayView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYCoursePayView : UIView <UITextFieldDelegate>

@property(nonatomic, strong) UITextField *myTextField;

-(instancetype)initWithTitle:(NSString *)title and:(NSString *)placeholder andFont: (UIFont *)font ;

@end
