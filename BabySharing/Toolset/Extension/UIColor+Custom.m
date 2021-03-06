//
//  UIColor+Custom.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)blue92 {
    
    return [UIColor colorWithRed:92/255.0 green:171/255.0 blue:189/255.0 alpha: 1.0];
    
}

+ (UIColor *)white246 {
    
    return [UIColor colorWithRed:246/255.0 green:249/255.0 blue:251/255.0 alpha:1/1.0];
}

+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA {
	return [UIColor colorWithRed:RED / 255.0 green:GREEN / 255.0 blue:BLUE / 255.0 alpha:ALPHA];
}

+ (UIColor*)theme {
    
	return [UIColor colorWithRed:89.0/255.0 green:213.0/255.0 blue:199.0/255.0 alpha:1.0];
}

+ (UIColor *)theme179 {
    
    return [UIColor colorWithRed: 179/255. green: 230/255. blue: 219/255. alpha: 1];
    
}

+ (UIColor*)themeBorder {
	return [UIColor colorWithRed:189.f/255.0 green:238.f/255.0 blue:233.f/255.0 alpha:1.0];
}
+ (UIColor*)themeLight {
	return [UIColor colorWithRed:198.f/255.0 green:238.f/255.0 blue:233.f/255.0 alpha:1.0];
}

+ (UIColor*)black {
	return [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
}
+ (UIColor*)tag {
	return [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:79.0/255.0 alpha:1.0];
}

+ (UIColor*)white {
	return [UIColor whiteColor];
}

+ (UIColor*)gary {
	return [UIColor colorWithRed:178.f / 255.f green:178.f / 255.f blue:178.f / 255.f alpha:1.f];
}
+ (UIColor*)lightGary {
	return [UIColor colorWithRed:204.f / 255.f green:204.f / 255.f blue:204.f / 255.f alpha:1.f];
}

+ (UIColor *)line {
    
    return [UIColor colorWithRed:0.f / 255.f green:0.f / 255.f blue:0.f / 255.f alpha:0.05f];
    
}

+ (UIColor*)garyLine {
	return [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.f];
}
+ (UIColor*)gary250 {
	return [UIColor colorWithRed:250.f / 255.f green:250.f / 255.f blue:250.f / 255.f alpha:1.f];
}
+ (UIColor*)gary115 {
	return [UIColor colorWithRed:115 / 255.f green:115 / 255.f blue:115 / 255.f alpha:1.f];
}
+ (UIColor*)gary166 {
	return [UIColor colorWithRed:166 / 255.f green:166 / 255.f blue:166 / 255.f alpha:1.f];
}

+ (UIColor*)gary217 {
    return [UIColor colorWithRed:217 / 255.f green:217 / 255.f blue:217 / 255.f alpha:1.f];
    
}
+ (UIColor*)black13 {
	return [UIColor colorWithRed:13/255.0 green:13/255.0 blue:13/255.0 alpha:1.0];
}
+ (UIColor*)black64 {
	return [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
}

+ (UIColor*)RGB153Gary {
	return [UIColor colorWithRed:153.f / 255.f green:153.f / 255.f blue:153.f / 255.f alpha:1.f];
}


+ (UIColor*)RGB89Gary {
	return [UIColor colorWithRed:89.f / 255.f green:89.f / 255.f blue:89.f / 255.f alpha:1.f];
}
+ (UIColor*)RGB127Gary {
	return [UIColor colorWithRed:127.f / 255.f green:127.f / 255.f blue:127.f / 255.f alpha:1.f];
}
+ (UIColor*)RGB225Gary {
	return [UIColor colorWithRed:225.f / 255.f green:225.f / 255.f blue:225.f / 255.f alpha:1.f];
}

+ (UIColor*)darkBackground {
	return [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
}
+ (UIColor*)garyBackground {
	return [UIColor colorWithRed:246.f / 255.f green:249.f / 255.f blue:251.f / 255.f alpha:1.f];
}
+ (UIColor*)disableBackground {
	return [UIColor colorWithRed:144.f / 255.f green:144.f / 255.f blue:144.f / 255.f alpha:1.f];
}

+ (UIColor*)borderAlpha {
	return [UIColor colorWithWhite:1.f alpha:0.25f];
}

+ (UIColor *)random {
	return [self colorWithRED:(arc4random()%255) GREEN:(arc4random()%255) BLUE:(arc4random()%255) ALPHA:1.f];
	
}

+ (UIColor *)shadowColor {
    
    return [UIColor colorWithRed:132.f / 255.f green:188.f / 255.f blue:203.f / 255.f alpha:1.f];
    
}

@end
