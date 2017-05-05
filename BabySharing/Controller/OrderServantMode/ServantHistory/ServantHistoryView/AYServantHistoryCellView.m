//
//  AYServantHistoryCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServantHistoryCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYServantHistoryCellView {
	
	UIImageView *userPhotoView;
	UILabel *userNameLabel;
	UILabel *serviceTitleLabel;
	UILabel *statesLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor whiteColor];
		
		CGFloat imageWidth = 45.f;
		CGFloat margin = 10.f;
//		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		userPhotoView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"default_user")];
		[Tools setViewBorder:userPhotoView withRadius:imageWidth * 0.5 andBorderWidth:2.f andBorderColor:[Tools borderAlphaColor] andBackground:nil];
		[self addSubview:userPhotoView];
		[userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self).offset(-10);
			make.left.equalTo(self).offset(20);
			make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
		}];
		
		userNameLabel = [Tools creatUILabelWithText:@"User Name" andTextColor:[Tools blackColor] andFontSize:616.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:userNameLabel];
		[userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userPhotoView.mas_right).offset(20);
			make.bottom.equalTo(userPhotoView.mas_centerY);
		}];
		
		UILabel *startTitleLabel = [Tools creatUILabelWithText:@"申请预定" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:startTitleLabel];
		[startTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userNameLabel.mas_right).offset(5);
			make.centerY.equalTo(userNameLabel);
		}];
		
		serviceTitleLabel = [Tools creatUILabelWithText:@"The service's title" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
		[self addSubview:serviceTitleLabel];
		[serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(userPhotoView.mas_centerY);
			make.left.equalTo(userNameLabel);
		}];
		
		statesLabel = [Tools creatUILabelWithText:@"申请状态" andTextColor:[Tools blackColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:statesLabel];
		[statesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(serviceTitleLabel.mas_bottom).offset(3);
			make.left.equalTo(userNameLabel);
		}];
		
		UIView *lineView = [UIView new];
		lineView.backgroundColor = [Tools garyLineColor];
		[self addSubview:lineView];
		[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - margin * 2, 0.5));
		}];
		
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
	id<AYViewBase> cell = VIEW(@"ServantHistoryCell", @"ServantHistoryCell");
	
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
	
//	NSDictionary *order_info = (NSDictionary*)args;
//	
//	NSString *photo_name = [order_info objectForKey:@"screen_photo"];
//	if (photo_name) {
//		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//		NSString *pre = cmd.route;
//		[userPhotoView sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
//					 placeholderImage:IMGRESOURCE(@"default_user")];
//	}
//	
//	NSString *titleStr = [NSString stringWithFormat:@"%@ · %@", [order_info objectForKey:@"screen_name"], [[order_info objectForKey:@"service"] objectForKey:@"title"]];
//	if (titleStr && ![titleStr isEqualToString:@""]) {
//		serviceTitleLabel.text = titleStr;
//	}
//	
//	statesLabel.textColor = [Tools garyColor];
//	statesLabel.text = @"待处理";
	
	return nil;
}

@end
