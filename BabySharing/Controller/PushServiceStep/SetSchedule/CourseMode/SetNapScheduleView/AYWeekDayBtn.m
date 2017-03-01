//
//  AYWeekDayBtnView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYWeekDayBtn.h"

@implementation AYWeekDayBtn

- (instancetype)initWithTitle:(NSString*)title {
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = kAYFontLight(14.f);
        
        self.layer.cornerRadius = 30 * 0.5;
        self.clipsToBounds = YES;
        self.layer.borderColor = [Tools whiteColor].CGColor;
        self.layer.borderWidth = 0.f;
        self.layer.backgroundColor = [Tools whiteColor].CGColor;
    }

    return self;
}

- (void)setStates:(WeekDayBtnState)states {
    switch (states) {
        case WeekDayBtnStateNormal:
        {
            [self setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
            self.layer.borderWidth = 0.f;
            self.layer.backgroundColor = [Tools whiteColor].CGColor;
        }
            break;
        case WeekDayBtnStateSelected:
        {
            [self setTitleColor:[Tools whiteColor] forState:UIControlStateNormal];
            self.layer.borderWidth = 0.f;
            self.layer.backgroundColor = [Tools themeColor].CGColor;
        }
            break;
        case WeekDayBtnStateSeted:
        {
            [self setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
            self.layer.borderColor = [Tools themeColor].CGColor;
            self.layer.borderWidth = 1.f;
            self.layer.backgroundColor = [Tools whiteColor].CGColor;
        }
            break;
        default:
            break;
    }
}

@end
