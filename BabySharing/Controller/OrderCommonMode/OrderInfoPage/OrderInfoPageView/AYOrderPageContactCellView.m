//
//  AYOrderPageContactCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 16/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderPageContactCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOrderPageContactCellView {
	
	UILabel *titleLabel;
	UIImageView *photoIcon;
	UILabel *nameLabel;
	NSString *ones_id;
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
//		self.backgroundColor = [UIColor clearColor];
		[Tools creatCALayerWithFrame:CGRectMake(0, 109.5f, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		titleLabel = [Tools creatUILabelWithText:@"联系人" andTextColor:[Tools blackColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(10);
			make.top.equalTo(self).offset(15);
		}];
		
		photoIcon = [[UIImageView alloc]init];
		photoIcon.image = IMGRESOURCE(@"default_user");
		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
		photoIcon.layer.cornerRadius = 22.5;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 2.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(45, 45));
		}];
		//	photoIcon.userInteractionEnabled = YES;
		//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		nameLabel = [Tools creatUILabelWithText:@"服务者姓名" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:nameLabel];
		[nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(photoIcon.mas_right).offset(15);
			make.centerY.equalTo(photoIcon);
		}];
		
		UIButton *chatBtn = [[UIButton alloc]init];
		[chatBtn setImage:IMGRESOURCE(@"service_chat") forState:UIControlStateNormal];
		[self addSubview:chatBtn];
		[chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(nameLabel);
			make.right.equalTo(self).offset(-15);
			make.size.mas_equalTo(CGSizeMake(30, 30));
		}];
		[chatBtn addTarget:self action:@selector(didChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"OrderPageContactCell", @"OrderPageContactCell");
	
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
- (void)didChatBtnClick {
	
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	NSDictionary* info = nil;
	CURRENUSER(info)
	NSString *user_id = [info objectForKey:@"user_id"];
	
	NSString *order_user_id = [args objectForKey:@"user_id"];     //发单的人
	NSString *servant_owner_id = [[args objectForKey:@"service"] objectForKey:@"owner_id"];
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	
	if ([user_id isEqualToString:servant_owner_id]) {     //我发的服务 : -> 要看发单人的头像
		
		ones_id = order_user_id;
		nameLabel.text = [args objectForKey:@"screen_name"];
		[photoIcon sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:[args objectForKey:@"screen_photo"]]] placeholderImage:IMGRESOURCE(@"default_user")];
		
	} else {
		
		ones_id = servant_owner_id;
		nameLabel.text = [[args objectForKey:@"service"] objectForKey:@"screen_name"];
		[photoIcon sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:[[args objectForKey:@"service"] objectForKey:@"screen_photo"]]] placeholderImage:IMGRESOURCE(@"default_user")];
		
	}
	
	return nil;
}

@end