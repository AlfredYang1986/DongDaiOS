//
//  AYServiceCategOptView.m
//  BabySharing
//
//  Created by Alfred Yang on 14/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServiceCategOptView.h"

@implementation AYServiceCategOptView {
	UILabel *titleLabel;
	UILabel *subTitleLabel;
}

- (instancetype)initWithTitle:(NSString*)titleStr {
	if (self = [super init]) {
		
		[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeColor]];
		
		titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools whiteColor] andFontSize:617 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
		}];
		
		UIImageView *accessView = [[UIImageView alloc] init];
		accessView.image = [UIImage imageNamed:@"icon_arrow_back"];
		accessView.transform = CGAffineTransformMakeRotation(M_PI);
		[self addSubview:accessView];
		[accessView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-13);
			make.size.mas_equalTo(CGSizeMake(13, 13));
		}];
		
		subTitleLabel = [Tools creatUILabelWithText:@"Sub" andTextColor:[Tools whiteColor] andFontSize:315 andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(accessView.mas_left).offset(-5);
		}];
		subTitleLabel.hidden = YES;
		
	}
	return self;
}

- (void)setSubArgs:(NSString *)subArgs {
	if (subArgs) {
		subTitleLabel.hidden = NO;
		subTitleLabel.text = subArgs;
	} else {
		subTitleLabel.text = @"Sub";
		subTitleLabel.hidden = YES;
	}
}

@end
