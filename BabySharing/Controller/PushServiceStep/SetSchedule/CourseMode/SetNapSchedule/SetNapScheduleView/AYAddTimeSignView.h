//
//  AYAddTimeSignView.h
//  BabySharing
//
//  Created by Alfred Yang on 12/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYAddTimeSignView : UIView

- (instancetype)initWithTitle:(NSString*)title;

- (void)setUnableStatus;
- (void)setEnableStatus;
- (void)setHeadStatus;

@end
