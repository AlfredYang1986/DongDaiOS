//
//  AYMainServInfoView.h
//  BabySharing
//
//  Created by Alfred Yang on 15/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didViewTap)();

@interface AYMainServInfoView : UIView

@property (nonatomic, copy) didViewTap tapBlocak;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTapBlock:(didViewTap)block;

- (void)markSetedStatus;
- (void)hideCheckSign;
- (void)setTitleWithString:(NSString*)title;

@end
