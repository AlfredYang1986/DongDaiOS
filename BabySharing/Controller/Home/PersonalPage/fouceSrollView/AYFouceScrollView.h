//
//  AYFouceScrollView.h
//  BabySharing
//
//  Created by Alfred Yang on 12/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "SDCycleScrollView.h"

//@interface AYFouceScrollView : UIScrollView <AYViewBase, UIScrollViewDelegate>
//@interface AYFouceScrollView : UICollectionView <AYViewBase, UICollectionViewDelegate, UICollectionViewDataSource>
//@interface AYFouceScrollView : SDCycleScrollView <AYViewBase, SDCycleScrollViewDelegate>
@interface AYFouceScrollView : UIView <AYViewBase, SDCycleScrollViewDelegate>

@end
