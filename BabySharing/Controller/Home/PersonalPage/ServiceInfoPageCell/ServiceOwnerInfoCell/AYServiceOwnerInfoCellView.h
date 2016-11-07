//
//  AYServiceOwnerInfoCellVeiw.h
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>


@interface AYServiceOwnerInfoCellView : UITableViewCell <AYViewBase>
@property (nonatomic, strong) CLGeocoder *gecoder;
@end
