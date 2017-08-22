//
//  AYHomeSortDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeSortDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

@implementation AYHomeSortDelegate {
	NSArray *sectionTitleArr;
	NSArray *nurseryArr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	sectionTitleArr = @[@"看顾", @"课程"];
	nurseryArr = @[@"日间看顾", @"课后看顾"];
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (id)changeQueryData:(id)args {
	
	return nil;
}

#pragma mark -- table
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 2;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYViewBase> cell;
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeSortCourseCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	cell = [tableView dequeueReusableCellWithIdentifier:class_name];
//	if (indexPath.section == 0) {
//		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeSortNurseryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//		cell = [tableView dequeueReusableCellWithIdentifier:class_name];
//	} else {
//	}
	
	cell.controller = self.controller;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
//		(count/2 + (count%2 == 0 ? 0 : 1)) * (96+15) + 10 + 20
		return 10 + 6 * (96+15) + 20;
	} else {
		return 120.f;
	}
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [UIView new];
	headView.backgroundColor = [Tools whiteColor];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:[sectionTitleArr objectAtIndex:0] andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.top.equalTo(headView).offset(20);
	}];
	
	CGFloat margin = 20.f;
	
	UIView *dailyBgView = [[UIView alloc] init];
	dailyBgView.backgroundColor = [Tools whiteColor];
	[Tools setShadowOfView:dailyBgView withViewRadius:4.f andColor:[Tools colorWithRED:240 GREEN:176 BLUE:58 ALPHA:1.f] andOffset:CGSizeMake(0, 3) andOpacity:0.3f andShadowRadius:3.f];
	[headView addSubview:dailyBgView];
	[dailyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(margin);
		make.top.equalTo(titleLabel.mas_bottom).offset(20);
		make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - margin*2 - 15)/2, 95));
	}];
	
	UIImageView *nurseryDailySignView = [[UIImageView alloc] init];
	nurseryDailySignView.tag = 0;
	nurseryDailySignView.image = IMGRESOURCE(@"home_sort_nursary_daily");
	[Tools setViewBorder:nurseryDailySignView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[headView addSubview:nurseryDailySignView];
	[nurseryDailySignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(dailyBgView);
	}];
	
	UIView *afterclassBgView = [[UIView alloc] init];
	afterclassBgView.backgroundColor = [Tools whiteColor];
	[Tools setShadowOfView:afterclassBgView withViewRadius:4.f andColor:[Tools colorWithRED:78 GREEN:128 BLUE:238 ALPHA:1.f] andOffset:CGSizeMake(0, 3) andOpacity:0.3f andShadowRadius:3.f];
	[headView addSubview:afterclassBgView];
	[afterclassBgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(headView).offset(-margin);
		make.top.equalTo(dailyBgView);
		make.size.equalTo(nurseryDailySignView);
	}];
	
	UIImageView *nurseryAfterClassSignView = [[UIImageView alloc] init];
	nurseryAfterClassSignView.tag = 1;
	[Tools setViewBorder:nurseryAfterClassSignView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	nurseryAfterClassSignView.image = IMGRESOURCE(@"home_sort_nursary_afterclass");
	[headView addSubview:nurseryAfterClassSignView];
	[nurseryAfterClassSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(afterclassBgView);
	}];
	
	nurseryDailySignView.userInteractionEnabled = nurseryAfterClassSignView.userInteractionEnabled = YES;
	[nurseryDailySignView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didNursarySignTap:)]];
	[nurseryAfterClassSignView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didNursarySignTap:)]];
	
	UILabel *titleLabel2 = [Tools creatUILabelWithText:[sectionTitleArr objectAtIndex:1] andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel2];
	[titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.top.equalTo(dailyBgView.mas_bottom).offset(30);
	}];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	if (section == 0) {
//	} else
//		return 48.f;
	return 230.f;
}

#pragma mark -- actions
- (void)didNursarySignTap:(UITapGestureRecognizer*)tap {
	UIView *tapView = tap.view;
//	NSNumber *tag = [NSNumber numberWithInteger:tapView.tag];
	NSString *tmp = [nurseryArr objectAtIndex:tapView.tag];
	kAYDelegateSendNotify(self, @"didNursarySortTapAtIndex:", &tmp)
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGPoint offset = scrollView.contentOffset;
	if (offset.y <= 0) {
		offset.y = 0;
		scrollView.contentOffset = offset;
	}
	
//	NSNumber *offset_y = [NSNumber numberWithFloat:scrollView.contentOffset.y];
//	kAYDelegateSendNotify(self, @"scrollOffsetYNoyify:", &offset_y)
}

@end
