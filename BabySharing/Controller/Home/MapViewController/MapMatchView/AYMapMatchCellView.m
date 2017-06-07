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
	
	UIImageView *userPhoto;
	UILabel *titleLabel;
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
	
	CGFloat photowidth = 30.f;
	userPhoto = [[UIImageView alloc]init];
	userPhoto.image = IMGRESOURCE(@"default_user");
	userPhoto.contentMode = UIViewContentModeScaleAspectFill;
	[Tools setViewBorder:userPhoto withRadius:photowidth*0.5 andBorderWidth:2.f andBorderColor:[Tools borderAlphaColor] andBackground:nil];
	[self addSubview:userPhoto];
	[userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(bgView).offset(10);
		make.top.equalTo(bgView).offset(10);
		make.size.mas_equalTo(CGSizeMake(photowidth, photowidth));
	}];
//	photoIcon.userInteractionEnabled = YES;
//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
	
	titleLabel = [Tools creatUILabelWithText:@"服务妈妈的主题服务" andTextColor:[Tools blackColor] andFontSize:317.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(userPhoto.mas_right).offset(6);
		make.centerY.equalTo(userPhoto);
		make.right.equalTo(bgView).offset(-15);
	}];
	
	coverImage = [[UIImageView alloc]init];
	coverImage.image = IMGRESOURCE(@"default_image");
	coverImage.contentMode = UIViewContentModeScaleAspectFill;
	coverImage.clipsToBounds = YES;
	[Tools setViewBorder:coverImage withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:coverImage];
	[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(bgView).offset(-10);
		make.left.equalTo(userPhoto);
		make.size.mas_equalTo(CGSizeMake(125, 89));
	}];
	
	descLabel = [Tools creatUILabelWithText:@"Service description" andTextColor:[Tools garyColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
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

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (void)setService_info:(NSDictionary *)service_info {
	_service_info = service_info;
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	
	NSString* photo_name = [[service_info objectForKey:@"images"] objectAtIndex:0];
	[coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, photo_name]]
					  placeholderImage:IMGRESOURCE(@"default_image")];
	
	NSString *screen_photo = [service_info objectForKey:kAYServiceArgsScreenPhoto];
	[userPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, screen_photo]]
					 placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	NSString *unitCat;
	NSNumber *leastTimesOrHours;
	if (service_cat.intValue == ServiceTypeNursery) {
		unitCat = @"小时";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastHours];
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		unitCat = @"次";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastTimes];
	} else {
		unitCat = @"单价";
		leastTimesOrHours = @1;
	}
	
	
	NSString *addressStr = [service_info objectForKey:kAYServiceArgsAddress];
	NSString *adjstAddrStr = [service_info objectForKey:kAYServiceArgsAdjustAddress];
	titleLabel.text = [NSString stringWithFormat:@"%@%@", addressStr, adjstAddrStr];
	
//	NSString *descStr = [service_info objectForKey:kAYServiceArgsDescription];
	NSString *titleStr = [service_info objectForKey:kAYServiceArgsTitle];
	descLabel.text = titleStr;
	
	NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%@", price];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
}

- (NSString *)ableDateStringWithTM:(NSDictionary*)dic_tm andTimeInterval:(NSTimeInterval)interval {
//	NSNumber *stratNumb = [dic_tm objectForKey:kAYServiceArgsStartHours];
//	NSNumber *endNumb = [dic_tm objectForKey:kAYServiceArgsEndHours];
//	NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
//	[timesStr insertString:@":" atIndex:2];
//	[timesStr insertString:@":" atIndex:8];
	
	NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:interval];
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
	NSString *dateStrPer = [formatter stringFromDate:ableDate];
	return dateStrPer;
//	return [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
	
}

//- (void)setServiceData:(NSArray *)serviceData {
//	_serviceData = serviceData;
//}

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
