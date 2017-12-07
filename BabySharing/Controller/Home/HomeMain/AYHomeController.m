//
//  AYHomeController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYHomeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYThumbsAndPushDefines.h"
#import "AYModelFacade.h"

#import "AYDongDaSegDefines.h"
#import "UICollectionViewLeftAlignedLayout.h"

#define kDongDaSegHeight				44

//#define kTABLEMARGINTOP			108.f
#define kTABLEMARGINTOP			kStatusAndNavBarH
#define kCollectionViewHeight				164

typedef void(^queryContentFinish)(void);

@implementation AYHomeController {
	
	NSMutableArray *serviceDataFound;
    NSInteger skipCountFound;
	NSTimeInterval timeIntervalFound;
	
	UILabel *addressLabel;
	CGFloat dynamicOffsetY;
	BOOL isDargging;
	
	CLLocation *loc;
	NSDictionary *search_pin;
	
	NSMutableArray *serviceDataAround;
	BOOL isLocationAuth;
	NSInteger skipCountAround;
	NSTimeInterval timeIntervalAround;

	int currentIndex;
	UILabel *tipsLabel;
}

@synthesize manager = _manager;

- (CLLocationManager *)manager {
	if (!_manager) {
		_manager = [[CLLocationManager alloc]init];
	}
	return _manager;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		
		if ([backArgs isKindOfClass:[NSString class]]) {
//			NSString *title = (NSString*)backArgs;
//			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		else if ([backArgs isKindOfClass:[NSDictionary class]]) {
			NSString *key = [backArgs objectForKey:@"key"];
			
			if ([key isEqualToString:@"is_change_collect"]) {
				id service_info = [backArgs objectForKey:@"args"];
				NSString *service_id = [service_info objectForKey:kAYServiceArgsID];
				NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
				NSArray *result = [serviceDataFound filteredArrayUsingPredicate:pre_id];
				
				if (result.count == 1) {
					NSInteger index = [serviceDataFound indexOfObject:result.firstObject];
					[serviceDataFound replaceObjectAtIndex:index withObject:service_info];
					UITableView *view_table = [self.views objectForKey:kAYTableView];
					id tmp = [serviceDataFound copy];
					kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
					[view_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index + 3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
				}
			}
		}
			
    }
}


