//
//  AYAssortmentItemView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentItemView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYAssortmentItemView {
	
	UIImageView *coverImage;
	UIButton *likeBtn;
	
	UILabel *themeLabel;
	UILabel *ageBoundaryLabel;
	
	UILabel *titleLabel;
	
	UIImageView *positionSignView;
	UILabel *addressLabel;
	UILabel *priceLabel;
	
	NSDictionary *service_info;
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
	
	[Tools setViewBorder:self withRadius:4.f andBorderWidth:0.5 andBorderColor:[Tools RGB225GaryColor] andBackground:nil];
	
	coverImage = [[UIImageView alloc]init];
	coverImage.image = IMGRESOURCE(@"default_image");
	coverImage.contentMode = UIViewContentModeScaleAspectFill;
	coverImage.clipsToBounds = YES;
	[self addSubview:coverImage];
	[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
		make.width.equalTo(self);
		make.height.mas_equalTo(116);
	}];
	
	
	titleLabel = [Tools creatUILabelWithText:@"Service Belong to Servant" andTextColor:[Tools blackColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 2;
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(10);
		make.right.equalTo(self).offset(-10);
		make.top.equalTo(coverImage.mas_bottom).offset(5);
	}];
	
	positionSignView = [[UIImageView alloc]init];
	[self addSubview:positionSignView];
	positionSignView.image = IMGRESOURCE(@"home_icon_location");
	[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(5);
		make.size.mas_equalTo(CGSizeMake(8, 10));
	}];
	
	addressLabel = [Tools creatUILabelWithText:@"Address Info" andTextColor:[Tools RGB153GaryColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:addressLabel];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(positionSignView);
		make.left.equalTo(positionSignView.mas_right).offset(3);
	}];
	
	
	priceLabel = [Tools creatUILabelWithText:@"¥Price/Unit" andTextColor:[Tools themeColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:priceLabel];
	[priceLabel sizeToFit];
	[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(positionSignView.mas_bottom).offset(8);
	}];
	
	ageBoundaryLabel = [Tools creatUILabelWithText:@"0-0 old" andTextColor:[Tools themeColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:ageBoundaryLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:nil];
	[self addSubview:ageBoundaryLabel];
	[ageBoundaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(titleLabel);
		make.bottom.equalTo(self).offset(-10);
		make.size.mas_equalTo(CGSizeMake(48, 20));
	}];
	
	themeLabel = [Tools creatUILabelWithText:@"Theme" andTextColor:[Tools themeColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:themeLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:nil];
	[self addSubview:themeLabel];
	[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(ageBoundaryLabel.mas_left).offset(-8);
		make.centerY.equalTo(ageBoundaryLabel);
		make.size.mas_equalTo(CGSizeMake(56, 20));
	}];
	
	
//	likeBtn  = [[UIButton alloc] init];
//	[likeBtn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
//	[likeBtn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
//	[self addSubview:likeBtn];
//	[likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.right.equalTo(coverImage).offset(-10);
//		make.top.top.equalTo(coverImage).offset(10);
//		make.size.mas_equalTo(CGSizeMake(40, 40));
//	}];
//	[likeBtn addTarget:self action:@selector(didLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
}

-(void)setItemInfo:(NSDictionary *)args {
	
	
	
}

@end
