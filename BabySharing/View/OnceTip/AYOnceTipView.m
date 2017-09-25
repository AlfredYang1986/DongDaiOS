//
//  AYOnceTipView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOnceTipView.h"
#import "AYCommandDefines.h"

@implementation AYOnceTipView {
	UILabel *titleLabel;
}

- (instancetype)initWithTitle:(NSString *)title {
	self = [super init];
	if (self) {
		
		_delBtn = [[UIButton alloc] init];
		[_delBtn setImage:IMGRESOURCE(@"content_close") forState:UIControlStateNormal];
		[self addSubview:_delBtn];
		[_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.right.equalTo(self).offset(-5);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		titleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools garyColor] andFontSize:313 andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(5);
			make.centerX.equalTo(self);
			make.right.equalTo(_delBtn.mas_left).offset(-5);
		}];
		
//		[_delBtn addTarget:self action:@selector(didViewTap) forControlEvents:UIControlEventTouchUpInside];
	}
	return  self;
}

@end
