//
//  AYMapViewView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapViewView.h"
#import "AYCommandDefines.h"
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
	CLLocation *loc;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.delegate = self;
    [self setZoomLevel:120.1];
//    self.zoomLevel = 0.5;
    annoArray = [[NSMutableArray alloc]init];
    
//    self.userTrackingMode = MKUserTrackingModeFollow;
//    self.userTrackingMode = MKUserTrackingModeNone;
//    self.centerCoordinate = self.userLocation.location.coordinate;
//    self.rotateEnabled = NO;
	
	UIButton *showMyself = [[UIButton alloc]init];
	[showMyself setImage:IMGRESOURCE(@"position_myself") forState:UIControlStateNormal];
//	[Tools setViewRadius:showMyself withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	[self addSubview:showMyself];
	[showMyself mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(-20);
		make.bottom.equalTo(self).offset(-220);
		make.size.mas_equalTo(CGSizeMake(37, 37));
	}];
	[showMyself addTarget:self action:@selector(didShowMyselfBtnClick) forControlEvents:UIControlEventTouchUpInside];
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

-(id)changeResultData:(NSDictionary*)args {
    resultAndLoc = args;
    
    if (annoArray.count != 0) {
        [self removeAnnotations:annoArray];
		[annoArray removeAllObjects];
    }
    if (currentAnno) {
        [self removeAnnotation:currentAnno];
    }
    
    loc = [resultAndLoc objectForKey:@"location"];
    fiteResultData = [resultAndLoc objectForKey:@"result_data"];
    
    for (int i = 0; i < fiteResultData.count; ++i) {
        NSDictionary *info = fiteResultData[i];
        
        NSDictionary *dic_loc = [info objectForKey:@"location"];
        NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
        NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
        
        AYAnnonation *anno = [[AYAnnonation alloc]init];
        anno.coordinate = location.coordinate;
		NSString *annoTitle = [info objectForKey:kAYServiceArgsAddress];
        anno.title = annoTitle;
        anno.imageName = @"position_normal";
        anno.index = i;
        [self addAnnotation:anno];
        [annoArray addObject:anno];
    }
    
    //rang
    //    self.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 60000, loc.coordinate.longitude - 90000, 120000, 180000);
    currentAnno = [[AYAnnonation alloc]init];
    currentAnno.coordinate = loc.coordinate;
    currentAnno.title = @"定位位置";
    currentAnno.imageName = @"location_self";
    currentAnno.index = 9999;
    [self addAnnotation:currentAnno];
//    [self showAnnotations:@[currentAnno] animated:NO];
//    [self regionThatFits:MACoordinateRegionMake(loc.coordinate, MACoordinateSpanMake(loc.coordinate.latitude,loc.coordinate.longitude))];
    
    [self setCenterCoordinate:loc.coordinate animated:NO];
    
    return nil;
}

#pragma mark -- actios
- (void)didShowMyselfBtnClick {
	[self setCenterCoordinate:loc.coordinate animated:YES];
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
        
        //展示详情界面
        annotationView.canShowCallout = NO;
        return annotationView;
    } else {
        //采用系统默认蓝色大头针
        return nil;
    }
}

#pragma mark -- mapView delegate
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
        tmp.image = [UIImage imageNamed:@"position_normal"];
    }
    view.image = nil;
    view.image = [UIImage imageNamed:@"position_focus"];
    tmp = view;
    [self setCenterCoordinate:anno.coordinate animated:YES];
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendChangeOffsetMessage:"];
    NSNumber *index = [NSNumber numberWithFloat:(anno.index)];
    [cmd performWithResult:&index];
    
}

-(id)changeAnnoView:(NSNumber*)index {
    
    if (index.longValue >= fiteResultData.count) {
        return nil;
    }
    
    NSDictionary *info = fiteResultData[index.longValue];
    
    NSDictionary *dic_loc = [info objectForKey:@"location"];
    NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
    NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    [self setCenterCoordinate:location.coordinate animated:YES];
    
    for ( AYAnnonation *one in annoArray) {
        if (one.index == index.longValue) {
            
            MAAnnotationView *change_view = [self viewForAnnotation:one];
            if (tmp && tmp == change_view) {
                return nil;
            }
            if (tmp && tmp != change_view) {
                tmp.image = nil;
                tmp.image = [UIImage imageNamed:@"position_normal"];
            }
            change_view.image = nil;
            change_view.image = [UIImage imageNamed:@"position_focus"];
            tmp = change_view;
            break;
        }
    }
    
    return nil;
}

- (void)dealloc {
    [self clearDisk];
}
@end
