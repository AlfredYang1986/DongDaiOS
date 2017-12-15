//
//  AYHomeMoreItem.m
//  BabySharing
//
//  Created by Alfred Yang on 13/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeMoreItem.h"

@implementation AYHomeMoreItem {
	UILabel *skipCountLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	UIImageView *bg = [[UIImageView alloc] init];
	bg.image = IMGRESOURCE(@"tag_text");
	[bg setRadius:4 borderWidth:0 borderColor:nil background:nil];
	[self addSubview:bg];
	[bg mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 15));
		make.left.equalTo(self).offset(0);
		make.right.equalTo(self).offset(-15);
		make.top.equalTo(self);
		make.bottom.equalTo(self).offset(-80);
	}];
	
	UILabel *allLabel = [UILabel creatLabelWithText:@"Brows All" textColor:[UIColor white] fontSize:614 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:allLabel];
	[allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(bg);
		make.bottom.equalTo(bg.mas_centerY).offset(-5);
		
	}];
	
	skipCountLabel = [UILabel creatLabelWithText:@"001" textColor:[UIColor white] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:skipCountLabel];
	[skipCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(bg);
		make.top.equalTo(bg.mas_centerY).offset(1);
	}];
	
	
}


- (void)setItemInfo:(id)itemInfo {
	
}

@end
