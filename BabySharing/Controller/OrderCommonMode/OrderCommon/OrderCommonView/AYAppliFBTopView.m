//
//  AYAppliFBTopView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAppliFBTopView.h"
#import "AYCommandDefines.h"

@implementation AYAppliFBTopView {
	UILabel *countlabel;
	
	UIImageView *userPhotoView;
	UILabel *userNameLabel;
	UILabel *serviceTitleLabel;
	UILabel *FBActionLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		NSString *titleStr = @"待确认";
		UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:625.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self.mas_top).offset(55 * 0.5);
			make.left.equalTo(self).offset(20);
		}];
		
		countlabel = [Tools creatUILabelWithText:@"9+" andTextColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:[UIColor redColor] andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:countlabel withRadius:10.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[self addSubview:countlabel];
		[countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel.mas_right).offset(5);
			make.top.equalTo(titleLabel).offset(-2);
			make.size.mas_equalTo(CGSizeMake(20, 20));
		}];
		
		CGFloat margin = 10.f;
		CGFloat imageWidth = 45.f;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 54.5f, SCREEN_WIDTH - margin*2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		userPhotoView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"default_user")];
		[Tools setViewBorder:userPhotoView withRadius:imageWidth * 0.5 andBorderWidth:2.f andBorderColor:[Tools borderAlphaColor] andBackground:nil];
		[self addSubview:userPhotoView];
		[userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self.mas_bottom).offset(-60);
			make.left.equalTo(self).offset(20);
			make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
		}];
		
		userNameLabel = [Tools creatUILabelWithText:@"User Name" andTextColor:[Tools themeColor] andFontSize:616.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:userNameLabel];
		[userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userPhotoView.mas_right).offset(20);
			make.bottom.equalTo(userPhotoView.mas_centerY);
		}];
		
		FBActionLabel = [Tools creatUILabelWithText:@"Accept OR Reject" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:FBActionLabel];
		[FBActionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userNameLabel.mas_right).offset(5);
			make.centerY.equalTo(userNameLabel);
		}];
		
		serviceTitleLabel = [Tools creatUILabelWithText:@"The service's title" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
		[self addSubview:serviceTitleLabel];
		[serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(userPhotoView.mas_centerY);
			make.left.equalTo(userNameLabel);
		}];
		
		UIView *lineView = [UIView new];
		lineView.backgroundColor = [Tools garyBackgroundColor];
		[self addSubview:lineView];
		[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
		}];
		
	}
	return self;
}

- (void)setItemArgs:(NSDictionary *)args {
	
}

@end
