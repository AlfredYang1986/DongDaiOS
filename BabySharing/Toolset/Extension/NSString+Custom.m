//
//  NSString+Custom.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/24.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

- (NSString *)deleteEndZero {
    
    NSArray *arr = [self componentsSeparatedByString:@"."];
    
    NSString *first = arr.firstObject;
    
    NSString *last = arr.lastObject;
    
    if ([last hasSuffix:@"0"]) {
        
        return first;
        
    }
    
    return self;
    
}

@end
