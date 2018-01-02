//
//  AYHomeAssortmentCellItem.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeAssortmentItem.h"
#import "AYCommandDefines.h"

@implementation AYHomeAssortmentItem {
	
	UILabel *titleLabel;
	UILabel *addrlabel;
	UILabel *tagLabel;
	UIButton *likeBtn;
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
	
//	self.backgroundColor = [Tools randomColor];
//	self.clipsToBounds = YES;
//	[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	
	_coverImage = [[UIImageView alloc] init];
	_coverImage.contentMode = UIViewContentModeScaleAspectFill;
	_coverImage.image = IMGRESOURCE(@"default_image");
	[Tools setViewBorder:_coverImage withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:_coverImage];
	[_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self);
		make.left.equalTo(self).offset(0);
		make.right.equalTo(self);
		make.top.equalTo(self);
		make.bottom.equalTo(self).offset(-80);
	}];
	
	likeBtn  = [[UIButton alloc] init];
	[likeBtn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
	[likeBtn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
	[self addSubview:likeBtn];
	[likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_coverImage).offset(-10);
		make.top.top.equalTo(_coverImage).offset(10);
		make.size.mas_equalTo(CGSizeMake(40, 40));
	}];
	[likeBtn addTarget:self action:@selector(didLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	tagLabel = [UILabel creatLabelWithText:@"*TAG" textColor:[UIColor random] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:tagLabel];
	[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_coverImage.mas_bottom).offset(10);
		make.left.equalTo(_coverImage);
//		make.left.equalTo(addrlabel.mas_right).offset(5);
//		make.centerY.equalTo(addrlabel);
	}];
	
	titleLabel = [UILabel creatLabelWithText:@"Service title" textColor:[UIColor black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 2;
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tagLabel.mas_bottom).offset(5);
		make.left.equalTo(_coverImage);
		make.right.equalTo(_coverImage);
	}];
	
	addrlabel = [UILabel creatLabelWithText:@"Address s" textColor:[UIColor gary] fontSize:11.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:addrlabel];
	[addrlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).offset(6);
		make.left.equalTo(_coverImage);
	}];
	
}

- (void)didLikeBtnClick {
	
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
	_itemInfo = itemInfo;
	
	NSString *photoName = [_itemInfo objectForKey:kAYServiceArgsImages];
	if (photoName) {
		[_coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, photoName]] placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
//	NSString *titleStr = [_itemInfo objectForKey:kAYServiceArgsTitle];
//	titleLabel.text = titleStr;
	
	NSDictionary *info_addr = [_itemInfo objectForKey:kAYServiceArgsLocationInfo];
	NSString *district = [info_addr objectForKey:kAYServiceArgsDistrict];
	if ([district hasPrefix:@"北京市"]) {
		district = [district substringFromIndex:3];
	}
	addrlabel.text = district;
	
	NSDictionary *info_catg = [_itemInfo objectForKey:kAYServiceArgsCategoryInfo];
	NSString *tag = [info_catg objectForKey:kAYServiceArgsCourseCoustom];
	if (tag.length == 0) {
		tag = [info_catg objectForKey:kAYServiceArgsCatThirdly];
		if (tag.length == 0) {
			tag = [info_catg objectForKey:kAYServiceArgsCatSecondary];
			if (tag.length == 0) {
				tag = @"未设置主题";
			}
		}
	}
	tagLabel.text = [@"·" stringByAppendingString:tag];
	
	NSDictionary *info_owner = [_itemInfo objectForKey:@"owner"];
	NSString *screenName = [info_owner objectForKey:kAYProfileArgsScreenName];
	NSString *catg = [info_catg objectForKey:kAYServiceArgsCat];
	
	titleLabel.text = [NSString stringWithFormat:@"%@'%@%@", screenName, tag, catg];
}


@end