#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	currentIndex = 1;
	dynamicOffsetY = 0.f;
	
	serviceDataFound = [[NSMutableArray alloc] init];
	timeIntervalFound = [NSDate date].timeIntervalSince1970;
	
	/**********层级调整*******/
	UIView *view_status = [self.views objectForKey:@"FakeStatusBar"];
	UIView *view_nav = [self.views objectForKey:kAYFakeNavBarView];
	UIView *view_seg = [self.views objectForKey:kAYDongDaSegVerView];
	[self.view bringSubviewToFront:view_nav];
	[self.view bringSubviewToFront:view_status];
	[self.view bringSubviewToFront:view_seg];

	
	UILabel *locationLabel = [Tools creatUILabelWithText:@"北京市" andTextColor:[Tools garyColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:locationLabel];
	[locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(view_seg).offset(10);
		make.centerY.equalTo(view_seg);
	}];
	
	{
		id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
		UITableView *tableView = (UITableView*)view_notify;
		
		tipsLabel = [Tools creatUILabelWithText:@"没有匹配的结果" andTextColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[tableView addSubview:tipsLabel];
		[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tableView).offset(420);
			make.centerX.equalTo(tableView);
		}];
		[tableView sendSubviewToBack:tipsLabel];
		
		id<AYDelegateBase> delegate_found = [self.delegates objectForKey:@"Home"];
		id obj = (id)delegate_found;
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
		obj = (id)delegate_found;
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
		
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeBannerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
		class_name = @"AYHomeTopicsCellView";
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
		class_name = @"AYHomeAssortmentCellView";
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
		class_name = @"AYHomeMoreTitleCellView";
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
		class_name = @"AYHomeCourseCellView";
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
		
		//	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
		tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	}
	{
		id<AYDelegateBase> deleg = [self.delegates objectForKey:@"MapMatch"];
		id obj = (id)deleg;
		kAYViewsSendMessage(@"Collection", kAYTableRegisterDatasourceMessage, &obj)
		obj = (id)deleg;
		kAYViewsSendMessage(@"Collection", kAYTableRegisterDelegateMessage, &obj)
		
		id<AYViewBase> view_notify = [self.views objectForKey:@"Collection"];
		id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"MapMatchCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_cell performWithResult:&class_name];
	}
	{
//		id<AYDelegateBase> delegate_around = [self.delegates objectForKey:@"HomeAround"];
//		id obj = (id)delegate_around;
//		kAYViewsSendMessage(@"Table2", kAYTableRegisterDatasourceMessage, &obj)
//		obj = (id)delegate_around;
//		kAYViewsSendMessage(@"Table2", kAYTableRegisterDelegateMessage, &obj)
//		
//		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeAroundCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//		kAYViewsSendMessage(@"Table2", kAYTableRegisterCellWithClassMessage, &class_name)
//		
//		UITableView *view_table_around = [self.views objectForKey:@"Table2"];
//		UIButton *mapBtn = [[UIButton alloc] init];
//		[mapBtn setImage:IMGRESOURCE(@"home_icon_map") forState:UIControlStateNormal];
//		[mapBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
//		[self.view addSubview:mapBtn];
//		[self.view bringSubviewToFront:mapBtn];
//		[mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.size.mas_equalTo(CGSizeMake(123, 70));	//123 70
//			make.right.equalTo(view_table_around).offset(-10);
//			make.bottom.equalTo(self.view).offset(-48);
//		}];
//		
//		view_table_around.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewAroundData)];
//		view_table_around.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAroundData)];
	}
	
	{
		id<AYDelegateBase> delegate_sort = [self.delegates objectForKey:@"HomeSort"];
		id obj = (id)delegate_sort;
		kAYViewsSendMessage(@"Table3", kAYTableRegisterDatasourceMessage, &obj)
		obj = (id)delegate_sort;
		kAYViewsSendMessage(@"Table3", kAYTableRegisterDelegateMessage, &obj)
		
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeSortNurseryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(@"Table3", kAYTableRegisterCellWithClassMessage, &class_name)
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeSortCourseCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(@"Table3", kAYTableRegisterCellWithClassMessage, &class_name)
	}
	
	
	[self loadNewData];
	[self startLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	self.tabBarController.tabBar.hidden = currentIndex == 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools whiteColor];
	
	addressLabel = [Tools creatUILabelWithText:@"北京市" andTextColor:[Tools garyColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[view addSubview:addressLabel];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(view).offset(20);
		make.centerY.equalTo(view);
	}];
