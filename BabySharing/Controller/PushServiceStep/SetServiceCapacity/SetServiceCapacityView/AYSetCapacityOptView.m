//
//  AYSetCapacityOptView.m
//  BabySharing
//
//  Created by Alfred Yang on 19/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetCapacityOptView.h"

@implementation AYSetCapacityOptView {
	UILabel *titleLabel;
	UILabel *subTitleLabel;
}

- (instancetype)initWithTitle:(NSString*)titleStr andSubTitle:(NSString *)subTitle andtionArgs:(NSString *)args {
	if (self = [super init]) {
		
		[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools garyBackgroundColor]];
		
		titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:617 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(15);
		}];
		
		UILabel *andtionLabel = [Tools creatUILabelWithText:args andTextColor:[Tools blackColor] andFontSize:313 andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
		[self addSubview:andtionLabel];
		[andtionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.centerY.equalTo(self);
		}];
		
		subTitleLabel = [Tools creatUILabelWithText:subTitle andTextColor:[Tools RGB225GaryColor] andFontSize:624 andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(andtionLabel.mas_left).offset(-7);
		}];
		
	}
	return self;
}


- (void)setSubTitleWithString:(NSString *)subString {
	subTitleLabel.textColor = [Tools themeColor];
	subTitleLabel.text = subString;
}


@end
