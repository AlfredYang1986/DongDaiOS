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


typedef void(^queryContentFinish)(void);

#define HEADER_MARGIN_TO_SCREEN         10.5
#define CONTENT_START_POINT             71
#define PAN_HANDLE_CHECK_POINT          10
#define BACK_TO_TOP_TIME    3.0
#define SHADOW_WIDTH 4
#define TableContentInsetTop     120
#define kFilterCollectionViewHeight 			90
#define kDongDaSegHeight				44

#define kTABLEMARGINTOP			108.f
// 减速度
#define DECELERATION 400.0

#import "UICollectionViewLeftAlignedLayout.h"

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
	
	serviceDataFound = [[NSMutableDictionary alloc] init];
	timeIntervalFound = timeIntervalAround = [NSDate date].timeIntervalSince1970;
	
	/**********层级调整*******/
	UIView *view_status = [self.views objectForKey:@"FakeStatusBar"];
	UIView *view_nav = [self.views objectForKey:kAYFakeNavBarView];
	UIView *view_seg = [self.views objectForKey:kAYDongDaSegVerView];
	[self.view bringSubviewToFront:view_nav];
	[self.view bringSubviewToFront:view_status];
	[self.view bringSubviewToFront:view_seg];

	{
		id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
		UITableView *tableView = (UITableView*)view_notify;
		
		UILabel *tipsLabel = [Tools creatUILabelWithText:@"没有匹配的结果" andTextColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[tableView addSubview:tipsLabel];
		[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tableView).offset(400);
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
		
		//	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
		tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	}
	
	{
		id<AYDelegateBase> delegate_around = [self.delegates objectForKey:@"HomeAround"];
		id obj = (id)delegate_around;
		kAYViewsSendMessage(@"Table2", kAYTableRegisterDatasourceMessage, &obj)
		obj = (id)delegate_around;
		kAYViewsSendMessage(@"Table2", kAYTableRegisterDelegateMessage, &obj)
		
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeAroundCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(@"Table2", kAYTableRegisterCellWithClassMessage, &class_name)
		
		UITableView *view_table_around = [self.views objectForKey:@"Table2"];
		UIButton *mapBtn = [[UIButton alloc] init];
		[mapBtn setImage:IMGRESOURCE(@"home_icon_map") forState:UIControlStateNormal];
//		[Tools setViewBorder:mapBtn withRadius:19.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[mapBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:mapBtn];
		[self.view bringSubviewToFront:mapBtn];
		[mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.size.mas_equalTo(CGSizeMake(123, 70));	//123 70
			make.right.equalTo(view_table_around).offset(-10);
			make.bottom.equalTo(self.view).offset(-48);
		}];
		
		view_table_around.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewAroundData)];
		view_table_around.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAroundData)];
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
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	view.backgroundColor = [Tools whiteColor];
	
	addressLabel = [Tools creatUILabelWithText:@"北京市" andTextColor:[Tools garyColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
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
	
	[Tools addBtmLineWithMargin:0 andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:view];
	return nil;
}

#import "AYDongDaSegDefines.h"
- (id)DongDaSegLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, kDongDaSegHeight);		//重新加入了self.view 的子view   0,0,w,h
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
	[dic_user_info setValue:[NSNumber numberWithFloat:40] forKey:kAYSegViewMarginBetweenKey];
	
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
- (id)Table2Layout:(UIView*)view {
	view.frame = CGRectMake(-SCREEN_WIDTH, kTABLEMARGINTOP, SCREEN_WIDTH, SCREEN_HEIGHT - kTABLEMARGINTOP - 49);
//		((UITableView*)view).contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
	view.backgroundColor = [Tools garyBackgroundColor];
	return nil;
}
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

- (NSDictionary*)sortDataForSearchAround {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];
	[dic_search setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	[dic_search setValue:[NSNumber numberWithInteger:skipCountAround] forKey:kAYCommArgsRemoteDataSkip];
	/*condition*/
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
	[dic_condt setValue:[NSNumber numberWithLong:timeIntervalAround*1000] forKey:kAYCommArgsRemoteDate];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_location = [[NSMutableDictionary alloc] init];
	[dic_location setValue:[search_pin copy] forKey:kAYServiceArgsPin];
	[dic_condt setValue:[dic_location copy] forKey:kAYServiceArgsLocationInfo];
	
	[dic_search setValue:dic_condt forKey:kAYCommArgsCondition];
	
	return [dic_search copy];
}

- (void)loadNewAroundData {
	
	NSNumber *tmp = [NSNumber numberWithBool:isLocationAuth];
	kAYDelegatesSendMessage(@"HomeAround", @"changeLocationAuthData:", &tmp)
	UITableView *view_table = [self.views objectForKey:@"Table2"];
	if (!isLocationAuth) {
		kAYViewsSendMessage(@"Table2", kAYTableRefreshMessage, nil)
		[view_table.mj_header endRefreshing];
		return;
	}
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[self sortDataForSearchAround] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			timeIntervalAround = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate]).longValue * 0.001;
			serviceDataAround = [[[result objectForKey:@"result"] objectForKey:@"services"] mutableCopy];
			skipCountAround = serviceDataAround.count;			//刷新 重置计数为此次请求service数据个数
			id tmp = [serviceDataAround copy];
			kAYDelegatesSendMessage(@"HomeAround", kAYDelegateChangeDataMessage, &tmp)
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		kAYViewsSendMessage(@"Table2", kAYTableRefreshMessage, nil)
		[view_table.mj_header endRefreshing];
	}];
}
- (void)loadMoreAroundData {
	
	NSNumber *tmp = [NSNumber numberWithBool:isLocationAuth];
	kAYDelegatesSendMessage(@"HomeAround", @"changeLocationAuthData:", &tmp)
	UITableView *view_table = [self.views objectForKey:@"Table2"];
	if (!isLocationAuth) {
		kAYViewsSendMessage(@"Table2", kAYTableRefreshMessage, nil)
		[view_table.mj_footer endRefreshing];
		return;
	}
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[self sortDataForSearchAround] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			timeIntervalAround = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate]).longValue * 0.001;
			NSArray *remoteArr = [[result objectForKey:@"result"] objectForKey:@"services"];
			[serviceDataAround addObjectsFromArray:remoteArr];
			skipCountAround = serviceDataAround.count;			//加载 累加计数
			id tmp = [serviceDataAround copy];
			kAYDelegatesSendMessage(@"HomeAround", kAYDelegateChangeDataMessage, &tmp)
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
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
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
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
	[dic_condt setValue:[NSNumber numberWithLong:timeIntervalFound*1000] forKey:kAYCommArgsRemoteDate];
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
			
			id tmp = [serviceDataFound copy];
			kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			[view_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		[view_table.mj_header endRefreshing];
		
	}];
}

