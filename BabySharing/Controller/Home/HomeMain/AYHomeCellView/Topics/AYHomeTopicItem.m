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
	
	titleLabel = [Tools creatUILabelWithText:@"Service" andTextColor:[UIColor white] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	titleLabel.numberOfLines = 2;
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(self).offset(0);
		make.height.mas_equalTo(40);
	}];
	
	themeLabel = [Tools creatUILabelWithText:@"Theme" andTextColor:[UIColor theme] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//	[Tools setViewBorder:themeLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[UIColor theme] andBackground:nil];
	[self addSubview:themeLabel];
	[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.bottom.equalTo(self).offset(-15);
	}];
	
}

#pragma mark - actions
- (void)didLikeBtnClick:(UIButton*)btn {
	
}

- (void)setItemInfo:(NSDictionary*)itemInfo {
	
	NSString *title = [itemInfo objectForKey:@"title"];
	if (title.length != 0) {
		titleLabel.text = title;
	}
}


@end
