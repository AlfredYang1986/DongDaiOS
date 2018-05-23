//
//  AYAgePickView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYAgePickViewDelegate.h"


@interface AYAgePickView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) id<AYAgePickViewDelegate> delegate;
@property (nonatomic, readonly, assign) BOOL isShowed;

+(AYAgePickView *)show;

-(void)dismiss;

@end
