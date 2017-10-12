//
//  AYAddTimeSignView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAddTimeSignView.h"

@implementation AYAddTimeSignView {
	UILabel *titleLabel;
	UIImageView *addSignView;
}

- (instancetype)initWithTitle:(NSString *)title {
	if (self = [super init]) {
		[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeLightColor]];
		
		titleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools whiteColor] andFontSize:615 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self).offset(-2);
		}];
		
		addSignView = [[UIImageView alloc] init];
		addSignView.image = [UIImage imageNamed:@"add_icon_circle_white"];
		[self addSubview:addSignView];
		[addSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-20);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(16, 16));
		}];
		
	}
	return self;
}

- (void)setHeadStatus {
//	[Tools setViewBorder:self withRadius:0 andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	self.backgroundColor = [Tools whiteColor];
	titleLabel.textColor = [Tools blackColor];
	addSignView.image = [UIImage imageNamed:@"add_icon_circle"];
}
- (void)setUnableStatus {
//	[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeLightColor]];
	self.backgroundColor = [Tools themeLightColor];
	titleLabel.textColor = [Tools whiteColor];
	addSignView.image = [UIImage imageNamed:@"add_icon_circle_white"];
}
- (void)setEnableStatus {
//	[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeColor]];
	self.backgroundColor = [Tools themeColor];
	titleLabel.textColor = [Tools whiteColor];
	addSignView.image = [UIImage imageNamed:@"add_icon_circle_white"];
}


@end
