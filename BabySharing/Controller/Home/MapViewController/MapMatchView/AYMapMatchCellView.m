//
//  AYMapMatchCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapMatchCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"
#import "AYPServsCellView.h"

@implementation AYMapMatchCellView {
	
//	UIImageView *userPhoto;
	UIImageView *positionSignView;
	UILabel *titleLabel;
	UILabel *distanceLabel;
	UILabel *priceLabel;
	
	UIImageView *coverImage;
	UILabel *descLabel;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
//	UIImageView *bgView= [[UIImageView alloc]init];
//	UIImage *bgImg = IMGRESOURCE(@"map_match_bg");
//	bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 100, 10, 10) resizingMode:UIImageResizingModeStretch];
//	bgView.image = bgImg;
//	[self addSubview:bgView];
//	[bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
//	}];
	
	UIView *bgView = [UIView new];
	bgView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.95f];
	[Tools setViewBorder:bgView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:bgView];
	[bgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 20, 5, 20));
	}];
	
//	UIView *shadowView = [[UIView alloc] init];
//	shadowView.backgroundColor = [UIColor whiteColor];
//	shadowView.layer.cornerRadius = 4.f;
//	shadowView.layer.shadowColor = [Tools garyColor].CGColor;//shadowColor阴影颜色
//	shadowView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
//	shadowView.layer.shadowOpacity = 0.45f;//阴影透明度，默认0
//	shadowView.layer.shadowRadius = 3;//阴影半径，默认3
//	[self addSubview:shadowView];
//	[shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(bgView);
//	}];
//	[self sendSubviewToBack:shadowView];
	
	positionSignView = [[UIImageView alloc]init];
	[self addSubview:positionSignView];
	positionSignView.image = IMGRESOURCE(@"home_icon_location_theme");
	[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(bgView).offset(10);
		make.top.equalTo(bgView).offset(18);
		make.size.mas_equalTo(CGSizeMake(10, 12));
	}];
	
	distanceLabel = [Tools creatUILabelWithText:@"00m" andTextColor:[Tools RGB127GaryColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
	[self addSubview:distanceLabel];
	
	titleLabel = [Tools creatUILabelWithText:@"服务妈妈的主题服务" andTextColor:[Tools RGB127GaryColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(positionSignView.mas_right).offset(6);
		make.centerY.equalTo(positionSignView);
		make.right.equalTo(distanceLabel.mas_left).offset(-10);
	}];
	
	coverImage = [[UIImageView alloc]init];
	coverImage.image = IMGRESOURCE(@"default_image");
	coverImage.contentMode = UIViewContentModeScaleAspectFill;
	coverImage.clipsToBounds = YES;
	[Tools setViewBorder:coverImage withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:coverImage];
	[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(bgView).offset(-10);
		make.left.equalTo(positionSignView);
		make.size.mas_equalTo(CGSizeMake(125, 89));
	}];
	
	descLabel = [Tools creatUILabelWithText:@"Service description" andTextColor:[Tools RGB89GaryColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	descLabel.numberOfLines = 3;
	[self addSubview:descLabel];
	[descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(coverImage.mas_right).offset(10);
		make.right.equalTo(bgView).offset(-15);
		make.top.equalTo(coverImage);
	}];
	
	priceLabel = [Tools creatUILabelWithText:@"¥Price/Unit" andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:priceLabel];
	[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(bgView).offset(-15);
		make.bottom.equalTo(coverImage);
	}];
	
}

