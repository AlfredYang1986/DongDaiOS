//
//  AYBOrderTimeController.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderTimeController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYSearchDefines.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@implementation AYBOrderTimeController {
	
	NSDictionary *service_info;
}

- (void)postPerform{
	
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	NSDate *now = [NSDate date];
	NSDateFormatter *form = [Tools creatDateFormatterWithString:@"MM月dd日"];
	NSString *nowStr = [form stringFromDate:now];
	
	NSTimeInterval sevenAfter = now.timeIntervalSince1970 + 86400 * 7;
	NSDate *afterDate = [NSDate dateWithTimeIntervalSince1970:sevenAfter];
	NSString *afterStr = [form stringFromDate:afterDate];
	
	NSString *title  = [NSString stringWithFormat:@"%@-%@",nowStr, afterStr];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	{
		NSDate *nowDate = [NSDate date];
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
		[calendar setTimeZone: timeZone];
		NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
		NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
		NSInteger weekdaySep = theComponents.weekday - 1;
		
		NSArray *weekdayTitle = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
		CGFloat itemWidth = (SCREEN_WIDTH - 15) / 7;
		for (int i = 0; i < weekdayTitle.count; ++i) {
			UILabel *itemLabel = [Tools creatUILabelWithText:[weekdayTitle objectAtIndex:(weekdaySep + i) % 7] andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
			[self.view addSubview:itemLabel];
			[itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(self.view.mas_top).offset(84);
				make.centerX.equalTo(self.view.mas_left).offset(15 + itemWidth*0.5 + itemWidth * i);
			}];
		}
	}
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Collection"];
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"BOrderTime"];
	id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
	
	id obj = (id)cmd_notify;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_notify;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderTimeItem"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name];
	
	id tmp = [service_info objectForKey:kAYServiceArgsOfferDate];
	kAYDelegatesSendMessage(@"BOrderTime", @"changeQueryData:", &tmp)
	
	UIButton *certainBtn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools whiteColor] andFontSize:-20.f andBackgroundColor:[Tools themeColor]];
	[self.view addSubview:certainBtn];
	[certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
	}];
	[certainBtn addTarget:self action:@selector(didCertainBtnnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage *left = IMGRESOURCE(@"content_close");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	return nil;
}

- (id)CollectionLayout:(UIView*)view {
	view.frame = CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - 49 - 5); //-5留底
	view.backgroundColor = [UIColor clearColor];
	((UICollectionView*)view).pagingEnabled = YES;
	return nil;
}

#pragma mark -- actions
- (void)didCertainBtnnClick {
	
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)sendChangeOffsetMessage:(NSNumber*)index {
	id<AYViewBase> view = [self.views objectForKey:@"ShowBoard"];
	id<AYCommand> cmd = [view.commands objectForKey:@"changeOffsetX:"];
	[cmd performWithResult:&index];
	
	return nil;
}

@end