//	addressLabel.userInteractionEnabled = YES;
//	[addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddressLabelTap)]];
	
	UIButton *searchBtn = [[UIButton alloc]init];
	[searchBtn setImage:IMGRESOURCE(@"icon_search") forState:UIControlStateNormal];
	[view addSubview:searchBtn];
	[searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(view);
		make.centerX.equalTo(view.mas_right).offset(-30);
		make.size.mas_equalTo(CGSizeMake(kDongDaSegHeight, kDongDaSegHeight));
	}];
	[searchBtn addTarget:self action:@selector(didSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
//	[Tools addBtmLineWithMargin:0 andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:view];
	return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kDongDaSegHeight);		//重新加入了self.view 的子view   0,0,w,h
	view.backgroundColor = [UIColor whiteColor];
	
	id<AYViewBase> seg = (id<AYViewBase>)view;
	id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
	
	NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
	[dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
	[dic_add_item_0 setValue:@"附近" forKey:kAYSegViewTitleKey];
	[cmd_add_item performWithResult:&dic_add_item_0];
	
	NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
	[dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
	[dic_add_item_1 setValue:@"发现" forKey:kAYSegViewTitleKey];
	[cmd_add_item performWithResult:&dic_add_item_1];
	
	NSMutableDictionary* dic_add_item_2 = [[NSMutableDictionary alloc]init];
	[dic_add_item_2 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
	[dic_add_item_2 setValue:@"分类" forKey:kAYSegViewTitleKey];
	[cmd_add_item performWithResult:&dic_add_item_2];
	
	NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
	[dic_user_info setValue:[NSNumber numberWithInt:1] forKey:kAYSegViewCurrentSelectKey];
	[dic_user_info setValue:[NSNumber numberWithFloat:0] forKey:kAYSegViewMarginBetweenKey];
	
	id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
	[cmd_info performWithResult:&dic_user_info];
	
	view.layer.shadowColor = [Tools garyColor].CGColor;
	view.layer.shadowOffset = CGSizeMake(0, 3.5);
	view.layer.shadowOpacity = 0.25f;
	
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kTABLEMARGINTOP, SCREEN_WIDTH, SCREEN_HEIGHT - kTABLEMARGINTOP - 49);
	return nil;
}
- (id)MapViewLayout:(UIView*)view {
	view.frame = CGRectMake(-SCREEN_WIDTH, kTABLEMARGINTOP, SCREEN_WIDTH, SCREEN_HEIGHT - kTABLEMARGINTOP - 49);
	return nil;
}
- (id)CollectionLayout:(UIView*)view {
	view.frame = CGRectMake(-SCREEN_WIDTH, SCREEN_HEIGHT - kCollectionViewHeight - kStatusBarH, SCREEN_WIDTH, kCollectionViewHeight);
	view.backgroundColor = [UIColor clearColor];
	
	((UICollectionView*)view).pagingEnabled = YES;
	return nil;
}
//- (id)Table2Layout:(UIView*)view {
//	view.frame = CGRectMake(-SCREEN_WIDTH, kTABLEMARGINTOP, SCREEN_WIDTH, SCREEN_HEIGHT - kTABLEMARGINTOP - 49);
////		((UITableView*)view).contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
//	view.backgroundColor = [Tools garyBackgroundColor];
//	return nil;
//}
- (id)Table3Layout:(UIView*)view {
	view.frame = CGRectMake(SCREEN_WIDTH, kTABLEMARGINTOP, SCREEN_WIDTH, SCREEN_HEIGHT - kTABLEMARGINTOP - 49);
	view.backgroundColor = [Tools whiteColor];
//	((UITableView*)view).contentOffset = CGPointMake(0, -20);
//	((UITableView*)view).contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
	return nil;
}

#pragma mark -- controller actions
- (id)foundBtnClick {
    
    AYViewController* des = DEFAULTCONTROLLER(@"Location");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

#pragma mark -- actions
- (void)didSearchBtnClick {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"SearchSKU");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	
}

- (NSDictionary*)sortDataForSearchAroundWithSkiped:(NSInteger)skiped {
	
	if (!search_pin) {
		NSString *title = @"正在定位，请稍等...";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];
	[dic_search setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	[dic_search setValue:[NSNumber numberWithInteger:skiped] forKey:kAYCommArgsRemoteDataSkip];
	/*condition*/
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
	if (skiped == 0) {
		[dic_condt setValue:[NSNumber numberWithLong:([NSDate date].timeIntervalSince1970)*1000] forKey:kAYCommArgsRemoteDate];
	} else
		[dic_condt setValue:[NSNumber numberWithLong:timeIntervalAround*1000] forKey:kAYCommArgsRemoteDate];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_location = [[NSMutableDictionary alloc] init];
	[dic_location setValue:[search_pin copy] forKey:kAYServiceArgsPin];
	[dic_condt setValue:[dic_location copy] forKey:kAYServiceArgsLocationInfo];
	
	[dic_search setValue:dic_condt forKey:kAYCommArgsCondition];
	
	return [dic_search copy];
}

- (void)loadNewAroundData {
	
	if (!isLocationAuth) {
		NSString *tip = @"查看附近服务需要您授权使用定位功能";
		AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
//		kAYViewsSendMessage(@"Table2", kAYTableRefreshMessage, nil)
//		[view_table.mj_header endRefreshing];
		return;
	}
	
	NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
	[args setValue:loc forKey:@"location"];
	[args setValue:[serviceDataAround copy] forKey:@"result_data"];
	kAYViewsSendMessage(kAYMapViewView, @"changeResultData:", &args)
	
	NSDictionary *dic_search = [self sortDataForSearchAroundWithSkiped:0];
	if (!dic_search) {
		return;
	}
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_search = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_search performWithResult:dic_search andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			timeIntervalAround = [[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate] longValue] * 0.001;
			serviceDataAround = [[[result objectForKey:@"result"] objectForKey:@"services"] mutableCopy];
			skipCountAround = serviceDataAround.count;			//刷新 重置计数为此次请求service数据个数
			
			NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
			[args setValue:loc forKey:@"location"];
			[args setValue:[serviceDataAround copy] forKey:@"result_data"];
			
			id tmp = [args copy];
			kAYViewsSendMessage(kAYMapViewView, @"changeResultData:", &args)
			
			if (serviceDataAround.count == 0) {
				NSString *tip = @"附近暂时没有可用服务";
				AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
			} else {
				args = [[NSMutableDictionary alloc]init];
				[args setValue:loc forKey:@"location"];
				[args setValue:[serviceDataAround copy] forKey:@"result_data"];
				tmp = [args copy];
				kAYDelegatesSendMessage(@"MapMatch", @"changeQueryData:", &tmp)
				kAYViewsSendMessage(kAYCollectionView, kAYTableRefreshMessage, nil)
			}
			
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
//		kAYViewsSendMessage(@"Table2", kAYTableRefreshMessage, nil)
//		[view_table.mj_header endRefreshing];
	}];
}

- (void)loadMoreAroundData {
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:loc forKey:@"location"];
	[tmp setValue:[NSNumber numberWithBool:isLocationAuth] forKey:@"is_auth"];
	kAYDelegatesSendMessage(@"HomeAround", @"changeLocationAuthData:", &tmp)
	UITableView *view_table = [self.views objectForKey:@"Table2"];
	if (!isLocationAuth) {
		kAYViewsSendMessage(@"Table2", kAYTableRefreshMessage, nil)
		[view_table.mj_footer endRefreshing];
		return;
	}
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_search = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_search performWithResult:[self sortDataForSearchAroundWithSkiped:skipCountAround] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			timeIntervalAround = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate]).longValue * 0.001;
			NSArray *remoteArr = [[result objectForKey:@"result"] objectForKey:@"services"];
			[serviceDataAround addObjectsFromArray:remoteArr];
			skipCountAround = serviceDataAround.count;			//加载 累加计数
			id tmp = [serviceDataAround copy];
			kAYDelegatesSendMessage(@"HomeAround", kAYDelegateChangeDataMessage, &tmp)
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		kAYViewsSendMessage(@"Table2", kAYTableRefreshMessage, nil)
		[view_table.mj_footer endRefreshing];
	}];
}

