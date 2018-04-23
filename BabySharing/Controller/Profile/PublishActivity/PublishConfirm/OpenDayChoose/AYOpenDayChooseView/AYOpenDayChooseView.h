//
//  AYOpenDayChooseView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYCalendarDate.h"

@interface AYOpenDayChooseView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) AYCalendarDate *calendarDate;

@property(nonatomic, strong) NSMutableArray *selectedDate;


@end
