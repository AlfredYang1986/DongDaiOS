//
//  OptionOfPlayingView.h
//  BabySharing
//
//  Created by Alfred Yang on 21/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionOfPlayingView : UIView

@property(nonatomic, strong) UIButton *optionBtn;

-(instancetype)initWithTitle:(NSString*)title andIndex:(NSInteger)index;

@end