#pragma mark -- notifies
- (id)willCollectWithRow:(id)args {
	
	NSString *service_id = [args objectForKey:kAYServiceArgsID];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	NSDictionary *info = nil;
	CURRENUSER(info);
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
	NSArray *resultArr = [serviceDataFound filteredArrayUsingPredicate:pre_id];
	if (resultArr.count != 1) {
		return nil;
	}
	NSMutableDictionary *dic = [info mutableCopy];
	[dic setValue:[resultArr.firstObject objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	
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

- (id)collectCompleteWithRow:(NSString*)args {
	
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, args];
	NSArray *result = [serviceDataFound filteredArrayUsingPredicate:pre_id];
	if (result.count == 1) {
		[result.firstObject setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
	}
	return nil;
}
- (id)unCollectCompleteWithRow:(NSString*)args {
	
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, args];
	NSArray *result = [serviceDataFound filteredArrayUsingPredicate:pre_id];
	if (result.count == 1) {
		[result.firstObject setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
	}
	return nil;
}

- (id)scrollToShowHideTop:(NSNumber*)args {	//
	if (isDargging) {
		
		UITableView *view_table = [self.views objectForKey:kAYTableView];
		if (view_table.contentOffset.y > view_table.contentSize.height - view_table.frame.size.height || view_table.contentOffset.y < 0 ) {		//bouns
			return nil;
		}
		
		UIView *view_nav = [self.views objectForKey:kAYFakeNavBarView];
		UIView *view_seg = [self.views objectForKey:kAYDongDaSegVerView];
		
		dynamicOffsetY = dynamicOffsetY + args.floatValue;
		NSLog(@"%f", dynamicOffsetY);
		if (dynamicOffsetY > 0) {
			dynamicOffsetY = 0.f;
		} else if (dynamicOffsetY < - 44) {
			dynamicOffsetY = -44.f;
		}
		view_table.frame = CGRectMake(0, 108 + dynamicOffsetY, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 49 - dynamicOffsetY);
		view_nav.frame = CGRectMake(0, 20 + dynamicOffsetY, SCREEN_WIDTH, 44);
		view_seg.frame = CGRectMake(0, 64 + dynamicOffsetY, SCREEN_WIDTH, 44);
	}
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
	
	CGFloat cellImageMinY = (SCREEN_HEIGHT - 64 - 44 - 49 - cell.bounds.size.height) * 0.5 + 64 + 44 - 10;
	
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
		NSString *title = @"正在定位，请稍等...";
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
	
	UIView *table_around = [self.views objectForKey:@"Table2"];
	UIView *table_found = [self.views objectForKey:kAYTableView];
	UIView *table_sort = [self.views objectForKey:@"Table3"];
	
	CGFloat table_found_y = table_found.frame.origin.y;
	CGFloat table_found_height = table_found.bounds.size.height;
	
	if(changeIndex == 0) {
		
		if (currentIndex == 1) {
			[UIView animateWithDuration:0.25 animations:^{
				table_found.frame = CGRectMake(SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				table_around.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		} else {
			[UIView animateWithDuration:0.25 animations:^{
				table_sort.frame = CGRectMake(SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				table_around.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		}
		
		if (!serviceDataAround) {
			[self loadNewAroundData];
		}
		
	} else if (changeIndex == 1) {
		
		if (currentIndex == 0) {
			[UIView animateWithDuration:0.25 animations:^{
				table_around.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				table_found.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		} else {
			[UIView animateWithDuration:0.25 animations:^{
				table_sort.frame = CGRectMake(SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				table_found.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		}
	} else {//change 2
		
		if (currentIndex == 0) {
			[UIView animateWithDuration:0.25 animations:^{
				table_around.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				table_sort.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
			}];
		} else {
			[UIView animateWithDuration:0.25 animations:^{
				table_found.frame = CGRectMake(-SCREEN_WIDTH, table_found_y, SCREEN_WIDTH, table_found_height);
				table_sort.frame = CGRectMake(0, table_found_y, SCREEN_WIDTH, table_found_height);
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
	//	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
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
	//	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didNursarySortTapAtIndex:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"Assortment");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	//	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didCourseSortTapAtIndex:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"Assortment");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	//	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)scrollOffsetY:(NSNumber*)args {
//    CGFloat offset_y = args.floatValue;
//    CGFloat offsetH = SCREEN_WIDTH + offset_y;
//
//    if (offsetH < 0) {
//        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
//        UITableView *tableView = (UITableView*)view_notify;
//        [coverImg mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(tableView);
//            make.top.equalTo(tableView).offset(-SCREEN_WIDTH + offsetH);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - offsetH, SCREEN_WIDTH - offsetH));
//        }];
//    }
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

@end