- (void)loadMoreData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];;
	[dic_search setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	[dic_search setValue:[NSNumber numberWithInteger:skipCountFound] forKey:kAYCommArgsRemoteDataSkip];
	/*condition*/
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
	[dic_condt setValue:[NSNumber numberWithLong:timeIntervalFound*1000] forKey:kAYCommArgsRemoteDate];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_search setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			
			timeIntervalFound = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate]).longValue * 0.001;
			NSArray *remoteArr = [[result objectForKey:@"result"] objectForKey:@"services"];
			if (remoteArr.count == 0) {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			} else {
				
				[serviceDataFound addObjectsFromArray:remoteArr];
				skipCountFound += serviceDataFound.count;
				
				id tmp = [serviceDataFound copy];
				kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			}
			
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
		[((UITableView*)view_table).mj_footer endRefreshing];
		
	}];
}

- (void)loadNewData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];;
	[dic_search setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	/*condition*/
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
//	[dic_condt setValue:[NSNumber numberWithLong:timeIntervalFound*1000] forKey:kAYCommArgsRemoteDate];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_search setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		
		UITableView *view_table = [self.views objectForKey:@"Table"];
		if (success) {
			
			timeIntervalFound = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate]).longValue * 0.001;
			serviceDataFound = [[[result objectForKey:@"result"] objectForKey:@"services"] mutableCopy];
			skipCountFound = serviceDataFound.count;			//刷新重置 计数为当前请求service数据个数
			tipsLabel.hidden = skipCountFound != 0;
			
			id tmp = [serviceDataFound copy];
			kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		} else {
			NSString *message = [result objectForKey:@"message"];
			if([message isEqualToString:@"token过期"]) {
				NSString *tip = @"当前用户登录实效已过期，请重新登录";
				AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
			} else
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		[view_table.mj_header endRefreshing];
		
	}];
}

