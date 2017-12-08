//
//  UIButton+Factory.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Factory)

/**
 *  PS: fontSize.正常数值为细体/300+为正常/600+为粗体
 */
+ (UIButton*)creatButtonWithTitle:(NSString*)title andTitleColor:(UIColor*)TitleColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor;

@end
