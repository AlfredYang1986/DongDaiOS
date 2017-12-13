//
//  UIView+RunTimeCmd.h
//  BabySharing
//
//  Created by Alfred Yang on 7/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "AYViewController.h"

@interface UIView (RunTimeCmd)

- (void)controller:(id)vc performSeletor:(NSString*)selector withResult:(NSObject**)obj;
- (void)performMessage:(NSString*)selector withResult:(NSObject**)obj;


- (void)setRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color background:(UIColor*)backColor;
@end
