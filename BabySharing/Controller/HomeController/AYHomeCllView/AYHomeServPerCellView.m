//
//  AYHomeServPerCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 19/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeServPerCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

@implementation AYHomeServPerCellView {
	
	UIImageView *coverImage;
	UILabel *titleLabel;
	UIImageView *photoIcon;
	
	UILabel *priceLabel;
	UILabel *capacityLabel;
	
	UIImageView *positionImage;
	UILabel *addressLabel;
	
	UIButton *likeBtn;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		coverImage = [[UIImageView alloc]init];
		[self addSubview:coverImage];
		[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(5);
			make.left.equalTo(self).offset(20);
			make.right.equalTo(self).offset(-20);
			make.height.mas_equalTo(230);
		}];
		
		titleLabel = [Tools creatUILabelWithText:@"服务妈妈的课程" andTextColor:[Tools blackColor] andFontSize:-16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(coverImage);
			make.top.equalTo(coverImage.mas_bottom).offset(15);
		}];
		
		photoIcon = [[UIImageView alloc]init];
		photoIcon.layer.cornerRadius = 17.f;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 2.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(coverImage);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(34, 34));
		}];
		
		photoIcon.userInteractionEnabled = YES;
		[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		priceLabel = [Tools creatUILabelWithText:@"服务价格" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:priceLabel];
//		[priceLabel sizeToFit];
		[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(coverImage);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
//			make.width.mas_equalTo(priceLabel.bounds.size.width);
		}];
		
		capacityLabel = [Tools creatUILabelWithText:@"服务最少预定" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:capacityLabel];
		capacityLabel.layer.borderWidth = 0.5f;
		capacityLabel.layer.borderColor = [Tools blackColor].CGColor;
		
		positionImage = [[UIImageView alloc]init];
		[self addSubview:positionImage];
		positionImage.image = IMGRESOURCE(@"location_icon");
		[positionImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(capacityLabel.mas_right).offset(40);
			make.centerY.equalTo(capacityLabel);
			make.size.mas_equalTo(CGSizeMake(13, 13));
		}];
		
		addressLabel = [Tools creatUILabelWithText:@"场地地址" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(positionImage.mas_right).offset(8);
			make.right.lessThanOrEqualTo(self).offset(-20);
			make.centerY.equalTo(positionImage);
		}];
		
		likeBtn  = [[UIButton alloc] init];
		[likeBtn setImage:IMGRESOURCE(@"heart_unlike") forState:UIControlStateNormal];
		[likeBtn setImage:IMGRESOURCE(@"heart") forState:UIControlStateSelected];
		[self addSubview:likeBtn];
		[likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(coverImage).offset(-10);
			make.top.top.equalTo(coverImage).offset(10);
			make.size.mas_equalTo(CGSizeMake(40, 40));
		}];
		[likeBtn addTarget:self action:@selector(didLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
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
- (void)ownerIconTap:(UITapGestureRecognizer*)tap {
	
	AYViewController* des = DEFAULTCONTROLLER(@"OneProfile");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
}

- (void)didLikeBtnClick {
	NSDictionary *info = nil;
	CURRENUSER(info);
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	[dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
	[dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	
	id<AYControllerBase> controller = DEFAULTCONTROLLER(@"Home");
	if (!likeBtn.selected) {
		id<AYFacadeBase> facade = [controller.facades objectForKey:@"KidNapRemote"];
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				
				likeBtn.selected = YES;
			} else {
				
				NSString *title = @"收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	} else {
		id<AYFacadeBase> facade = [controller.facades objectForKey:@"KidNapRemote"];
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				
				likeBtn.selected = NO;
			} else {
				
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	service_info = dic_args;
	
	NSString* photo_name = [[service_info objectForKey:@"images"] objectAtIndex:0];
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	[coverImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
				  placeholderImage:IMGRESOURCE(@"default_image")];
	
	NSString *screen_photo = [service_info objectForKey:kAYServiceArgsScreenPhoto];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:screen_photo]]
				  placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSString *unitCat;
	NSNumber *leastTimesOrHours;
	
	NSString *ownerName = [service_info objectForKey:kAYServiceArgsScreenName];
	NSArray *options_title_cans;
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	NSNumber *cans_cat = [service_info objectForKey:kAYServiceArgsCourseCat];
	
	if (service_cat.intValue == ServiceTypeLookAfter) {
		unitCat = @"小时";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastHours];
		
		options_title_cans = kAY_service_options_title_lookafter;
		//服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			titleLabel.text = @"该服务主题待调整";
		} else {
			NSString *themeStr = options_title_cans[cans_cat.integerValue];
			titleLabel.text = [NSString stringWithFormat:@"%@的%@", ownerName,themeStr];
		}
		
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		unitCat = @"次";
		leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastTimes];
		
		NSString *servCatStr = @"课程";
		options_title_cans = kAY_service_options_title_course;
		NSNumber *cans = [service_info objectForKey:kAYServiceArgsCourseSign];
		//服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			titleLabel.text = @"该服务主题待调整";
		}
		else {
			
			NSString *costomStr = [service_info objectForKey:kAYServiceArgsCourseCoustom];
			if (costomStr && ![costomStr isEqualToString:@""]) {
				titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", ownerName, costomStr, servCatStr];
				
			} else {
				NSArray *courseTitleOfAll = kAY_service_course_title_ofall;
				NSArray *signTitleArr = [courseTitleOfAll objectAtIndex:cans_cat.integerValue];
				if (cans.integerValue < signTitleArr.count) {
					NSString *courseSignStr = [signTitleArr objectAtIndex:cans.integerValue];
					titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", ownerName, courseSignStr, servCatStr];
				} else {
					titleLabel.text = @"该服务主题待调整";
				}
			}//是否自定义课程标签判断end
		}
	} else {
		
		NSLog(@"---null---");
		unitCat = @"单价";
		leastTimesOrHours = @1;
		titleLabel.text = @"该服务类型待调整";
	}
	
	NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%@", price];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	[priceLabel sizeToFit];
	[priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(coverImage);
		make.top.equalTo(titleLabel.mas_bottom).offset(15);
		make.width.mas_equalTo(priceLabel.bounds.size.width);
	}];
	
	capacityLabel.text = [NSString stringWithFormat:@"最少预定%@%@", leastTimesOrHours, unitCat];
	[capacityLabel sizeToFit];
	[capacityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(priceLabel.mas_right).offset(8);
		make.centerY.equalTo(priceLabel);
		make.size.mas_equalTo(CGSizeMake(capacityLabel.bounds.size.width + 8, capacityLabel.bounds.size.height + 4));
	}];
	
	addressLabel.text = [service_info objectForKey:kAYServiceArgsAddress];
	
	NSNumber *iscollect = [service_info objectForKey:@"iscollect"];
	likeBtn.selected = iscollect.boolValue;
	
	return nil;
}

@end
