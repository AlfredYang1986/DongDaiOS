//
//  AYAlertTipView.h
//  BabySharing
//
//  Created by Alfred Yang on 29/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

@interface AYAlertTipView : UIView <AYViewBase>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGSize titleSize;

- (instancetype)initWithTitle:(NSString*)title andTitleColor:(UIColor*)titleColor;
@end
