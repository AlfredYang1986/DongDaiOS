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

static NSString *const kSpecialKey = @"special";
static NSString *const kOpenDayKey = @"openday";

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
	NSDictionary *addSignViewDic;
	
	UITableView *specialTableView;
	UITableView *openDayTableView;
	NSDictionary *tableViewDic;
	
	NSMutableDictionary *TMS;
	NSString *handleKey;
	int updateOrAddNote;
	NSNumber *TMHandle;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	CGFloat margin = 20.f;
	
	TMS = [[NSMutableDictionary alloc] init];
	[TMS setValue:[NSMutableDictionary dictionary] forKey:kSpecialKey];
	[TMS setValue:[NSMutableDictionary dictionary] forKey:kOpenDayKey];
	handleKey = kSpecialKey;
	
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
	[openDaySwitch addTarget:self action:@selector(didOpenDaySwitchChanged) forControlEvents:UIControlEventValueChanged];
	[specialSwitch addTarget:self action:@selector(didSpecialSwitchChanged) forControlEvents:UIControlEventValueChanged];
	
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
	
//	specialSwitch.on = YES;
	specialAddSign.state = AYAddTMSignStateUnable;
	specialTableView.hidden = YES;
	
	openDayAddSign.state = AYAddTMSignStateUnable;
	openDayTableView.hidden = YES;
	
	[specialAddSign addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddSignTap:)]];
	[openDayAddSign addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddSignTap:)]];
	
	addSignViewDic = @{kSpecialKey:specialAddSign, kOpenDayKey:openDayAddSign};
	tableViewDic = @{kSpecialKey:specialTableView, kOpenDayKey:openDayTableView};
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
- (void)didAddSignTap:(UITapGestureRecognizer*)tap {
	updateOrAddNote = -1;
	kAYViewSendNotify(self, @"specialOrOpendayAddTM", nil)
}

- (void)didOpenDaySwitchChanged {
	if (openDaySwitch.on) {
		openDayAddSign.state = [[TMS objectForKey:kOpenDayKey] count] == 0 ? AYAddTMSignStateEnable : AYAddTMSignStateHead;
		openDayTableView.hidden = NO;
	} else {
		openDayAddSign.state = AYAddTMSignStateUnable;
		openDayTableView.hidden = YES;
	}
}
- (void)didSpecialSwitchChanged {
	if (specialSwitch.on) {
		specialAddSign.state = [[TMS objectForKey:kSpecialKey] count] == 0 ? AYAddTMSignStateEnable : AYAddTMSignStateHead;
		specialTableView.hidden = NO;
	} else {
		specialAddSign.state = AYAddTMSignStateUnable;
		specialTableView.hidden = YES;
	}
}

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
		handleKey = kSpecialKey;
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
		handleKey = kOpenDayKey;
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
	if (tableView == specialTableView) {
		return [[[TMS objectForKey:kSpecialKey] objectForKey:TMHandle.stringValue] count];
	} else
		return [[[TMS objectForKey:kOpenDayKey] objectForKey:TMHandle.stringValue] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* class_name = @"AYServiceTimesCellView";
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	id tmp;
	if (tableView == specialTableView) {
		tmp = [[[TMS objectForKey:kSpecialKey] objectForKey:TMHandle.stringValue] objectAtIndex:indexPath.row];
	} else
		tmp = [[[TMS objectForKey:kOpenDayKey] objectForKey:TMHandle.stringValue] objectAtIndex:indexPath.row];
	
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	updateOrAddNote = (int)indexPath.row;
	kAYViewSendNotify(self, @"specialOrOpendayAddTM", nil)
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除时间" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[[[TMS objectForKey:handleKey] objectForKey:TMHandle.stringValue] removeObjectAtIndex:indexPath.row];
		if ([[[TMS objectForKey:handleKey] objectForKey:TMHandle.stringValue] count] == 0) {
			((AYAddTimeSignView*)[addSignViewDic objectForKey:handleKey]).state = AYAddTMSignStateEnable;
		}
//		NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
//		kAYDelegateSendNotify(self, @"cellDeleteFromTable:", &row)
	}];
	
	//    rowAction.backgroundColor = [UIColor colorWithPatternImage:IMGRESOURCE(@"cell_delete")];
	rowAction.backgroundColor = [Tools themeColor];
	return @[rowAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y < 0) {
		scrollView.contentOffset = CGPointMake(0, 0);
	}
}

