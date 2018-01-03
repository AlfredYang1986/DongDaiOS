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
		
		label = [UILabel creatLabelWithText:@"title" textColor:[UIColor black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
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
	
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
	
	NSDictionary *age_boundary = [info_detail objectForKey:kAYServiceArgsAgeBoundary];
	NSNumber *usl = ((NSNumber *)[age_boundary objectForKey:kAYServiceArgsAgeBoundaryUp]);
	NSNumber *lsl = ((NSNumber *)[age_boundary objectForKey:kAYServiceArgsAgeBoundaryLow]);
	NSString *ages = [NSString stringWithFormat:@"%d-%d岁",lsl.intValue,usl.intValue];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:ages];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontMedium(22.f)} range:NSMakeRange(0, ages.length - 1)];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} range:NSMakeRange(ages.length - 1, 1)];
	infoLabel.attributedText = attributedText;
	
	NSNumber *capacity = [info_detail objectForKey:kAYServiceArgsCapacity];
	infoLabel.text = [NSString stringWithFormat:@"%d",capacity.intValue == 0 ? 1 : capacity.intValue];
	
	NSString *servantCat = @"服务者数量";
	NSDictionary *info_categ = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *service_cat = [info_categ objectForKey:kAYServiceArgsCat];
	if ([service_cat isEqualToString:kAYStringCourse]) {
		servantCat = @"老师数量";
	}
	infoLabel.text = servantCat;
	
	NSNumber *servant = [info_detail objectForKey:kAYServiceArgsServantNumb];
	infoLabel.text = [NSString stringWithFormat:@"%d", servant.intValue == 0 ? 1 : servant.intValue];
}

@end
