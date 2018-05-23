//
//  AYCourseAgeChooseView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AYAgePickView.h"
#import "AYAgePickViewDelegate.h"

@interface AYCourseAgeChooseView : UIView <AYAgePickViewDelegate>

@property(nonatomic, strong) AYAgePickView *pickView;
@property(nonatomic, readonly) double ageMin;
@property(nonatomic, readonly) double ageMax;

@end
