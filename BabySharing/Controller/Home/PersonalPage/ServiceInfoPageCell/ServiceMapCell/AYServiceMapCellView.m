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
	
	UILabel *tipsTitleLabel;
	
	MAMapView *orderMapView;
	MAAnnotationView *tmp;
	NSArray *arrayWithLoc;
	AYAnnonation *currentAnno;
	NSMutableArray *annoArray;
	
	NSDictionary *resultAndLoc;
	NSArray *fiteResultData;
	
	UILabel *addressLabel;
	UIImageView *addressBg;
	
	UIButton *facalityBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		CGFloat margin = 0;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		tipsTitleLabel = [Tools creatUILabelWithText:@"地理位置" andTextColor:[Tools blackColor] andFontSize:-15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self).offset(30);
		}];
		
		orderMapView = [[MAMapView alloc]init];
		[self addSubview:orderMapView];
		[orderMapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 175));
			make.bottom.equalTo(self).offset(-90);
		}];
		orderMapView.delegate = self;
		orderMapView.scrollEnabled = NO;
		orderMapView.zoomEnabled = NO;
		//配置用户Key
		[AMapSearchServices sharedServices].apiKey = kAMapApiKey;
		
		addressLabel = [Tools creatUILabelWithText:@"service address" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		addressLabel.numberOfLines = 0;
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self.mas_top).offset(130);
//			make.width.mas_equalTo(200);
		}];
		
		addressBg = [[UIImageView alloc]init];
		[self addSubview:addressBg];
//		addressBg.contentMode = UIViewContentModeBottom;
		addressBg.image =  [IMGRESOURCE(@"address_bg") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
		[addressBg mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(addressLabel).insets(UIEdgeInsetsMake(-10, -15, -10, -15));
		}];
		
		[self bringSubviewToFront:addressBg];
		[self bringSubviewToFront:addressLabel];
		
		//
		facalityBtn = [Tools creatUIButtonWithTitle:nil andTitleColor:[Tools themeColor] andFontSize:20.f andBackgroundColor:nil];
		[facalityBtn addTarget:self action:@selector(didFacalityBtnClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:facalityBtn];
		[facalityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(orderMapView.mas_bottom).offset(45);
			make.right.equalTo(self).offset(-15);
			make.size.mas_equalTo(CGSizeMake(30, 30));
		}];
		
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
	NSString *addressStr = [service_info objectForKey:@"address"];
	addressLabel.text = addressStr;
	
	NSDictionary *dic_loc = [service_info objectForKey:@"location"];
	NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
	NSNumber *longtitude = [dic_loc objectForKey:@"longtitude"];
	CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longtitude.doubleValue];
	
	if (currentAnno) {
		[orderMapView removeAnnotation:currentAnno];
	}
	
	//rang
//	orderMapView.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 2000, loc.coordinate.longitude - 1000, 4000, 2000);
	currentAnno = [[AYAnnonation alloc]init];
	currentAnno.coordinate = loc.coordinate;
	currentAnno.title = @"定位位置";
	currentAnno.imageName = @"location_self";
	currentAnno.index = 9999;
	[orderMapView addAnnotation:currentAnno];
	[orderMapView regionThatFits:MACoordinateRegionMake(loc.coordinate, MACoordinateSpanMake(loc.coordinate.latitude,loc.coordinate.longitude))];
//	[orderMapView showAnnotations:@[currentAnno] animated:NO];
	NSLog(@"add current_anno");
	
	//center
	[orderMapView setCenterCoordinate:loc.coordinate animated:YES];
	
	//facility
	NSNumber *facility = [service_info objectForKey:kAYServiceArgsFacility];
	if (facility.intValue != 0) {
		
		NSArray *options_title_facility = kAY_service_options_title_facilities;
		
		long options = facility.longValue;
		CGFloat offsetX = 15;
		int noteCount = 0;
		int limitNumb =0;
		if (SCREEN_WIDTH < 375) {
			limitNumb = 3;
		} else
			limitNumb = 4;
		
		for (int i = 0; i < options_title_facility.count; ++i) {
			
			long note_pow = pow(2, i);
			if ((options & note_pow)) {
				
				if (noteCount < limitNumb) {
					
					NSString *imageName = [NSString stringWithFormat:@"facility_%d",i];
					AYPlayItemsView *item = [[AYPlayItemsView alloc]initWithTitle:options_title_facility[i] andIconName:imageName];
					[self addSubview:item];
					[item mas_makeConstraints:^(MASConstraintMaker *make) {
						make.left.mas_equalTo(self).offset(offsetX);
						make.centerY.equalTo(facalityBtn);
						make.size.mas_equalTo(CGSizeMake(50, 55));
					}];
					offsetX += 80;
				}
				noteCount ++;
			}
		}
		
		[facalityBtn setTitle:[NSString stringWithFormat:@"+%d",noteCount] forState:UIControlStateNormal];
	} else {		// == 0 未设置场地有好设置
		[orderMapView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(15);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 175));
			make.bottom.equalTo(self).offset(0);
		}];
	}
	
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

#pragma mark -- actions
- (void)didFacalityBtnClick {
	kAYViewSendNotify(self, @"showCansOrFacility", nil)
}

@end
