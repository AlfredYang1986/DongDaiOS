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
	/*{
		images =     ();
		description = "\U6559\U4f1a\U5b69\U5b50\U5982";
		"owner_id" = 89027dfbb4147bf3083ccdb2f21c9956;
		"service_id" = 5b83b4c12ab63f98446c09cfb0eb7fac;
		title = 89027dfbb4147bf3083ccdb2f21c9956;
		category =     {
			 concert = "\U82ad\U857e";
			 "service_cat" = "\U8bfe\U7a0b";
		};
		detail =     {
			"age_boundary" =         {
				lsl = 2;
				usl = 11;
			};
			price = 31800;
		};
		location =     {
			address = "\U671d\U9633\U533a\U5de6\U5bb6\U5e84\U5317\U91cc58\U53f7\U5929\U8679\U5546\U573a2\U5c42";
			adjust = "";
			pin =         {
				latitude = 0;
				longitude = 0;
			};
		};
	}*/
	
	NSArray *images = [service_info objectForKey:kAYServiceArgsImages];
	NSString* photo_name ;
	if (images.count != 0) {
		photo_name = [images objectAtIndex:0];
	}
	NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, photo_name];
	[coverImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMGRESOURCE(@"default_image") /*options:SDWebImageRefreshCached*/];
	
	NSDictionary *info_cat = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *service_cat = [info_cat objectForKey:kAYServiceArgsCat];
	NSString *ownerName = [service_info objectForKey:kAYProfileArgsScreenName];
	NSString *compName = [info_cat objectForKey:kAYServiceArgsConcert];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", ownerName, compName, service_cat];
	if(compName && ![compName isEqualToString:@""]) {
		themeLabel.text = compName;
	}
	
	NSString *unitCat = @"UNIT";
	if ([service_cat isEqualToString:kAYStringNursery]) {
		unitCat = @"小时";
	}
	else if ([service_cat isEqualToString:kAYStringCourse]) {
		unitCat = @"次";
	} else {
		NSLog(@"---null---");
	}
	
	/*
	detail =     {
		"age_boundary" =         {
			lsl = 2;
			usl = 11;
		};
		price = 31800;
	};
	*/
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
	NSDictionary *age_boundary = [info_detail objectForKey:kAYServiceArgsAgeBoundary];
	NSNumber *low = [age_boundary objectForKey:kAYServiceArgsAgeBoundaryLow];
	NSNumber *up = [age_boundary objectForKey:kAYServiceArgsAgeBoundaryUp];
	ageBoundaryLabel.text = [NSString stringWithFormat:@"%@-%@岁", low, up];
	
	
	
	NSNumber *price = [info_detail objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%.f", price.intValue * 0.01];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", tmp, unitCat];
	
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
	
	NSDictionary *info_location = [service_info objectForKey:kAYServiceArgsLocationInfo];
	NSString *addressStr = [info_location objectForKey:kAYServiceArgsAddress];
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
