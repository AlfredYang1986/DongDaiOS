//
//  AYNoContentCell.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNoContentCell.h"

@implementation AYNoContentCell {
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		_descLabel = [Tools creatUILabelWithText:@"没有内容" andTextColor:[Tools garyColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:_descLabel];
		[_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.centerY.equalTo(self);
		}];
		
	}
	return self;
}

- (void)setTitleStr:(NSString *)titleStr {
	_titleStr = titleStr;
	_descLabel.text = titleStr;
}

@end
