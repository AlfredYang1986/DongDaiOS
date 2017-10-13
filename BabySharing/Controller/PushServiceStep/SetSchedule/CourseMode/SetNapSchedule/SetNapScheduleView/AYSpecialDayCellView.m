//
//  AYSpecialDayCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSpecialDayCellView.h"

@implementation AYSpecialDayCellView {
	UILabel *titleLabel;
}

- (instancetype)init {
	if (self = [super init]) {
		[self initLayout];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initLayout];
	}
	return self;
}

- (void)initLayout {
	self.backgroundColor = [UIColor whiteColor];
	
	titleLabel = [Tools creatUILabelWithText:@"0" andTextColor:[Tools blackColor] andFontSize:315 andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
	}];
}

- (void)setDay:(NSInteger)day {
	titleLabel.text = [NSString stringWithFormat:@"%d", (int)day];
}

@end
