//
//  AYServTimesBtn.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServTimesBtn.h"

#define itemWidth				((SCREEN_WIDTH - 15) / 7)
#define AdjustFiltVertical				7
#define itemUintHeight  					34

@implementation AYServTimesBtn {
	UILabel *topTitle;
	UILabel *btmtitle;
	
	UIView *normalBg;
	UIView *selectedBg;
}

- (instancetype)initWithOffsetX:(CGFloat)offsetX andTimesDic:(NSDictionary*)args {
	self = [super init];
	if (self) {
		
		NSNumber *top = [args objectForKey:kAYServiceArgsStart];
		NSNumber *btm = [args objectForKey:kAYServiceArgsEnd];
		
		CGFloat offsetY = itemUintHeight * (top.intValue / 100 - 6);
		CGFloat height =  itemUintHeight * (btm.intValue / 100 - top.intValue / 100);
		self.frame = CGRectMake(offsetX + 15, offsetY + AdjustFiltVertical, itemWidth, height);
		
		normalBg = [[UIView alloc]init];
		[Tools creatCALayerWithFrame:CGRectMake(0, 0, itemWidth, height) andColor:[Tools garyBackgroundColor] inSuperView:normalBg];
		[Tools creatCALayerWithFrame:CGRectMake(0, 0, itemWidth, 3) andColor:[Tools themeColor] inSuperView:normalBg];
		[self addSubview:normalBg];
		[normalBg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		
		selectedBg = [[UIView alloc]init];
		[Tools creatCALayerWithFrame:CGRectMake(0, 0, itemWidth, height) andColor:[Tools themeColor] inSuperView:selectedBg];
		[self addSubview:selectedBg];
		[selectedBg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		
		// init status
		selectedBg.hidden = YES;
		normalBg.hidden = NO;
		selectedBg.userInteractionEnabled = normalBg.userInteractionEnabled = NO;
		
		NSMutableString *tmp = [NSMutableString stringWithFormat:@"%@", top];
		[tmp insertString:@":" atIndex:2];
		
		topTitle = [Tools creatUILabelWithText:[tmp stringByAppendingString:@"开始"] andTextColor:[Tools themeColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:topTitle];
		[topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(3);
			make.left.equalTo(self).offset(2);
		}];
		
		tmp = [NSMutableString stringWithFormat:@"%@", btm];
		[tmp insertString:@":" atIndex:2];
		
		btmtitle = [Tools creatUILabelWithText:[tmp stringByAppendingString:@"结束"] andTextColor:[Tools themeColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:btmtitle];
		[btmtitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.left.equalTo(topTitle);
		}];
		
	}
	
	return self;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		
		topTitle.textColor = btmtitle.textColor = [Tools whiteColor];
		selectedBg.hidden = NO;
		normalBg.hidden = YES;
	} else {
		
		topTitle.textColor = btmtitle.textColor = [Tools themeColor];
		selectedBg.hidden = YES;
		normalBg.hidden = NO;
	}
}

@end