- (void)setService_info:(NSDictionary *)service_info {
	_service_info = [service_info objectForKey:kAYServiceArgsInfo];
	
	NSDictionary *info_location = [_service_info objectForKey:kAYServiceArgsLocationInfo];
	CLLocation *location_self = [service_info objectForKey:@"location_self"];
	NSNumber *lat = [[info_location objectForKey:kAYServiceArgsPin] objectForKey:kAYServiceArgsLatitude];
	NSNumber *lon = [[info_location objectForKey:kAYServiceArgsPin] objectForKey:kAYServiceArgsLongtitude];
	
	CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
	CLLocationDistance meters = [location_self distanceFromLocation:pinLocation];
	distanceLabel.text = [NSString stringWithFormat:@"%.lfm", meters];
	[distanceLabel sizeToFit];
	[distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(-35);
		make.centerY.equalTo(positionSignView);
//		make.width.mas_equalTo(distanceLabel.bounds.size.width);
		make.width.mas_equalTo(0);
	}];
	
	NSString *addressStr = [info_location objectForKey:kAYServiceArgsAddress];
//	NSString *adjstAddrStr = [info_location objectForKey:kAYServiceArgsAdjustAddress];
	if (addressStr && ![addressStr isEqualToString:@""]) {
		NSString *stringPre = @"中国北京市";
		if ([addressStr hasPrefix:stringPre]) {
			addressStr = [addressStr stringByReplacingOccurrencesOfString:stringPre withString:@""];
		}
//		titleLabel.text = [NSString stringWithFormat:@"%@%@", addressStr, adjstAddrStr];
		titleLabel.text = addressStr;
		[titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(positionSignView.mas_right).offset(6);
			make.centerY.equalTo(positionSignView);
			make.right.equalTo(distanceLabel.mas_left).offset(-10);
		}];
	}
	
	NSString* photo_name = [_service_info objectForKey:kAYServiceArgsImages];
	NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, photo_name];
	[coverImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMGRESOURCE(@"default_image") /*options:SDWebImageRefreshCached*/];
	
	NSDictionary *info_cat = [_service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *service_cat = [info_cat objectForKey:kAYServiceArgsCat];
	NSString *unitCat = @"UNIT";
	NSString *nameStr = [[_service_info objectForKey:@"owner"] objectForKey:kAYProfileArgsScreenName];
	if ([service_cat containsString:@"看"]) {
		unitCat = @"小时";
		
		NSString *compName = [info_cat objectForKey:kAYServiceArgsCatSecondary];
		descLabel.text = [NSString stringWithFormat:@"%@的%@", nameStr, compName];

	}
	else if ([service_cat isEqualToString:kAYStringCourse]) {
		unitCat = @"次";
		
		NSString *compName = [info_cat objectForKey:kAYServiceArgsConcert];
		if (!compName || [compName isEqualToString:@""]) {
			compName = [info_cat objectForKey:kAYServiceArgsCatThirdly];
			if (!compName || [compName isEqualToString:@""]) {
				compName = [info_cat objectForKey:kAYServiceArgsCatSecondary];
			}
		}
		descLabel.text = [NSString stringWithFormat:@"%@的%@%@", nameStr, compName, service_cat];

	} else {
		NSLog(@"---null---");
	}
	
	NSDictionary *info_detail = [_service_info objectForKey:kAYServiceArgsDetailInfo];
	NSNumber *price = [info_detail objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%.f", price.intValue * 0.01];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", tmp, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
}

- (NSString *)ableDateStringWithTM:(NSDictionary*)dic_tm andTimeInterval:(NSTimeInterval)interval {
	
	NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:interval];
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
	NSString *dateStrPer = [formatter stringFromDate:ableDate];
	return dateStrPer;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"MapMatchCell", @"MapMatchCell");
	
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

#pragma mark -- actions


#pragma mark -- messages
- (id)setCellInfo:(NSArray*)dic_args {
//	_serviceData = dic_args;
	
	return nil;
}

#pragma mark -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return _serviceData.count;
	return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *indentfier = @"AYPServsCellView";
	AYPServsCellView *cell  = [tableView dequeueReusableCellWithIdentifier:indentfier];
	
	NSDictionary *tmp = [[NSDictionary alloc]init];
	cell.service_info = tmp;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	_didTouchUpInSubCell = ^(NSDictionary* service_info){
//		
//	};
	NSDictionary *tmp;
	_didTouchUpInSubCell(tmp);
}

@end
