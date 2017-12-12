//
//  AYHomeTopicItem.m
//  BabySharing
//
//  Created by Alfred Yang on 12/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeTopicItem.h"

@implementation AYHomeTopicItem {
	
	UIImageView *coverImage;
	UILabel *themeLabel;
	
	UILabel *titleLabel;
	
	NSDictionary *service_info;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	self.layer.shadowColor = [UIColor gary].CGColor;
	self.layer.shadowOffset = CGSizeMake(0, 0);
	self.layer.shadowRadius = 3.f;
	self.layer.shadowOpacity = 0.5f;
	self.layer.cornerRadius = 4.f;
	
	UIView *radiusView = [[UIView alloc] init];
	[Tools setViewBorder:radiusView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[UIColor white]];
	[self addSubview:radiusView];
	[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	coverImage = [[UIImageView alloc] init];
	coverImage.image = IMGRESOURCE(@"default_image");
	coverImage.contentMode = UIViewContentModeScaleAspectFill;
	coverImage.clipsToBounds = YES;
	[radiusView addSubview:coverImage];
	[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
		make.width.equalTo(self);
		make.height.mas_equalTo(116);
	}];
	
	
	titleLabel = [Tools creatUILabelWithText:@"Service Belong to Servant" andTextColor:[UIColor black] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 2;
	[radiusView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(10);
		make.right.equalTo(self).offset(-10);
		make.top.equalTo(coverImage.mas_bottom).offset(5);
	}];
	
	
	themeLabel = [Tools creatUILabelWithText:@"Theme" andTextColor:[UIColor theme] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:themeLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[UIColor theme] andBackground:nil];
	[radiusView addSubview:themeLabel];
	[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(titleLabel.mas_left).offset(-8);
		make.centerY.equalTo(titleLabel);
		make.size.mas_equalTo(CGSizeMake(56, 20));
	}];
	
}

#pragma mark - actions
- (void)didLikeBtnClick:(UIButton*)btn {
	
}

- (void)setItemInfo:(NSDictionary*)itemInfo {
	
	service_info = itemInfo;
	
}


@end
