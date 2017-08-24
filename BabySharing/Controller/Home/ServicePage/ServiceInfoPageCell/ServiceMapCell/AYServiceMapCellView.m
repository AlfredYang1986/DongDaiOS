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
	UIImageView *addressBg;
	UIImageView *addressArrowBg;
	
	UIView *tapview;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		orderMapView = [[MAMapView alloc] init];
		[self addSubview:orderMapView];
		[orderMapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 235));
			make.bottom.equalTo(self);
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
		
		addressLabel = [Tools creatUILabelWithText:@"Service address info" andTextColor:[Tools blackColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		addressLabel.numberOfLines = 2;
		[self addSubview:addressLabel];
		
		addressBg = [[UIImageView alloc]init];
		[self addSubview:addressBg];
		addressArrowBg = [[UIImageView alloc] init];
		[self addSubview:addressArrowBg];
		
//		[self bringSubviewToFront:addressBg];
		[self bringSubviewToFront:addressLabel];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"ServiceMapCell", @"ServiceMapCell");
	
	NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
	for (NSString* name in cell.commands.allKeys) {
		AYViewCommand* cmd = [cell.commands objectForKey:name];
		AYViewCommand* c = [[AYViewCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_commands setValue:c forKey:name];
	}
	self.commands = [arr_commands copy];
	
	NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
	for (NSString* name in cell.notifies.allKeys) {
		AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
		AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_notifies setValue:c forKey:name];
	}
	self.notifies = [arr_notifies copy];
}

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
	[addressLabel sizeToFit];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.bottom.equalTo(self.mas_top).offset(90);
		make.width.mas_lessThanOrEqualTo(254);
	}];
	
	UIImage *bg = IMGRESOURCE(@"map_address_bg_part_b");
	bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 15, 20) resizingMode:UIImageResizingModeTile];
	addressBg.image =  bg;
	[addressBg mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(addressLabel).insets(UIEdgeInsetsMake(-4, -12, -10, -12));
	}];
	
	UIImage *arrowBg = IMGRESOURCE(@"map_address_bg_part_a");
	arrowBg = [arrowBg resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 20, 0) resizingMode:UIImageResizingModeTile];
	addressArrowBg.image = arrowBg;
	[addressArrowBg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(addressLabel).offset(0);
		make.width.mas_equalTo(26);
		make.bottom.equalTo(addressLabel).offset(16);
		make.centerX.equalTo(addressLabel);
	}];
	
	NSDictionary *dic_loc = [info_loc objectForKey:kAYServiceArgsPin];
	NSNumber *latitude = [dic_loc objectForKey:kAYServiceArgsLatitude];
	NSNumber *longitude = [dic_loc objectForKey:kAYServiceArgsLongtitude];
//	CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longtitude.doubleValue];
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:longitude.doubleValue longitude:latitude.doubleValue];
	
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
