//
//  AYShowBoardCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

@interface AYShowBoardCellView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *friendsLabel;

@property (nonatomic, strong) UIButton *oneStarBtn;
@property (nonatomic, strong) UIButton *twoStarBtn;
@property (nonatomic, strong) UIButton *threeStarBtn;
@property (nonatomic, strong) UIButton *fourStarBtn;
@property (nonatomic, strong) UIButton *fiveStarBtn;

@end
