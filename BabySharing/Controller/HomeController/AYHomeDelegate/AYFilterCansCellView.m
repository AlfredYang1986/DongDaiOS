//
//  AYFilterCansCatCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 31/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYFilterCansCellView.h"

@implementation AYFilterCansCellView {
	UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	titleLabel = [Tools creatUILabelWithText:@"Title" andTextColor:[Tools themeColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:titleLabel withRadius:20.f andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:nil];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self).insets(UIEdgeInsetsMake(25, 20, 25, 0));
//		make.center.equalTo(self);
		make.edges.equalTo(self);
	}];
	
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
	_itemInfo = itemInfo;
	
	NSString *title = [itemInfo objectForKey:@"title"];
	titleLabel.text = title;
	
	NSNumber *isSelected = [itemInfo objectForKey:@"is_selected"];
	[self setSelected:isSelected.boolValue];
	
}

- (void)setStatusWith:(BOOL)isSelected {
	if (isSelected) {
		titleLabel.textColor = [Tools whiteColor];
		titleLabel.backgroundColor = [Tools themeColor];
	} else {
		titleLabel.textColor = [Tools themeColor];
		titleLabel.backgroundColor = [Tools whiteColor];
	}
}

@end
