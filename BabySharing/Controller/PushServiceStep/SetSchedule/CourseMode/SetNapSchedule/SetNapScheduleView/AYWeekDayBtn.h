//
//  AYWeekDayBtnView.h
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

typedef enum : int {
    WeekDayBtnStateNormal = 0,
    WeekDayBtnStateSelected = 1,
    WeekDayBtnStateSeted = 2,
	WeekDayBtnStateSmall = 3,
	WeekDayBtnStateNormalAnimat = 4,
} WeekDayBtnState;

#import <UIKit/UIKit.h>

@interface AYWeekDayBtn : UIButton

@property(nonatomic, assign) WeekDayBtnState states;
- (instancetype)initWithTitle:(NSString*)title;
@end
