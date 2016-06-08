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
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.delegate = self;
//    self.userTrackingMode = MKUserTrackingModeFollow;
//    self.userTrackingMode = MKUserTrackingModeNone;
//    self.centerCoordinate = self.userLocation.location.coordinate;
    
    AYAnnonation *anno = [[AYAnnonation alloc]init];
    
    anno.coordinate = CLLocationCoordinate2DMake(39.901508, 116.406997);
    anno.title = @"不知道哪";
    //    anno.subtitle = @"working!!!";
    anno.imageName = @"category_3";
    [self addAnnotation:anno];
    
    AYAnnonation *anno2 = [[AYAnnonation alloc]init];
    anno2.coordinate = CLLocationCoordinate2DMake(39.961508, 116.456997);
    anno2.title = @"三元桥";
    //    anno2.subtitle = @"working!!!";
    anno2.imageName = @"category_3";
    
    [self addAnnotation:anno2];
}

- (void)layoutSubviews{
    
    id<AYCommand> query_cmd = [self.notifies objectForKey:@"queryTheLoc:"];
    CLLocation *loc = nil;
    [query_cmd performWithResult:&loc];
    //rang
    self.visibleMapRect = MKMapRectMake(loc.coordinate.latitude - 60000, loc.coordinate.longitude - 100000, 120000, 200000);
    //center
    [self setCenterCoordinate:loc.coordinate animated:NO];
    
//    AYAnnonation *anno0 = [[AYAnnonation alloc]init];
//    anno0.coordinate = loc.coordinate;
//    [self addAnnotation:anno0];
    
    
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

#pragma mark -- MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[AYAnnonation class]]) {
        //默认就是红色小球
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
        
        //采用系统默认  蓝色大头针
        return nil;
        
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
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
    AYAnnonation *anno = view.annotation;
    tmp = view;
    
    [self setCenterCoordinate:anno.coordinate animated:YES];
}

-(id)www{
    
    return nil;
}

@end
