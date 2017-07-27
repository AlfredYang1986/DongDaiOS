//
//  AYAssortmentSKUItem.m
//  BabySharing
//
//  Created by Alfred Yang on 27/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentSKUItem.h"

@implementation AYAssortmentSKUItem {
	UILabel *titleLabel;
	UIImageView *backgroundImageView;
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
	
	[Tools setViewBorder:self withRadius:self.bounds.size.height * 0.5 andBorderWidth:0 andBorderColor:nil andBackground:nil];
	
	backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_image"]];
	[self addSubview:backgroundImageView];
	[backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	titleLabel = [Tools creatUILabelWithText:@"SKU" andTextColor:[Tools whiteColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
	}];
	
}

- (void)setTitleStr:(NSString *)titleStr {
	_titleStr = titleStr;
	titleLabel.text = titleStr;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
	_backgroundImage = backgroundImage;
	backgroundImageView.image = backgroundImage;
}

@end
