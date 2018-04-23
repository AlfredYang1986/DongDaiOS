//
//  AYCareAgeChooseView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AYAgePickView.h"
#import "AYAgePickViewDelegate.h"

@interface AYCareAgeChooseView : UIView <AYAgePickViewDelegate>

@property(nonatomic, strong) AYAgePickView *pickView;
@property(nonatomic, readonly) NSInteger ageMin;
@property(nonatomic, readonly) NSInteger ageMax;

@end
