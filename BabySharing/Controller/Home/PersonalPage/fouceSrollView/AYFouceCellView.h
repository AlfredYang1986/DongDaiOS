//
//  AYFouceCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface AYFouceCellView : UITableViewCell< SDCycleScrollViewDelegate >
@property (nonatomic, strong) UIImageView *friendsImage;
@property (nonatomic, strong) UIImageView *popImage;
@property (nonatomic, strong) NSArray *imageNameArr;
@end
