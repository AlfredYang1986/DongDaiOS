//
//  AYOpenDayChooseCellView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYOpenDayChooseCellView : UICollectionViewCell

@property (nonatomic, copy) NSString *day;

@property (nonatomic, assign) BOOL isGone;

@property (nonatomic, assign) double timeSpan;

@property (nonatomic, assign) BOOL isSelected;

-(void)today;



@end
