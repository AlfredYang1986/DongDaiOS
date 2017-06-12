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
//#import "MAUserLocationView7.h"

@interface AYMapViewView () <MKMapViewDelegate>
@property (nonatomic,strong)CLLocationManager *manager;
@end

@implementation AYMapViewView{
    MAAnnotationView *annoViewHandle;
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
	[self setZoomLevel:60.1 animated:YES];
    annoArray = [[NSMutableArray alloc]init];
	
//    self.centerCoordinate = self.userLocation.location.coordinate;
//    self.rotateEnabled = NO;
	
	UIButton *showMyself = [[UIButton alloc]init];
	[showMyself setImage:IMGRESOURCE(@"position_myself") forState:UIControlStateNormal];
//	[Tools setViewRadius:showMyself withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	[self addSubview:showMyself];
	[showMyself mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(-20);
		make.bottom.equalTo(self).offset(-220);
		make.size.mas_equalTo(CGSizeMake(42, 42));
	}];
	[showMyself addTarget:self action:@selector(didShowMyselfBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)changeResultData:(NSDictionary*)args {
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
        NSDictionary *service_info = fiteResultData[i];
        
		NSDictionary *dic_loc = [service_info objectForKey:kAYServiceArgsLocation];
		NSNumber *latitude = [dic_loc objectForKey:kAYServiceArgsLatitude];
		NSNumber *longitude = [dic_loc objectForKey:kAYServiceArgsLongtitude];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
		
		AYAnnonation *anno = [[AYAnnonation alloc]init];
		anno.coordinate = location.coordinate;
		NSString *annoTitle = [service_info objectForKey:kAYServiceArgsAddress];
		anno.title = annoTitle;
		anno.index = i;
		
		NSNumber *serviceCat = [service_info objectForKey:kAYServiceArgsServiceCat];
		NSNumber *cansCat = [service_info objectForKey:kAYServiceArgsTheme];
		NSString *pre_map_icon_name;
		if (serviceCat.intValue == ServiceTypeCourse) {
			pre_map_icon_name = @"map_icon_course";
		} else if(serviceCat.intValue == ServiceTypeNursery) {
			pre_map_icon_name = @"map_icon_nursery";
		}
		
		anno.imageName_normal = [NSString stringWithFormat:@"%@_%@_normal",pre_map_icon_name, cansCat];
		anno.imageName_select = [NSString stringWithFormat:@"%@_%@_select",pre_map_icon_name, cansCat];
		
        [self addAnnotation:anno];
        [annoArray addObject:anno];
    }
    
    //rang
    //    self.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 60000, loc.coordinate.longitude - 90000, 120000, 180000);
//    currentAnno = [[AYAnnonation alloc]init];
//    currentAnno.coordinate = loc.coordinate;
//    currentAnno.title = @"定位位置";
//    currentAnno.imageName_normal = @"location_self";
//    currentAnno.index = 9999;
//    [self addAnnotation:currentAnno];
//    [self regionThatFits:MACoordinateRegionMake(loc.coordinate, MACoordinateSpanMake(loc.coordinate.latitude,loc.coordinate.longitude))];
    [self setCenterCoordinate:loc.coordinate animated:NO];
	
	self.showsUserLocation = YES;
	
    return nil;
}

#pragma mark -- actios
- (void)didShowMyselfBtnClick {
	[self setCenterCoordinate:loc.coordinate animated:YES];
}

#pragma mark -- MKMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[AYAnnonation class]]) {
		
        static NSString *ID = @"AYMapAnnotationViewID";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        }
        //设置属性 指定图片
        AYAnnonation *anno = (AYAnnonation *) annotation;
        annotationView.image = [UIImage imageNamed:anno.imageName_normal];
        
        //展示详情界面
        annotationView.canShowCallout = NO;
        return annotationView;
    } else {
        //采用系统默认蓝色大头针
        return nil;
    }
}

#pragma mark -- mapView delegate
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {		//MKAnnotation
	
    AYAnnonation *anno = view.annotation;
	if ([anno isKindOfClass:[MAUserLocation class]]) {
		return;
	}
	
//    if (anno.index == 9999) {
//        return;
//    }
	
    if (annoViewHandle) {		//判断当前 是否已经有高亮的item
		if ( annoViewHandle != view) {		// 判断是否点击了已经是高亮的item
			AYAnnonation *anno_handleView = annoViewHandle.annotation;
			annoViewHandle.highlighted = NO;
//			annoViewHandle.image = nil;
			annoViewHandle.image = [UIImage imageNamed:anno_handleView.imageName_normal];
		} else
			return;
    }
	
	view.highlighted = YES;
//    view.image = nil;
    view.image = [UIImage imageNamed:anno.imageName_select];
	
	[self setCenterCoordinate:anno.coordinate animated:YES];
	
    annoViewHandle = view;
	
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendChangeOffsetMessage:"];
    NSNumber *index = [NSNumber numberWithFloat:(anno.index)];
    [cmd performWithResult:&index];
    
}

- (id)changeAnnoView:(NSNumber*)index {
    
    if (index.longValue >= fiteResultData.count) {
        return nil;
    }
	
    for ( AYAnnonation *one in annoArray) {
        if (one.index == index.longValue) {
            
            MAAnnotationView *change_view = [self viewForAnnotation:one];
			
			if (annoViewHandle) {		//判断当前 是否已经有高亮的item
				if ( annoViewHandle != change_view) {		// 判断是否点击了已经是高亮的item
					AYAnnonation *anno_handleView = annoViewHandle.annotation;
					annoViewHandle.highlighted = NO;
//					annoViewHandle.image = nil;
					annoViewHandle.image = [UIImage imageNamed:anno_handleView.imageName_normal];
				}
				else
					break;
			}
			
			NSDictionary *service_info = fiteResultData[index.longValue];
			NSDictionary *dic_loc = [service_info objectForKey:kAYServiceArgsLocation];
			NSNumber *latitude = [dic_loc objectForKey:kAYServiceArgsLatitude];
			NSNumber *longitude = [dic_loc objectForKey:kAYServiceArgsLongtitude];
			if (latitude && longitude) {
				CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
				change_view.highlighted = YES;
//				change_view.image = nil;
				change_view.image = [UIImage imageNamed:one.imageName_select];
//				[self bringSubviewToFront:change_view];
				
				[self setCenterCoordinate:location.coordinate animated:YES];
			}
			
			annoViewHandle = change_view;		//交接
			
			break;
        }
    }
    
    return nil;
}

- (void)dealloc {
    [self clearDisk];
}
@end
