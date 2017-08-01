//
//  AYOrderListPendingCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 18/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderListPendingCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOrderListPendingCellView {
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *orderNoLabel;
//	UILabel *paymentInfoLabel;
//	UILabel *stateLabel;
	UILabel *userNameLabel;
	
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		//		[Tools creatCALayerWithFrame:CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		CGFloat photoImageWidth = 45.f;
		
		photoIcon = [[UIImageView alloc]init];
		photoIcon.image = IMGRESOURCE(@"default_user");
		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
		photoIcon.layer.cornerRadius = photoImageWidth * 0.5;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 2.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(photoImageWidth, photoImageWidth));
		}];
		//	photoIcon.userInteractionEnabled = YES;
		//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		titleLabel = [Tools creatUILabelWithText:@"Servant's Service With Theme" andTextColor:[Tools blackColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(photoIcon.mas_right).offset(20);
			make.centerY.equalTo(photoIcon);
		}];
		
		userNameLabel = [Tools creatUILabelWithText:@"Order NO:" andTextColor:[Tools blackColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:userNameLabel];
		[userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.bottom.equalTo(titleLabel.mas_top).offset(-3);
		}];
		
		orderNoLabel = [Tools creatUILabelWithText:@"Order NO:" andTextColor:[Tools blackColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:orderNoLabel];
		[orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(3);
		}];
		
		[Tools addBtmLineWithMargin:10.f andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:self];
		
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
	id<AYViewBase> cell = VIEW(@"OrderListPendingCell", @"OrderListPendingCell");
	
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
- (id)setCellInfo:(id)args {
//	{
//		address = "Beijing Haidian Driving School Registration Office (Dongsheng Student Accommodation Unit Southwest)";
//		cans = "-1";
//		"cans_cat" = 0;
//		end = 1494637200000;
//		"order_id" = 5ec0d0e954acebfecbc617eab87d08c8;
//		"order_thumbs" = "EAC8BAE9-46FB-4054-94E0-70B32E2C82E1";
//		"order_title" = "Sunfei' Service";
//		owner =     {
//			"screen_name" = Singer;
//			"screen_photo" = "A25F3F2C-9619-484D-8EB6-B7B187BA4F9A";
//		};
//		reserve1 = "";
//		"service_cat" = 1;
//		"service_id" = 4b99af39a03c518f794f4f1ff799f66c;
//		start = 1494633600000;
//		user =     {
//			"screen_name" = "\U827e\U4f26\U4e36\U7c73\U4fee\U65af";
//			"screen_photo" = "3B958915-E9D8-4D36-B995-A98C907EFEA0";
//		};
//	}
	
	NSDictionary *order_info = (NSDictionary*)args;
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	
	NSString *photo_name = [[order_info objectForKey:@"user"] objectForKey:@"screen_photo"];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, photo_name]]
				 placeholderImage:IMGRESOURCE(@"default_user")];
	
	
	NSString *orderID = [order_info objectForKey:kAYOrderArgsID];
	orderID = [Tools Bit64String:orderID];
	orderNoLabel.text = [NSString stringWithFormat:@"订单号 %@", orderID];
	
	NSString *userName = [[order_info objectForKey:@"user"] objectForKey:kAYProfileArgsScreenName];
	userNameLabel.text = userName;
	
	NSString *orderTitle = [order_info objectForKey:kAYOrderArgsTitle];
	titleLabel.text = orderTitle;
	
	return nil;
}

@end
