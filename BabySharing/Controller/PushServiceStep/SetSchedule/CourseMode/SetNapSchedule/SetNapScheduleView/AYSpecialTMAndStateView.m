//
//  AYSpecialTMAndStateView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSpecialTMAndStateView.h"

#import "AYServicePriceCatBtn.h"
#import "AYAddTimeSignView.h"
#import "AYShadowRadiusView.h"

@implementation AYSpecialTMAndStateView {
	UIView *specialView;
	UIView *openDayView;
	
	AYServicePriceCatBtn *specialBtn;
	AYServicePriceCatBtn *openDayBtn;
	AYServicePriceCatBtn *handleBtn;
	
	UISwitch *specialSwitch;
	UISwitch *openDaySwitch;
	AYAddTimeSignView *specialAddSign;
	AYAddTimeSignView *openDayAddSign;
	
	UITableView *specialTableView;
	UITableView *openDayTableView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	CGFloat margin = 20.f;
	
	specialBtn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(margin, 0, (SCREEN_WIDTH-margin*2)*0.5, 38) andTitle:@"可预订日"];
	[self addSubview:specialBtn];
	[specialBtn setSelected:YES];
	handleBtn = specialBtn;
	openDayBtn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(specialBtn.bounds.size.width + margin, 0, specialBtn.bounds.size.width, 38) andTitle:@"开放日"];
	[self addSubview:openDayBtn];
	UIButton *confuseBtn = [[UIButton alloc] init];
	[confuseBtn setImage:IMGRESOURCE(@"icon_sign_confuse") forState:UIControlStateNormal];
	[self addSubview:confuseBtn];
	[confuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(openDayBtn.mas_centerX).offset(30);
		make.centerY.equalTo(openDayBtn);
		make.size.mas_equalTo(CGSizeMake(22, 22));
	}];
	[confuseBtn addTarget:self action:@selector(didConfuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[specialBtn addTarget:self action:@selector(didOptionClick:) forControlEvents:UIControlEventTouchUpInside];
	[openDayBtn addTarget:self action:@selector(didOptionClick:) forControlEvents:UIControlEventTouchUpInside];
	
	specialView = [[UIView alloc] init];
	[self addSubview:specialView];
	[specialView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.width.mas_equalTo(SCREEN_WIDTH-margin*2);
		make.bottom.equalTo(self);
		make.top.equalTo(specialBtn.mas_bottom).offset(8);
	}];
	
	AYShadowRadiusView *specialStateView = [[AYShadowRadiusView alloc] initWithRadius:4];
	[specialView addSubview:specialStateView];
	[specialStateView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(specialView);
		make.centerX.equalTo(specialView);
		make.height.mas_equalTo(46);
		make.width.equalTo(specialView);
	}];
	UILabel *specialStateTitle = [Tools creatUILabelWithText:@"服务状态" andTextColor:[Tools blackColor] andFontSize:615 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[specialStateView addSubview:specialStateTitle];
	[specialStateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(specialStateView).offset(15);
		make.centerY.equalTo(specialStateView);
	}];
	specialSwitch = [[UISwitch alloc] init];
	[specialSwitch setOnTintColor:[Tools themeColor]];
	[specialStateView addSubview:specialSwitch];
	[specialSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(specialStateView).offset(-15);
		make.centerY.equalTo(specialStateView);
	}];
	
	specialAddSign = [[AYAddTimeSignView alloc] initWithTitle:@"服务时间"];
	[specialView addSubview:specialAddSign];
	[specialAddSign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(specialStateView.mas_bottom).offset(8);
		make.centerX.equalTo(specialView);
		make.size.equalTo(specialStateView);
	}];
	
	specialTableView = [[UITableView alloc] init];
	[specialView addSubview:specialTableView];
	[specialTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(specialView);
		make.top.equalTo(specialAddSign.mas_bottom);
		make.bottom.equalTo(specialView);
		make.centerX.equalTo(specialView);
	}];
	
	/*-------------------------------------*/
	openDayView = [[UIView alloc] init];
	[self addSubview:openDayView];
	[openDayView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self).offset(SCREEN_WIDTH);
		make.width.mas_equalTo(SCREEN_WIDTH-margin*2);
		make.bottom.equalTo(self);
		make.top.equalTo(specialBtn.mas_bottom).offset(8);
	}];
	
	AYShadowRadiusView *openDayStateView = [[AYShadowRadiusView alloc] initWithRadius:4];
	[openDayView addSubview:openDayStateView];
	[openDayStateView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(openDayView);
		make.centerX.equalTo(openDayView);
		make.height.mas_equalTo(46);
		make.width.equalTo(openDayView);
	}];
	UILabel *openDayStateTitle = [Tools creatUILabelWithText:@"开放日状态" andTextColor:[Tools blackColor] andFontSize:615 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[openDayStateView addSubview:openDayStateTitle];
	[openDayStateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(openDayStateView).offset(15);
		make.centerY.equalTo(openDayStateView);
	}];
	openDaySwitch = [[UISwitch alloc] init];
	[openDaySwitch setOnTintColor:[Tools themeColor]];
	[openDayStateView addSubview:openDaySwitch];
	[openDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(openDayStateView).offset(-15);
		make.centerY.equalTo(openDayStateView);
	}];
	
	openDayAddSign = [[AYAddTimeSignView alloc] initWithTitle:@"开放日服务时间"];
	[openDayView addSubview:openDayAddSign];
	[openDayAddSign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(openDayStateView.mas_bottom).offset(8);
		make.centerX.equalTo(openDayView);
		make.size.equalTo(openDayStateView);
	}];
	
	openDayTableView = [[UITableView alloc] init];
	[openDayView addSubview:openDayTableView];
	[openDayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(openDayView);
		make.top.equalTo(openDayAddSign.mas_bottom);
		make.bottom.equalTo(openDayView);
		make.centerX.equalTo(openDayView);
	}];
	
	specialTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	specialTableView.showsVerticalScrollIndicator = NO;
	specialTableView.backgroundColor = [UIColor clearColor];
	specialTableView.delegate = self;
	specialTableView.dataSource = self;
	openDayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	openDayTableView.showsVerticalScrollIndicator = NO;
	openDayTableView.backgroundColor = [UIColor clearColor];
	openDayTableView.delegate = self;
	openDayTableView.dataSource = self;
	[specialTableView registerClass:NSClassFromString(@"AYServiceTimesCellView") forCellReuseIdentifier:@"AYServiceTimesCellView"];
	[openDayTableView registerClass:NSClassFromString(@"AYServiceTimesCellView") forCellReuseIdentifier:@"AYServiceTimesCellView"];
	
	specialAddSign.state = AYAddTMSignStateHead;
	
	openDayAddSign.state = AYAddTMSignStateEnable;
	openDayTableView.hidden = YES;
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
- (void)didConfuseBtnClick {
	
}

- (void)didOptionClick:(AYServicePriceCatBtn*)btn {
	if (handleBtn == btn) {
		return;
	}
	
	handleBtn.selected = NO;
	btn.selected = YES;
	handleBtn = btn;
	
	if (btn == specialBtn) {
		[UIView animateWithDuration:0.5 animations:^{
			[specialView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self);
			}];
			[openDayView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self).offset(SCREEN_WIDTH);
			}];
			[self layoutIfNeeded];
		}];
	} else {
		[UIView animateWithDuration:0.5 animations:^{
			[specialView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self).offset(-SCREEN_WIDTH);
			}];
			[openDayView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self).offset(0);
			}];
			[self layoutIfNeeded];
		}];
	}
	
}

#pragma mark -- table delegate database
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* class_name = @"AYServiceTimesCellView";
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	//	id tmp = [timesArr objectAtIndex:indexPath.row];
	//	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y < 0) {
		scrollView.contentOffset = CGPointMake(0, 0);
	}
}

#pragma mark -- notifies


@end
