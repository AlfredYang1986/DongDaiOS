//
//  AYShowBoardCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import <MapKit/MapKit.h>

@interface AYShowBoardCellView : UIView

@property (nonatomic, strong) NSDictionary *contentInfo;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *friendsLabel;
@property (nonatomic, strong) UIImageView *starRangImage;
@property (nonatomic, strong) UILabel *contentCount;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *infoLabel;

@end
