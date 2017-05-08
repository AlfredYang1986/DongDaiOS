//
//  AYAppliFBTopView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderTOPView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"


@implementation AYOrderTOPView {
	UILabel *countlabel;
	
	UIImageView *userPhotoView;
	UILabel *userNameLabel;
	UILabel *serviceTitleLabel;
	UILabel *FBActionLabel;
	
	UILabel *noContentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame andMode:(OrderMode)mode {
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
			make.centerY.equalTo(self.mas_top).offset(100);
			make.left.equalTo(self).offset(20);
			make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
		}];
		
		noContentLabel = [Tools creatUILabelWithText:@"None Any Order" andTextColor:[Tools garyColor] andFontSize:15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:noContentLabel];
		[noContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userPhotoView).offset(0);
			make.centerY.equalTo(userPhotoView);
		}];
		noContentLabel.hidden = YES;
		
		userNameLabel = [Tools creatUILabelWithText:@"User Name" andTextColor:[Tools blackColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
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
		
		if (mode == OrderModeCommon) {
			UIView *lineView = [UIView new];
			lineView.backgroundColor = [Tools garyBackgroundColor];
			[self addSubview:lineView];
			[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self);
				make.bottom.equalTo(self);
				make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
			}];
		}
		else {
			[Tools addBtmLineWithMargin:10.f andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:self];
		}
		
	}
	return self;
}

- (void)setItemArgs:(id)args {
	NSArray *arr_args = args;
	if (arr_args.count == 0) {
		[self isShowContent:NO];
	}
	else if (arr_args.count >= 1) {
		
		[self isShowContent:YES];
		countlabel.text = [NSString stringWithFormat:@"%ld", arr_args.count];
		
		NSDictionary *order_info = [args lastObject];
		NSString *photo_name;
		
		NSNumber *status = [order_info objectForKey:kAYOrderArgsStatus];
		NSString *actionStr = @"FeedBack Info";
		if (status.intValue == OrderStatusPosted) {
			actionStr = @"申请预订";
		} else if (status.intValue == OrderStatusAccepted) {
			actionStr = @"已接受";
		} else if (status.intValue == OrderStatusReject) {
			actionStr = @"已拒绝";
		}
		FBActionLabel.text = actionStr;
		
		switch (status.intValue) {
			case OrderStatusPosted:
			case OrderStatusPaid:
			case OrderStatusCancel:
			{
				photo_name = [order_info objectForKey:@"screen_photo"];
				userNameLabel.text = [order_info objectForKey:kAYServiceArgsScreenName];
				serviceTitleLabel.text = [[order_info objectForKey:@"service"] objectForKey:kAYServiceArgsTitle];
			}
				break;
			case OrderStatusAccepted:
			case OrderStatusReject:
			{
				photo_name = [[order_info objectForKey:@"service"] objectForKey:kAYServiceArgsScreenPhoto];
				userNameLabel.text = [[order_info objectForKey:@"service"] objectForKey:kAYServiceArgsScreenName];
				NSString *compName = [Tools serviceCompleteNameFromSKUWith:[order_info objectForKey:@"service"]];
				serviceTitleLabel.text = [NSString stringWithFormat:@"您的%@申请", compName];
			}
				break;
			case OrderStatusExpired:
			{
				
			}
				break;
			default:
				break;
		}
		
		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
		NSString *PRE = cmd.route;
		[userPhotoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PRE, photo_name]]
						 placeholderImage:IMGRESOURCE(@"default_user")];
		
	}
}

- (void)isShowContent:(BOOL)isShow {
	userPhotoView.hidden = userNameLabel.hidden = serviceTitleLabel.hidden = FBActionLabel.hidden = !isShow;
	noContentLabel.hidden = isShow;
	countlabel.hidden = !isShow;
}

@end
