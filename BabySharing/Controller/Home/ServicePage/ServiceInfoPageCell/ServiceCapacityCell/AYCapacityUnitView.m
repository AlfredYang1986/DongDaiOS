//
//  AYCapacityUnitView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYCapacityUnitView.h"

@implementation AYCapacityUnitView {
	UIImageView *icon;
	UILabel *label;
	UILabel *infoLabel;
}

- (instancetype)initWithIcon:(NSString *)name title:(NSString *)title info:(NSString *)info {
	self = [super init];
	if (self) {
		
		icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
		[self addSubview:icon];
		[icon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(23, 23));
		}];
		
		label = [UILabel creatLabelWithText:title textColor:[UIColor black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(icon.mas_bottom).offset(8);
		}];
		
		infoLabel = [UILabel creatLabelWithText:@"info" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:infoLabel];
		[infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(label.mas_bottom).offset(15);
		}];
	}
	return self;
}

- (void)info:(NSDictionary *)info atIndex:(int)index {
	
	NSDictionary *service_info = info;
	
	if (index == 1) {	//Max
		int numb = [[service_info objectForKey:@"class_max_stu"] intValue];
		NSString *stu;
		if (numb <= 0) {
			stu = @"-";
		} else
			stu = [NSString stringWithFormat:@"%d", numb];
		infoLabel.text = stu;
	}
	else if (index == 0) {	//boundary_agr
		NSNumber *min = [service_info objectForKey:@"min_age"];
		NSNumber *max = [service_info objectForKey:@"max_age"];
		
		infoLabel.text = [NSString stringWithFormat:@"%@-%@岁", min, max];
		
	} else {
		int class = [[service_info objectForKey:@"class_max_stu"] intValue];
		int teacher = [[service_info objectForKey:@"teacher_num"] intValue];
		NSString *str;
		if (class <= 0 || teacher <= 0) {
			str = @"-";
		} else {
			int ratio = class / teacher;
			str = [NSString stringWithFormat:@"1:%d", ratio];
		}
		infoLabel.text = str;
	}
	
//	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:ages];
//	[attributedText setAttributes:@{NSFontAttributeName:kAYFontMedium(22.f)} range:NSMakeRange(0, ages.length - 1)];
//	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} range:NSMakeRange(ages.length - 1, 1)];
//	infoLabel.attributedText = attributedText;
	
}

@end
