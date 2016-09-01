//
//  AYMapViewView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapViewView.h"
#import "AYCommandDefines.h"
#import "Tools.h"
#import <MapKit/MapKit.h>
#import "AYAnnonation.h"

@interface AYMapViewView () <MKMapViewDelegate>
@property (nonatomic,strong)CLLocationManager *manager;
@end

@implementation AYMapViewView{
    MAAnnotationView *tmp;
    NSArray *arrayWithLoc;
    AYAnnonation *currentAnno;
    NSMutableArray *annoArray;
    
    NSDictionary *resultAndLoc;
    NSArray *fiteResultData;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.delegate = self;
    annoArray = [[NSMutableArray alloc]init];
//    self.userTrackingMode = MKUserTrackingModeFollow;
//    self.userTrackingMode = MKUserTrackingModeNone;
//    self.centerCoordinate = self.userLocation.location.coordinate;
//    self.rotateEnabled = NO;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (annoArray.count != 0) {
        [self removeAnnotations:annoArray];
        NSLog(@"remove arr");
    }
    if (currentAnno) {
        [self removeAnnotation:currentAnno];
        NSLog(@"remove current_anno");
    }
    
    CLLocation *loc = [resultAndLoc objectForKey:@"location"];
    fiteResultData = [resultAndLoc objectForKey:@"result_data"];
    
    for (int i = 0; i < fiteResultData.count; ++i) {
        NSDictionary *info = fiteResultData[i];
        
        NSDictionary *dic_loc = [info objectForKey:@"location"];
        NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
        NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
        
        AYAnnonation *anno = [[AYAnnonation alloc]init];
        anno.coordinate = location.coordinate;
        anno.title = @"谁知道哪！";
        anno.imageName = @"position_small";
        anno.index = i + 200;
        [self addAnnotation:anno];
        NSLog(@"add anno");
        [annoArray addObject:anno];
    }
    
    //rang
    self.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 60000, loc.coordinate.longitude - 90000, 120000, 180000);
    currentAnno = [[AYAnnonation alloc]init];
    currentAnno.coordinate = loc.coordinate;
    currentAnno.title = @"定位位置";
    currentAnno.imageName = @"location_self";
    currentAnno.index = 9999;
    [self addAnnotation:currentAnno];
    NSLog(@"add current_anno");
//    [annoArray addObject:anno];
//    currentAnno = anno;
    //center
    [self setCenterCoordinate:loc.coordinate animated:NO];
    
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

-(id)changeAnnoView:(NSNumber*)index{
    NSLog(@"sunfei -- %@",index);
    
    NSDictionary *info = fiteResultData[index.integerValue];
    
    NSDictionary *dic_loc = [info objectForKey:@"location"];
    NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
    NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    [self setCenterCoordinate:location.coordinate animated:YES];
    
    for (NSObject *sub in self.subviews) {
        NSLog(@"%@",sub);
        if ([sub isKindOfClass:[UIView class]]) {
            for (NSObject *sub_2 in ((UIView*)sub).subviews) {
                NSLog(@"%@--%@",sub,sub_2);
//                if ([sub_2 isKindOfClass:[MAMapScrollView class]]) { //MAMapScrollView
//                    for (NSObject *sub_3 in ((UIScrollView*)sub_2).subviews) {
//                        NSLog(@"\n====%@",sub_3);
//                    }
//                }
            }
        }
//        if (sub.tag == 200 + index.integerValue) {
//            
//        }
    }
    
//    AYAnnonation *anno = [[AYAnnonation alloc]init];
//    anno.coordinate = location.coordinate;
//    anno.title = @"谁知道哪！";
//    anno.imageName = @"position_small";
//    anno.index = index.integerValue;
    
//    [self addAnnotation:anno];
//    NSLog(@"replace anno");
//    [annoArray addObject:anno];
    return nil;
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

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {//MKAnnotation
    AYAnnonation *anno = view.annotation;
    if (anno.index == 9999) {
        return;
    }
    
    if (tmp && tmp == view) {
        return;
    }
    if (tmp && tmp != view) {
        tmp.image = nil;
        tmp.image = [UIImage imageNamed:@"position_small"];
    }
    view.image = nil;
    view.image = [UIImage imageNamed:@"position_big"];
    tmp = view;
    [self setCenterCoordinate:anno.coordinate animated:YES];
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendChangeOffsetMessage:"];
    NSNumber *index = [NSNumber numberWithFloat:(anno.index-200)];
    [cmd performWithResult:&index];
}

@end
