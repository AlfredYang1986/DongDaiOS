//
//  AYSetPriceInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 11/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetPriceInputView.h"

@implementation AYSetPriceInputView {
	
	UIView *sepLine;
}

- (instancetype)initWithSign:(NSString *)sign {
	if (self = [super init]) {
		
		_inputField = [[UITextField alloc] init];
		_inputField.placeholder = @"请输入";
		_inputField.textColor = [Tools themeColor];
		_inputField.font = [UIFont boldSystemFontOfSize:24.f];
		_inputField.textAlignment = NSTextAlignmentCenter;
		_inputField.keyboardType = UIKeyboardTypeNumberPad;
		[self addSubview:_inputField];
		[_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.mas_centerY).offset(-5);
			make.centerX.equalTo(self);
			make.width.equalTo(self);
		}];
		
		sepLine = [[UIView alloc] init];
		sepLine.backgroundColor = [Tools RGB225GaryColor];
		[self addSubview:sepLine];
		[sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
			make.width.equalTo(self);
			make.height.mas_equalTo(1);
		}];
		
		UILabel *signLabel = [Tools creatUILabelWithText:sign andTextColor:[Tools blackColor] andFontSize:315 andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:signLabel];
		[signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self.mas_centerY).offset(5);
		}];
	}
	return self;
}

- (void)setIsHideSep:(BOOL)isHideSep {
	_isHideSep = isHideSep;
	sepLine.hidden = isHideSep;
}

@end