#pragma mark -- notifies
- (id)recodeTMHandle:(id)args {
	if (!TMHandle) {
		TMHandle = args;
		if ([handleKey isEqualToString:kSpecialKey]) {
			specialSwitch.on = YES;
			specialAddSign.state = AYAddTMSignStateEnable;
			specialTableView.hidden = NO;
			[[TMS objectForKey:handleKey] setValue:[NSMutableArray array] forKey:TMHandle.stringValue];
		}
		return nil;
	}
	
	AYTMDayState state = AYTMDayStateNormal;
	
	if ([[[TMS objectForKey:handleKey] objectForKey:TMHandle.stringValue] count] != 0) {
		if ([handleKey isEqualToString:kOpenDayKey]) {
			state = AYTMDayStateOpenDay;
			openDaySwitch.on = NO;
			openDayAddSign.state = AYAddTMSignStateUnable;
		} else {
			state = AYTMDayStateSpecial;
		}
	} else {
		[[TMS objectForKey:handleKey] removeObjectForKey:TMHandle.stringValue];
	}
	
	[[TMS objectForKey:handleKey] setValue:[NSMutableArray array] forKey:[args stringValue]];
	
	[(UITableView*)[tableViewDic objectForKey:handleKey] reloadData];
	
	TMHandle = args;
	return [NSNumber numberWithInt:state];
}

- (id)pushTMArgs:(id)args {
	NSMutableArray *timesArr = [[TMS objectForKey:handleKey] objectForKey:TMHandle.stringValue];
	NSDictionary *argsHolder = nil;
	if (updateOrAddNote == -1) { //添加
		[timesArr addObject:args];
	} else { //修改基础 1.add   2.？  3.remove/save
		argsHolder = [timesArr objectAtIndex:updateOrAddNote];
		[timesArr replaceObjectAtIndex:updateOrAddNote withObject:args];
	}
	
	[timesArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[obj1 objectForKey:kAYServiceArgsStart] intValue] > [[obj2 objectForKey:kAYServiceArgsStart] intValue];
	}];
	
	if (![self isCurrentTimesLegal]) {
		if (!argsHolder) {
			[timesArr removeObject:args];
		} else {
			NSInteger holderIndex = [timesArr indexOfObject:args];
			[timesArr replaceObjectAtIndex:holderIndex withObject:argsHolder];
		}
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	
	if (timesArr.count != 0 && ((AYAddTimeSignView*)[addSignViewDic objectForKey:handleKey]).state == AYAddTMSignStateEnable) {
		((AYAddTimeSignView*)[addSignViewDic objectForKey:handleKey]).state = AYAddTMSignStateHead;
		((UIView*)[tableViewDic objectForKey:handleKey]).hidden = NO;
	}
	[(UITableView*)[tableViewDic objectForKey:handleKey] reloadData];
	return nil;
}

- (BOOL)isCurrentTimesLegal {
	//    NSMutableArray *allTimeNotes = [NSMutableArray array];
	__block BOOL isLegal = YES;
	NSMutableArray *timesArr = [[TMS objectForKey:handleKey] objectForKey:TMHandle.stringValue];
	[timesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		NSNumber *currentEnd = [obj objectForKey:@"end"];
		
		if (idx+1 < timesArr.count) {
			NSNumber *nextStart = [[timesArr objectAtIndex:idx+1] objectForKey:@"start"];
			
			if (currentEnd.intValue > nextStart.intValue) {
				isLegal = NO;
				*stop = YES;
			}
		}
	}];
	
	return isLegal;
}
@end
