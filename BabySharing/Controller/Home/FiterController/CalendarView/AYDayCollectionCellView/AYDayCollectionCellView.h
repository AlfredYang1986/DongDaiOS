//
//  AYDayCollectionCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 23/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYDayCollectionCellView : UICollectionViewCell

/** 月 */
@property (nonatomic, copy) NSString *gregoiainDay;
@property (nonatomic, copy) NSString *dayDay;
/** 日 */
@property (nonatomic, copy) NSString *lunarDay;

/** 阳历 */
@property (nonatomic, copy) NSString *gregoiainCalendar;
/** 农历 */
@property (nonatomic, copy) NSString *chineseCalendar;

@end
