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
	
	self.backgroundColor = [UIColor clearColor];
	self.clipsToBounds = YES;
	
	imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.image = IMGRESOURCE(@"default_image");
	[Tools setViewBorder:imageView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	skipCountLabel = [Tools creatUILabelWithText:@"skip' count" andTextColor:[Tools RGB127GaryColor] andFontSize:11.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:skipCountLabel];
	[skipCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(imageView).offset(-15);
		make.centerX.equalTo(imageView);
	}];
	
}

- (void)setItemInfo:(NSDictionary*)itemInfo {
	
}

@end
