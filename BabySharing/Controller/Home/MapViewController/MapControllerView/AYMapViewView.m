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
    MKAnnotationView *tmp;
    NSArray *arrayWithLoc;
    AYAnnonation *currentAnno;
    NSMutableArray *annoArray;
    
    NSDictionary *resultAndLoc;
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

}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self removeAnnotations:annoArray];
    
//    id<AYCommand> query_cmd = [self.notifies objectForKey:@"queryTheLoc:"];
//    NSDictionary *resultAndLoc = nil;
//    [query_cmd performWithResult:&resultAndLoc];
    
    CLLocation *loc = [resultAndLoc objectForKey:@"location"];
    NSArray *fiteResultData = [resultAndLoc objectForKey:@"result_data"];
    
    for (int i = 0; i < fiteResultData.count; ++i) {
        NSDictionary *info = fiteResultData[i];
        
        NSDictionary *dic_loc = [info objectForKey:@"location"];
        NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
        NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
        
        AYAnnonation *anno = [[AYAnnonation alloc]init];
        anno.coordinate = location.coordinate;
        anno.title = @"不知道哪";
        anno.imageName = @"category_3";
        anno.index = i;
        [self addAnnotation:anno];
        [annoArray addObject:anno];
    }
    
    //rang
    self.visibleMapRect = MKMapRectMake(loc.coordinate.latitude - 80000, loc.coordinate.longitude - 140000, 160000, 280000);
    AYAnnonation *anno = [[AYAnnonation alloc]init];
    anno.coordinate = loc.coordinate;
    anno.title = @"定位位置";
    anno.imageName = @"category_5";
    anno.index = 9999;
    [self addAnnotation:anno];
    [annoArray addObject:anno];
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
//    NSLog(@"sunfei -- %@",index);
    
    return nil;
}

-(id)changeResultData:(NSDictionary*)args{
    resultAndLoc = args;
    return nil;
}
#pragma mark -- MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[AYAnnonation class]]) {
        //默认红色小球
        static NSString *ID = @"anno";
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        }
        //设置属性 指定图片
        AYAnnonation *anno = (AYAnnonation *) annotation;
        annotationView.image = [UIImage imageNamed:anno.imageName];
        //展示详情界面
        annotationView.canShowCallout = NO;
//        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }else{
        
        //采用系统默认蓝色大头针
        return nil;
        
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    AYAnnonation *anno = view.annotation;
    if (anno.index == 9999) {
        return;
    }
    NSLog(@"didSelectAnnotationView");
    if (tmp && tmp == view) {
        return;
    }
    if (tmp && tmp != view) {
        tmp.image = nil;
        tmp.image = [UIImage imageNamed:@"category_3"];
    }
    view.image = nil;
    view.image = [UIImage imageNamed:@"category_5"];
    
    tmp = view;
    
    [self setCenterCoordinate:anno.coordinate animated:YES];
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendChangeOffsetMessage:"];
    NSNumber *index = [NSNumber numberWithFloat:anno.index];
    [cmd performWithResult:&index];
}

@end
