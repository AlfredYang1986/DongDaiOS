//
//  AYMapViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapMatchController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define kCollectionViewHeight				158

@implementation AYMapMatchController {
    
    NSDictionary *resultAndLoc;
    CLLocation *loc;
    NSArray *fiteResultData;
	
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        loc = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:kAYServiceArgsLocationInfo];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:IMGRESOURCE(@"map_icon_close") forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    [closeBtn addTarget:self action:@selector(didCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	
	id<AYDelegateBase> deleg = [self.delegates objectForKey:@"MapMatch"];
	id obj = (id)deleg;
	kAYViewsSendMessage(@"Collection", kAYTableRegisterDatasourceMessage, &obj)
	obj = (id)deleg;
	kAYViewsSendMessage(@"Collection", kAYTableRegisterDelegateMessage, &obj)
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Collection"];
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"MapMatchCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name];
	
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData];
//	
//	NSMutableDictionary *dic_pin = [[NSMutableDictionary alloc] init];
//	[dic_pin setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:kAYServiceArgsLatitude];
//	[dic_pin setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:kAYServiceArgsLongtitude];
//	[[dic_search objectForKey:kAYCommArgsCondition] setValue:dic_pin forKey:kAYServiceArgsPin];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
			[dic setValue:loc forKey:kAYServiceArgsLocationInfo];
			[dic setValue:[result objectForKey:@"services"] forKey:@"result_data"];
			
			id<AYViewBase> map = [self.views objectForKey:@"MapView"];
			id<AYCommand> cmd_map = [map.commands objectForKey:@"changeResultData:"];
			NSDictionary *dic_map = [dic mutableCopy];
			[cmd_map performWithResult:&dic_map];
			
			id tmp = [dic copy];
			kAYDelegatesSendMessage(@"MapMatch", @"changeQueryData:", &tmp)
			kAYViewsSendMessage(kAYCollectionView, kAYTableRefreshMessage, nil)
			
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)MapViewLayout:(UIView*)view {
    CGFloat margin = 0.f;
    view.frame = CGRectMake(margin, 0, SCREEN_WIDTH - 2* margin, SCREEN_HEIGHT);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)CollectionLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT - kCollectionViewHeight, SCREEN_WIDTH, kCollectionViewHeight);
	view.backgroundColor = [UIColor clearColor];
	
	((UICollectionView*)view).pagingEnabled = YES;
	return nil;
}

#pragma mark -- actions
- (void)didCloseBtnClick:(UIButton*)btn {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
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

- (id)queryTheLoc:(id)args{
    return resultAndLoc;
}

- (id)queryResultDate:(id)args{
    return resultAndLoc;
}

- (id)sendChangeOffsetMessage:(NSNumber*)index {
	
    UICollectionView *view_collection = [self.views objectForKey:@"Collection"];
	CGRect frame_org = view_collection.frame;
	
	[UIView animateWithDuration:0.25 animations:^{
		view_collection.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kCollectionViewHeight);
	} completion:^(BOOL finished) {
		
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
		[tmp setValue:index forKey:@"index"];
		[tmp setValue:[NSNumber numberWithInt:SCREEN_WIDTH] forKey:@"unit_width"];
		[tmp setValue:[NSNumber numberWithBool:NO] forKey:@"animated"];
		kAYViewsSendMessage(kAYCollectionView, @"scrollToPostion:", &tmp)
		
		[UIView animateWithDuration:0.15 animations:^{
			view_collection.frame = frame_org;
		}];
	}];
	
    return nil;
}

- (id)sendChangeAnnoMessage:(NSNumber*)index {
    id<AYViewBase> view = [self.views objectForKey:@"MapView"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeAnnoView:"];
    [cmd performWithResult:&index];
    
    return nil;
}

@end
