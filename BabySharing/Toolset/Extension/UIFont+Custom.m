//
//  UIFont+Custom.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/9.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+ (UIFont *)boldFont:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    
}

+ (UIFont *)regularFont:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    
}

+ (UIFont *)regularFontSF:(CGFloat)size {
    
    return [UIFont fontWithName:@"SFProText-Regular" size:size];
    
}

+ (UIFont *)mediumFont:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    
}

+ (UIFont *)mediumFontSF:(CGFloat)size {
    
    return [UIFont fontWithName:@"SFProText-Medium" size:size];
    
}

@end
