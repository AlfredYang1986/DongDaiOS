//
//  AYBOrderTimeItemView.h
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

typedef void(^touchUpInSubBtn)(NSDictionary*);

@interface AYBOrderTimeItemView : UICollectionViewCell <AYViewBase>
@property (nonatomic, strong) NSDictionary *item_data;
@property (nonatomic, strong) touchUpInSubBtn didTouchUpInSubBtn;
@property (nonatomic, assign) NSInteger multiple;

@property (nonatomic, assign) int day;
@property (nonatomic, assign) BOOL isDisable;
@property (nonatomic, assign) double timeSpan;
@property (nonatomic, assign) BOOL isSelectedItem;
@property (nonatomic, assign) BOOL isToday;

@end
