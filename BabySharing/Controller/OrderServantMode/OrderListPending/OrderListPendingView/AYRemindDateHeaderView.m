//
//  AYRemindDateHeaderView.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYRemindDateHeaderView.h"

@implementation AYRemindDateHeaderView {
	UILabel *dateLabel;
	UILabel *hoursLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
		
//		self.backgroundView.backgroundColor = [Tools whiteColor];
		self.contentView.backgroundColor = [Tools whiteColor];
		
		dateLabel = [Tools creatUILabelWithText:@"2017-01-01" andTextColor:[Tools blackColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
		}];

		hoursLabel =  [Tools creatUILabelWithText:@"00:00-00:00" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:hoursLabel];
		[hoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-20);
		}];
		
		[Tools creatCALayerWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH - 10*2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
	}
	return self;
}


- (void)setCellInfo:(NSDictionary *)cellInfo {
	_cellInfo = cellInfo;
	
	NSDictionary *order_date = [cellInfo objectForKey:@"order_date"];
	NSTimeInterval start = ((NSNumber*)[order_date objectForKey:@"start"]).longValue;
	NSTimeInterval end = ((NSNumber*)[order_date objectForKey:@"end"]).longValue;
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start * 0.001];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end * 0.001];
	
	NSDateFormatter *formatterDay = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日"];
	NSString *dayStr = [formatterDay stringFromDate:startDate];
	
	NSDateFormatter *formatterTime = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSString *startStr = [formatterTime stringFromDate:startDate];
	NSString *endStr = [formatterTime stringFromDate:endDate];
	
	dateLabel.text = dayStr;
	hoursLabel.text = [NSString stringWithFormat:@"%@ - %@", startStr, endStr];
	
}


@end
