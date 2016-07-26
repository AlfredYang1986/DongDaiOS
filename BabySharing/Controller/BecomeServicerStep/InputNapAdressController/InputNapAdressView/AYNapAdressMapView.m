//
//  AYNapAdressMapView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapAdressMapView.h"
#import "AYCommandDefines.h"
#import "Tools.h"
#import <MapKit/MapKit.h>
#import "AYAnnonation.h"

@implementation AYNapAdressMapView {
    MAAnnotationView *tmp;
    NSArray *arrayWithLoc;
    AYAnnonation *currentAnno;
    NSMutableArray *annoArray;
    
    NSDictionary *resultAndLoc;
    NSArray *fiteResultData;
    
    CLLocation *loc;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.delegate = self;
    self.scrollEnabled = NO;
    self.zoomEnabled = NO;
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"7d5d988618fd8a707018941f8cd52931";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

-(id)changeResultData:(NSDictionary*)args{
    resultAndLoc = args;
    return nil;
}
#pragma mark -- MKMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[AYAnnonation class]]) {
        //默认红色小球
        static NSString *ID = @"anno";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        }
        //设置属性 指定图片
        AYAnnonation *anno = (AYAnnonation *) annotation;
        annotationView.image = [UIImage imageNamed:anno.imageName];
        annotationView.tag = anno.index;
        //展示详情界面
        annotationView.canShowCallout = NO;
        return annotationView;
    } else {
        //采用系统默认蓝色大头针
        return nil;
        
    }
}

- (id)queryOnesLocal:(id)args{
    
    loc = (CLLocation*)args;
    
    if (currentAnno) {
        [self removeAnnotation:currentAnno];
        NSLog(@"remove current_anno");
    }
    
    //rang
    self.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 40000, loc.coordinate.longitude - 70000, 80000, 140000);
    currentAnno = [[AYAnnonation alloc]init];
    currentAnno.coordinate = loc.coordinate;
    currentAnno.title = @"定位位置";
    currentAnno.imageName = @"location_self";
    currentAnno.index = 9999;
    [self addAnnotation:currentAnno];
    NSLog(@"add current_anno");
    
    //center
    [self setCenterCoordinate:loc.coordinate animated:YES];
    
    return nil;
}
@end