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
		make.bottom.equalTo(self).offset(-130);
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
	
	tagLabel = [UILabel creatLabelWithText:@"*TAG" textColor:[UIColor tag] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:tagLabel];
	[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_coverImage.mas_bottom).offset(10);
		make.left.equalTo(_coverImage);
//		make.left.equalTo(addrlabel.mas_right).offset(5);
//		make.centerY.equalTo(addrlabel);
	}];
	
	titleLabel = [UILabel creatLabelWithText:@"Service title" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 2;
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tagLabel.mas_bottom).offset(5);
		make.left.equalTo(_coverImage);
		make.right.equalTo(_coverImage);
	}];
	
	addrlabel = [UILabel creatLabelWithText:@"Address s" textColor:[UIColor gary] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
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
	
	NSString *photoName = [_itemInfo objectForKey:kAYServiceArgsImage];
	if (photoName) {
		[_coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, photoName]] placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
	
	NSString *district = [_itemInfo objectForKey:kAYServiceArgsAddress];
	district = [district substringToIndex:3];
	addrlabel.text = district;
	
	NSString *tag = [[_itemInfo objectForKey:kAYServiceArgsTags] firstObject];
	if (tag.length == 0) {
		tag = @"没有标签";
	}
	tagLabel.text = [@"·" stringByAppendingString:tag];
	
	NSString *brand_name = [_itemInfo objectForKey:kAYBrandArgsName];
	NSString *operation = [[_itemInfo objectForKey:kAYServiceArgsOperation] firstObject];
	NSString *leaf = [_itemInfo objectForKey:kAYServiceArgsLeaf];
	if (![leaf hasSuffix:@"看顾"]) {
		leaf = [leaf stringByAppendingString:@"课程"];
	}
	
	titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", brand_name, operation, leaf];
}

@end
