//
//  AYHomeAssortmentCellItem.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeAssortmentCellItem.h"
#import "AYCommandDefines.h"

@implementation AYHomeAssortmentCellItem {
	
	UILabel *titleLabel;
	UILabel *addrlabel;
	UILabel *tagLabel;
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
		make.height.mas_equalTo(90);
	}];
	
	titleLabel = [UILabel creatLabelWithText:@"Service title" textColor:[UIColor black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_coverImage.mas_bottom).offset(10);
		make.left.equalTo(_coverImage);
	}];
	
	addrlabel = [UILabel creatLabelWithText:@"Address s" textColor:[UIColor gary] fontSize:11.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:addrlabel];
	[addrlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).offset(10);
		make.left.equalTo(_coverImage);
	}];
	
	tagLabel = [UILabel creatLabelWithText:@"*TAG" textColor:[UIColor random] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:tagLabel];
	[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(addrlabel.mas_right).offset(5);
		make.centerY.equalTo(addrlabel);
	}];
	
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
	_itemInfo = itemInfo;
	
	NSString *titleStr = [itemInfo objectForKey:@"title"];
	titleLabel.text = titleStr;
	
	NSString *img_name = [itemInfo objectForKey:@"assortment_img"];
	_coverImage.image = IMGRESOURCE(img_name);
}


@end
