//
//  AYHomeAroundNoAuthCell.m
//  BabySharing
//
//  Created by Alfred Yang on 27/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeAroundNoAuthCell.h"

@implementation AYHomeAroundNoAuthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		UIImageView *noAuthSign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"near_none_location"]];
		[self addSubview:noAuthSign];
		[noAuthSign mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self).offset(128);
			make.size.mas_equalTo(CGSizeMake(75, 73));
		}];
		
		NSString *tipStr = @"请在iPhone的\"设置-隐私-定位\"中\n允许-咚哒-定位服务";
		UILabel *tipLabel = [Tools creatUILabelWithText:tipStr andTextColor:[Tools RGB153GaryColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:tipLabel];
		[tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(noAuthSign.mas_bottom).offset(12);
		}];
		
	}
	return self;
}

@end
