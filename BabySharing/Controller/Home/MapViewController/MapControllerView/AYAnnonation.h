//
//  AYAnnonation.h
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AYAnnonation : NSObject <MAAnnotation>
//位置
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//大标题
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) long index;
@end
