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
	UILabel *themeLabel;
	UILabel *ageBoundaryLabel;
	
	UILabel *titleLabel;
	
	UIImageView *positionSignView;
	UILabel *addressLabel;
	UILabel *priceLabel;
	
	UIButton *likeBtn;
	UIImageView *choiceSignView;
	UIImageView *hotSignView;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
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
		coverImage.layer.cornerRadius = 4.f;
		coverImage.clipsToBounds = YES;
		[self addSubview:coverImage];
		[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(10);
			make.left.equalTo(self).offset(20);
			make.right.equalTo(self).offset(-20);
			make.height.mas_equalTo(223);
		}];
		
		choiceSignView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"service_icon_choice")];
		[self addSubview:choiceSignView];
		[choiceSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(coverImage);
			make.left.equalTo(coverImage).offset(20);
			make.size.mas_equalTo(CGSizeMake(26, 40));
		}];
		
		hotSignView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"service_icon_hot")];
		[self addSubview:hotSignView];
		[hotSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(coverImage).offset(20);
			make.left.equalTo(coverImage);
			make.size.mas_equalTo(CGSizeMake(45, 26));
		}];
		
		themeLabel = [Tools creatUILabelWithText:@"Theme" andTextColor:[Tools themeColor] andFontSize:611.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:themeLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:nil];
		[self addSubview:themeLabel];
		[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(coverImage);
			make.top.equalTo(coverImage.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(72, 26));
		}];
		
		ageBoundaryLabel = [Tools creatUILabelWithText:@"0-0" andTextColor:[Tools themeColor] andFontSize:611.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:ageBoundaryLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:nil];
		[self addSubview:ageBoundaryLabel];
		[ageBoundaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(themeLabel.mas_right).offset(10);
			make.centerY.equalTo(themeLabel);
			make.size.mas_equalTo(CGSizeMake(60, 26));
		}];
		
		titleLabel = [Tools creatUILabelWithText:@"Service Belong to Servant" andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 1;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(coverImage);
			make.right.equalTo(coverImage);
			make.top.equalTo(themeLabel.mas_bottom).offset(15);
		}];
		
		positionSignView = [[UIImageView alloc]init];
		[self addSubview:positionSignView];
		positionSignView.image = IMGRESOURCE(@"home_icon_location");
		[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(10);
			make.size.mas_equalTo(CGSizeMake(10, 12));
		}];
		
		addressLabel = [Tools creatUILabelWithText:@"Address Info" andTextColor:[Tools RGB153GaryColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(positionSignView);
			make.left.equalTo(positionSignView.mas_right).offset(5);
		}];
		
		
		priceLabel = [Tools creatUILabelWithText:@"¥Price/Unit" andTextColor:[Tools themeColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:priceLabel];
//		[priceLabel sizeToFit];
//		[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.right.equalTo(coverImage);
//			make.centerY.equalTo(positionSignView);
//		}];
		
		likeBtn  = [[UIButton alloc] init];
		[likeBtn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
		[likeBtn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
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
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	[dic setValue:likeBtn forKey:@"btn"];
	[dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	
	kAYViewSendNotify(self, @"willCollectWithRow:", &dic)
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	service_info = dic_args;
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
		
	NSArray *images = [service_info objectForKey:@"images"];
	NSString* photo_name ;
	if (images.count != 0) {
		photo_name = [images objectAtIndex:0];
	}
	[coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, photo_name]]
				  placeholderImage:IMGRESOURCE(@"default_image") /*options:SDWebImageRefreshCached*/];
	
//	NSString *screen_photo = [service_info objectForKey:kAYServiceArgsScreenPhoto];
//	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:screen_photo]]
//				  placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSString *unitCat = @"UNIT";
//	NSNumber *leastTimesOrHours = @1;
	
	NSString *ownerName = [service_info objectForKey:kAYServiceArgsScreenName];
	NSString *compName = [Tools serviceCompleteNameFromSKUWith:service_info];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@", ownerName, compName];
	
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	
	if (service_cat.intValue == ServiceTypeNursery) {
		unitCat = @"小时";
		
//		NSNumber *tmp = [service_info objectForKey:kAYServiceArgsLeastHours];
//		if (![tmp isEqualToNumber:@0]) {
//			leastTimesOrHours = tmp;
//		}
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		unitCat = @"次";
		
//		NSNumber *tmp = [service_info objectForKey:kAYServiceArgsLeastTimes];
//		if (![tmp isEqualToNumber:@0]) {
//			leastTimesOrHours = tmp;
//		}
	} else {
		NSLog(@"---null---");
	}
	
	NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%@", price];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools themeColor]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools themeColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	[priceLabel sizeToFit];
	[priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(coverImage);
		make.centerY.equalTo(positionSignView);
		make.width.mas_equalTo(priceLabel.bounds.size.width);
	}];
	
	
	NSString *addressStr = [service_info objectForKey:kAYServiceArgsAddress];
	NSString *stringPre = @"中国北京市";
	if ([addressStr hasPrefix:stringPre]) {
		addressStr = [addressStr stringByReplacingOccurrencesOfString:stringPre withString:@""];
	}
	addressLabel.text = addressStr;
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(positionSignView.mas_right).offset(3);
		make.right.equalTo(priceLabel.mas_left).offset(-10);
		make.centerY.equalTo(positionSignView);
	}];
	
	NSNumber *iscollect = [service_info objectForKey:kAYServiceArgsIsCollect];
	likeBtn.selected = iscollect.boolValue;
	
	return nil;
}

@end
