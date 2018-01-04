//
//  AYServiceMapCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceMapCellView.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYPlayItemsView.h"
#import "AYAnnonation.h"

@implementation AYServiceMapCellView {
	
	MAMapView *orderMapView;
	AYAnnonation *currentAnno;
	
	UILabel *addressLabel;
	
	UIView *tapview;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *titleLabel = [UILabel creatLabelWithText:@"场地地址" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30);
//			make.bottom.equalTo(self).offset(-100);
		}];
		
		addressLabel = [UILabel creatLabelWithText:@"Map address info" textColor:[UIColor black] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		addressLabel.numberOfLines = 2;
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(20);
		}];
		
		orderMapView = [[MAMapView alloc] init];
		[self addSubview:orderMapView];
		[orderMapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(addressLabel.mas_bottom).offset(14);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCREEN_MARGIN_LR*2, 118));
			make.bottom.equalTo(self).offset(-20);
		}];
		orderMapView.delegate = self;
		orderMapView.scrollEnabled = NO;
		orderMapView.zoomEnabled = NO;
		[AMapSearchServices sharedServices].apiKey = kAMapApiKey;
		
		tapview = [[UIView alloc]init];
		[self addSubview:tapview];
		[tapview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(orderMapView);
		}];
		tapview.alpha = 0.05;
		tapview.userInteractionEnabled = YES;
		[tapview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didMapTap)]];
		
		
	}
	return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle

#pragma mark -- commands
- (void)postPerform {
	
}

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

- (id)setCellInfo:(id)args{
	
	NSDictionary *service_info = (NSDictionary*)args;
	
	NSDictionary *info_loc = [service_info objectForKey:kAYServiceArgsLocationInfo];
	NSString *addressStr = [info_loc objectForKey:kAYServiceArgsAddress];
	NSString *adjustAddressStr = [info_loc objectForKey:kAYServiceArgsAdjustAddress];
	if (addressStr && ![addressStr isEqualToString:@""]) {
		addressLabel.text = [NSString stringWithFormat:@"%@%@", addressStr, adjustAddressStr];
	}
	
	
	NSDictionary *dic_loc = [info_loc objectForKey:kAYServiceArgsPin];
	NSNumber *latitude = [dic_loc objectForKey:kAYServiceArgsLatitude];
	NSNumber *longitude = [dic_loc objectForKey:kAYServiceArgsLongtitude];
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
	
	if (latitude && longitude) {
		if (currentAnno) {
			[orderMapView removeAnnotation:currentAnno];
		}
		tapview.userInteractionEnabled = YES;
		//rang
//		orderMapView.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 2000, loc.coordinate.longitude - 1000, 4000, 2000);
		currentAnno = [[AYAnnonation alloc]init];
		currentAnno.coordinate = loc.coordinate;
		currentAnno.title = @"定位位置";
		currentAnno.imageName_normal = @"details_icon_maplocation";
		currentAnno.index = 9999;
		[orderMapView addAnnotation:currentAnno];
//		[orderMapView regionThatFits:MACoordinateRegionMake(loc.coordinate, MACoordinateSpanMake(loc.coordinate.latitude,loc.coordinate.longitude))];
//		CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(39.989612,116.480972), AMapCoordinateType);
		//center
		[orderMapView setCenterCoordinate:currentAnno.coordinate animated:YES];
	} else {
		tapview.userInteractionEnabled = NO;
	}
	
	return nil;
}

#pragma mark -- MKMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
	if ([annotation isKindOfClass:[AYAnnonation class]]) {
		
		static NSString *ID = @"anno";
		MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
		if (annotationView == nil) {
			annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
		}
		
		AYAnnonation *anno = (AYAnnonation *) annotation;
		annotationView.image = [UIImage imageNamed:anno.imageName_normal];	//设置属性 指定图片
		annotationView.tag = anno.index;
		annotationView.canShowCallout = NO;	//展示详情界面
		return annotationView;
	} else {
		
		return nil;
	}
}

#pragma mark -- actions
- (void)didMapTap {
	kAYViewSendNotify(self, @"showP2PMap", nil)
}

@end
