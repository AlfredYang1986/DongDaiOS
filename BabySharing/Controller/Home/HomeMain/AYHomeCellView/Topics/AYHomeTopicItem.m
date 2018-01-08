//
//  AYHomeTopicItem.m
//  BabySharing
//
//  Created by Alfred Yang on 12/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeTopicItem.h"

@implementation AYHomeTopicItem {
	
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
	self.layer.shadowOffset = CGSizeMake(0, 3);
	self.layer.shadowRadius = 3.f;
	self.layer.shadowOpacity = 0.5f;
	self.layer.cornerRadius = 3.f;
	
//	UIView *radiusView = [[UIView alloc] init];
//	[Tools setViewBorder:radiusView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[UIColor white]];
//	[self addSubview:radiusView];
//	[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self);
//	}];
	
	_coverImage = [[UIImageView alloc] init];
	_coverImage.image = IMGRESOURCE(@"default_image");
	_coverImage.contentMode = UIViewContentModeScaleAspectFill;
	[_coverImage setRadius:4 borderWidth:0 borderColor:nil background:nil];
	[self addSubview:_coverImage];
	[_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.top.equalTo(self);
//		make.left.equalTo(self);
//		make.width.equalTo(self);
//		make.height.mas_equalTo(116);
		make.edges.equalTo(self);
	}];
	
	titleLabel = [UILabel creatLabelWithText:@"Service" textColor:[UIColor white] fontSize:624.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
//	titleLabel.backgroundColor = [UIColor colorWithRED:83 GREEN:102 BLUE:119 ALPHA:1];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
		make.centerY.equalTo(self.mas_top).offset(57);
//		make.height.mas_equalTo(40);
//		make.width.mas_equalTo(124);
	}];
	
	themeLabel = [UILabel creatLabelWithText:@"Theme" textColor:[UIColor white] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	themeLabel.numberOfLines = 2;
//	[Tools setViewBorder:themeLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[UIColor theme] andBackground:nil];
	[self addSubview:themeLabel];
	[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
		make.top.equalTo(titleLabel.mas_bottom).offset(18);
	}];
	
}

#pragma mark - actions
- (void)didLikeBtnClick:(UIButton*)btn {
	
}

- (void)setItemInfo:(NSDictionary*)itemInfo {
	
	NSString *title = [itemInfo objectForKey:@"title"];
	titleLabel.text = title;
	
	NSString *title_sub = [itemInfo objectForKey:@"title_sub"];
	themeLabel.text = title_sub;
	
	NSString *imgName = [itemInfo objectForKey:@"img"];
	_coverImage.image = IMGRESOURCE(imgName);
}


@end