#pragma mark -- notifies
- (id)willCollectWithRow:(id)args {
	
	NSString *service_id = [args objectForKey:kAYServiceArgsID];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
	NSArray *resultArr = [serviceDataFound filteredArrayUsingPredicate:pre_id];
	if (resultArr.count != 1) {
		return nil;
	}
	id service_data = resultArr.firstObject;
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:[service_data objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_collect setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic setValue:dic_collect forKey:@"collections"];
	
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] initWithDictionary:dic_collect];
	[dic setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	if (!likeBtn.selected) {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = YES;
				[resultArr.firstObject setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	} else {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = NO;
				[resultArr.firstObject setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	return nil;
}

- (id)scrollToShowHideTop:(NSNumber*)args {	//
//	if (isDargging) {
//		
//		UITableView *view_table = [self.views objectForKey:kAYTableView];
//		if (view_table.contentOffset.y > view_table.contentSize.height - view_table.frame.size.height || view_table.contentOffset.y < 0 ) {		//bouns
//			return nil;
//		}
//		
//		UIView *view_nav = [self.views objectForKey:kAYFakeNavBarView];
//		UIView *view_seg = [self.views objectForKey:kAYDongDaSegVerView];
//		
//		dynamicOffsetY = dynamicOffsetY + args.floatValue;
//		NSLog(@"%f", dynamicOffsetY);
//		if (dynamicOffsetY > 0) {
//			dynamicOffsetY = 0.f;
//		} else if (dynamicOffsetY < - 44) {
//			dynamicOffsetY = -44.f;
//		}
//		view_table.frame = CGRectMake(0, 108 + dynamicOffsetY, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 49 - dynamicOffsetY);
//		view_nav.frame = CGRectMake(0, 20 + dynamicOffsetY, SCREEN_WIDTH, 44);
//		view_seg.frame = CGRectMake(0, 64 + dynamicOffsetY, SCREEN_WIDTH, 44);
//	}
	return nil;
}

- (id)scrollViewWillBeginDrag {
	isDargging = YES;
	return nil;
}
- (id)scrollViewWillEndDrag {
	isDargging = NO;
	return nil;
}

- (id)didSelectedRow:(NSDictionary*)args {
	
	NSIndexPath *indexPath = [args objectForKey:@"indexpath"];
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	UITableViewCell *cell = [view_table cellForRowAtIndexPath:indexPath];
	
	CGFloat cellImageMinY = (SCREEN_HEIGHT - kStatusAndNavBarH - 49 - cell.bounds.size.height) * 0.5 + kStatusAndNavBarH - 10;
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[[args objectForKey:@"service_info"] objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[tmp setValue:[NSNumber numberWithFloat:cellImageMinY] forKey:@"cell_min_y"];
	
	[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];

	id<AYCommand> cmd_show_module = HOMEPUSH;
	[cmd_show_module performWithResult:&dic];
	
	return nil;
}

- (id)leftBtnSelected {
	
	return nil;
}

- (id)rightBtnSelected {
	
	if (!loc) {
		NSString *title;
		if (isLocationAuth) {
			title = @"正在定位，请稍等...";
		} else {
			title = @"查看地图需要您授权使用定位功能";
		}
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"MapMatch");
	
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
	[dic_show_module setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
	[args setValue:loc forKey:@"location"];
	[args setValue:[serviceDataAround copy] forKey:@"result_data"];
	
	[dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic_show_module];
	
	return nil;
}

- (id)segValueChanged:(id)obj {
	id<AYViewBase> seg = (id<AYViewBase>)obj;
	id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
	NSNumber* index = nil;
	[cmd performWithResult:&index];
	NSLog(@"current index %@", index);
	
	int changeIndex = index.intValue;
	if(changeIndex == currentIndex)
		return nil;
	
//	UIView *table_around = [self.views objectForKey:@"Table2"];
	UIView *view_map = [self.views objectForKey:kAYMapViewView];
	UIView *view_collect = [self.views objectForKey:kAYCollectionView];
	UIView *table_found = [self.views objectForKey:kAYTableView];
	UIView *table_sort = [self.views objectForKey:@"Table3"];
	
	CGFloat table_found_y = table_found.frame.origin.y;
	CGFloat table_found_height = table_found.bounds.size.height;
	
	if(changeIndex == 0) {
		
		if (!serviceDataAround) {
			[self loadNewAroundData];
		}
		self.tabBarController.tabBar.hidden = YES;
		[UIView animateWithDuration:0.25 animations:^{
//				table_around.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
			view_map.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height+kTabBarH);
			view_collect.frame = CGRectMake(0, view_collect.frame.origin.y, SCREEN_WIDTH, kCollectionViewHeight);
		}];
		if (currentIndex == 1) {
			[UIView animateWithDuration:0.25 animations:^{
				table_found.frame = CGRectMake(SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		} else {
			[UIView animateWithDuration:0.25 animations:^{
				table_sort.frame = CGRectMake(SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		}
		
	} else if (changeIndex == 1) {
		
		self.tabBarController.tabBar.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			table_found.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
		}];
		if (currentIndex == 0) {
			[UIView animateWithDuration:0.25 animations:^{
//				table_around.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				view_map.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				view_collect.frame = CGRectMake(-SCREEN_WIDTH, view_collect.frame.origin.y, SCREEN_WIDTH, kCollectionViewHeight);
			}];
		} else {
			[UIView animateWithDuration:0.25 animations:^{
				table_sort.frame = CGRectMake(SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		}
	} else {//change 2
		
		self.tabBarController.tabBar.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			table_sort.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
		}];
		if (currentIndex == 0) {
			[UIView animateWithDuration:0.25 animations:^{
//				table_around.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				view_map.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				view_collect.frame = CGRectMake(-SCREEN_WIDTH, view_collect.frame.origin.y, SCREEN_WIDTH, kCollectionViewHeight);
			}];
		} else {
			[UIView animateWithDuration:0.25 animations:^{
				table_found.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		}
	}
	
	currentIndex = changeIndex;
	return nil;
}

- (id)didSomeOneChoiceClick:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ChoiceContent");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didTopicsMoreBtnClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"TopicsList");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}
- (id)didAssortmentMoreBtnClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"AssortmentList");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	//	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didSelectAssortmentAtIndex:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"Assortment");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didNursarySortTapAtIndex:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"SortServiceList");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didCourseSortTapAtIndex:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"SortServiceList");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)scrollOffsetY:(NSNumber*)args {
    return nil;
}

- (void)startLocation {
	
	[self.manager requestWhenInUseAuthorization];
	self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
	self.manager.delegate = self;
	
	BOOL isEnabled = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
	if ([CLLocationManager locationServicesEnabled] && isEnabled) {
		isLocationAuth = YES;
		[self.manager startUpdatingLocation];
	} else {
		isLocationAuth = NO;
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
}

//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	loc = [locations firstObject];
	NSMutableDictionary *l = [[NSMutableDictionary alloc] init];
	[l setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:kAYServiceArgsLatitude];
	[l setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:kAYServiceArgsLongtitude];
	search_pin = [l copy];
	
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
		case kCLAuthorizationStatusAuthorizedAlways:
		case kCLAuthorizationStatusAuthorizedWhenInUse: {
			isLocationAuth = YES;
			[self.manager startUpdatingLocation];
		}
			break;
		case kCLAuthorizationStatusDenied:
		case kCLAuthorizationStatusNotDetermined:
		case kCLAuthorizationStatusRestricted: {
			NSLog(@"status:%d",status);
			isLocationAuth = NO;
			loc = nil;
			search_pin = nil;
		}
			break;
		default:
			break;
	}
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
