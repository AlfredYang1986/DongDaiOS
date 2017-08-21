//
//  AYHomeAroundCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeAroundCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

@implementation AYHomeAroundCellView {
	
	UIImageView *coverImage;
	UILabel *titleLabel;
	UILabel *priceLabel;
	
	UIImageView *positionSignView;
	UILabel *addressLabel;
	UILabel *distanceLabel;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		UIView *topSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
		topSepView.backgroundColor = [Tools garyBackgroundColor];
		[self addSubview:topSepView];
		
//		UIView *shadowView = [[UIView alloc] init];
//		shadowView.backgroundColor = [UIColor whiteColor];
//		shadowView.layer.cornerRadius = 4.f;
//		shadowView.layer.shadowColor = [Tools colorWithRED:43 GREEN:65 BLUE:114 ALPHA:1].CGColor;//shadowColor阴影颜色
//		shadowView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
//		shadowView.layer.shadowOpacity = 0.18f;//阴影透明度，默认0
//		shadowView.layer.shadowRadius = 4;//阴影半径，默认3
//		[self addSubview:shadowView];
//		[self sendSubviewToBack:shadowView];
//		[shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.edges.equalTo(coverImage);
//		}];
		
		coverImage = [[UIImageView alloc]init];
		coverImage.image = IMGRESOURCE(@"default_image");
		coverImage.contentMode = UIViewContentModeScaleAspectFill;
		coverImage.clipsToBounds = YES;
		[self addSubview:coverImage];
		[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(5);
			make.left.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(125, 125));
		}];
		
		
		titleLabel = [Tools creatUILabelWithText:@"Service Belong to Servant" andTextColor:[Tools blackColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 2;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.left.equalTo(coverImage.mas_right).offset(16);
			make.right.equalTo(self).offset(-15);
		}];
		
		priceLabel = [Tools creatUILabelWithText:@"Servie Price" andTextColor:[Tools blackColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:priceLabel];
		[priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(5);
		}];
		
		positionSignView = [[UIImageView alloc]init];
		[self addSubview:positionSignView];
		positionSignView.image = IMGRESOURCE(@"home_icon_location");
		[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.bottom.equalTo(self.mas_bottom).offset(-13);
			make.size.mas_equalTo(CGSizeMake(10, 12));
		}];
		
		addressLabel = [Tools creatUILabelWithText:@"Address Info" andTextColor:[Tools RGB153GaryColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		
		distanceLabel = [Tools creatUILabelWithText:@"distance" andTextColor:[Tools RGB153GaryColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:distanceLabel];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"HomeServPerCell", @"HomeServPerCell");
	
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

#pragma mark -- actions

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	service_info = [dic_args objectForKey:kAYServiceArgsInfo];
	
	NSString* photo_name = [service_info objectForKey:kAYServiceArgsImages];
	NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, photo_name];
	[coverImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMGRESOURCE(@"default_image") /*options:SDWebImageRefreshCached*/];
	
	NSDictionary *info_cat = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *service_cat = [info_cat objectForKey:kAYServiceArgsCat];
	NSDictionary *info_ower = [service_info objectForKey:@"owner"];
	NSString *ownerName = [info_ower objectForKey:kAYProfileArgsScreenName];
	NSString *compName = [info_cat objectForKey:kAYServiceArgsConcert];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", ownerName, compName, service_cat];
	
	NSString *unitCat = @"UNIT";
	if ([service_cat isEqualToString:kAYStringNursery]) {
		unitCat = @"小时";
	}
	else if ([service_cat isEqualToString:kAYStringCourse]) {
		unitCat = @"次";
	} else {
		NSLog(@"---null---");
	}
	
	
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
	
	NSNumber *price = [info_detail objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%.f", price.intValue * 0.01];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", tmp, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools themeColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools themeColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
	NSDictionary *info_location = [service_info objectForKey:kAYServiceArgsLocationInfo];
	NSString *addressStr = [info_location objectForKey:kAYServiceArgsAddress];
	NSString *stringPre = @"中国北京市";
	if ([addressStr hasPrefix:stringPre]) {
		addressStr = [addressStr stringByReplacingOccurrencesOfString:stringPre withString:@""];
	}
	addressLabel.text = addressStr;

//	CLLocation *current=[[CLLocation alloc] initWithLatitude:32.178722 longitude:119.508619];
//	CLLocation *before=[[CLLocation alloc] initWithLatitude:32.206340 longitude:119.425600];
//	CLLocationDistance meters =[current distanceFromLocation:before];
	
	NSNumber *lat = [[info_location objectForKey:kAYServiceArgsPin] objectForKey:kAYServiceArgsLatitude];
	NSNumber *lon = [[info_location objectForKey:kAYServiceArgsPin] objectForKey:kAYServiceArgsLongtitude];
	CLLocation *location_self = [dic_args objectForKey:@"location_self"];
	CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
	CLLocationDistance meters = [location_self distanceFromLocation:pinLocation];
	distanceLabel.text = [NSString stringWithFormat:@"%.lfm", meters];
	
	[distanceLabel sizeToFit];
	[distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(addressLabel);
		make.right.equalTo(self).offset(-15);
		make.width.mas_equalTo(distanceLabel.bounds.size.width);
	}];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(positionSignView.mas_right).offset(2);
		make.centerY.equalTo(positionSignView);
		make.right.equalTo(distanceLabel.mas_left).offset(-5);
	}];
	
	return nil;
}

@end
