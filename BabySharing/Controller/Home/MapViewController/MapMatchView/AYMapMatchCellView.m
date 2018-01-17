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
	
	UIImageView *coverImage;
	UILabel *descLabel;
	UILabel *tagLabel;
	
	UIImageView *positionSignView;
	UILabel *addrLabel;
	UILabel *distanceLabel;
	
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
	bgView.backgroundColor = [UIColor white];
//	[Tools setViewBorder:bgView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:bgView];
	[bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 20, 5, 20));
		make.edges.equalTo(self);
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
	
	coverImage = [[UIImageView alloc]init];
	coverImage.image = IMGRESOURCE(@"default_image");
	coverImage.contentMode = UIViewContentModeScaleAspectFill;
	coverImage.clipsToBounds = YES;
	[Tools setViewBorder:coverImage withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:coverImage];
	[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(bgView).offset(15);
		make.left.equalTo(bgView).offset(15);
		make.size.mas_equalTo(CGSizeMake(117, 72));
	}];
	
	tagLabel = [Tools creatLabelWithText:@"TAG" textColor:[Tools garyColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:tagLabel];
	[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(coverImage.mas_right).offset(15);
		make.top.equalTo(coverImage);
	}];
	
	descLabel = [Tools creatLabelWithText:@"Service description" textColor:[Tools RGB89GaryColor] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	descLabel.numberOfLines = 2;
	[self addSubview:descLabel];
	[descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tagLabel.mas_bottom).offset(8);
		make.left.equalTo(tagLabel);
		make.right.equalTo(bgView).offset(-15);
	}];
	
	UIView *separView = [[UIView alloc] init];
	[self addSubview:separView];
	[separView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(coverImage);
		make.right.equalTo(descLabel);
		make.top.equalTo(coverImage.mas_bottom).offset(15);
		make.height.mas_equalTo(0.5);
	}];
	separView.backgroundColor = [UIColor garyLine];
	
	positionSignView = [[UIImageView alloc]init];
	[self addSubview:positionSignView];
	positionSignView.image = IMGRESOURCE(@"map_icon_location_sign");
	[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(bgView).offset(15);
		make.top.equalTo(separView.mas_bottom).offset(20);
		make.size.mas_equalTo(CGSizeMake(11, 13));
	}];
	
	distanceLabel = [Tools creatLabelWithText:@"00m" textColor:[Tools RGB127GaryColor] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
	[self addSubview:distanceLabel];
	
	addrLabel = [Tools creatLabelWithText:@"服务妈妈的主题服务" textColor:[Tools RGB127GaryColor] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	addrLabel.numberOfLines = 1;
	[self addSubview:addrLabel];
	[addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(positionSignView.mas_right).offset(4);
		make.centerY.equalTo(positionSignView);
		make.right.equalTo(bgView).offset(-15);
	}];
	
}

- (void)setService_info:(NSDictionary *)service_info {
	
	_service_info = [service_info objectForKey:kAYServiceArgsInfo];
	
	NSString *addressStr = [_service_info objectForKey:kAYServiceArgsAddress];
	if (addressStr.length != 0) {
//		addressStr = [addressStr substringToIndex:3];
		addrLabel.text = addressStr;
	}
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *prefix = cmd.route;
	NSString* photo_name = [_service_info objectForKey:kAYServiceArgsImage];
	NSString *urlStr = [NSString stringWithFormat:@"%@%@", prefix, photo_name];
	[coverImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMGRESOURCE(@"default_image") /*options:SDWebImageRefreshCached*/];
	
	NSString *type = [_service_info objectForKey:kAYServiceArgsType];
	tagLabel.text = type;
	
	NSString *desc = [_service_info objectForKey:kAYServiceArgsPunchline];
	descLabel.text = desc;
	
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
