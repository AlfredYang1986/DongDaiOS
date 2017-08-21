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
	UIImageView *imageView;
	UILabel *titleLabel;
	UILabel *skipCountLabel;
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
	self.clipsToBounds = YES;
	[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	
	imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
//	imageView.image = IMGRESOURCE(@"default_image");
	[Tools setViewBorder:imageView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	titleLabel = [Tools creatUILabelWithText:@"Assortment Title" andTextColor:[Tools whiteColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.mas_centerY).offset(10);
		make.centerX.equalTo(self);
	}];
	
	skipCountLabel = [Tools creatUILabelWithText:@"skiped' count" andTextColor:[Tools whiteColor] andFontSize:11.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:skipCountLabel];
	[skipCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_centerY).offset(15);
		make.centerX.equalTo(self);
	}];
	
}

- (void)setItemInfo:(NSDictionary*)itemInfo {
	
	NSString *titleStr = [itemInfo objectForKey:@"title"];
	titleLabel.text = titleStr;
	
	NSString *img_name = [itemInfo objectForKey:@"assortment_img"];
	imageView.image = IMGRESOURCE(img_name);
	
//	NSNumber *skipedCount = [itemInfo objectForKey:@"count_skiped"];
//	if (skipedCount) {
//		skipCountLabel.hidden = NO;
//		skipCountLabel.text = [NSString stringWithFormat:@"%@人浏览过", skipedCount];
//	} else {
//		skipCountLabel.hidden  =YES;
//	}
}

@end
