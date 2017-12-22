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


#define kTABLEMARGINTOP					(kStatusBarH+80)
#define kCollectionViewHeight			164

typedef void(^queryContentFinish)(void);

@implementation AYHomeController {
	
	NSMutableArray *serviceDataFound;
    NSInteger skipCountFound;
	NSTimeInterval timeIntervalFound;
	
	UILabel *addressLabel;
	BOOL isDargging;
	
	CLLocation *loc;
	NSDictionary *search_pin;
	
	BOOL isLocationAuth;
}

@synthesize manager = _manager;

- (CLLocationManager *)manager {
	if (!_manager) {
		_manager = [[CLLocationManager alloc] init];
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
	
	serviceDataFound = [[NSMutableArray alloc] init];
	
	UIView *HomeHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kTABLEMARGINTOP)];
	[self.view addSubview:HomeHeadView];

	UIImageView *PhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
	[HomeHeadView addSubview:PhotoView];
	[PhotoView sd_setImageWithURL:[NSURL URLWithString:[kAYDongDaDownloadURL stringByAppendingString:@""] ] placeholderImage:IMGRESOURCE(@"default_user")];
	
	UILabel *locationLabel = [Tools creatUILabelWithText:@"北京市" andTextColor:[Tools garyColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[HomeHeadView addSubview:locationLabel];
	[locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(PhotoView.mas_right).offset(10);
		make.bottom.equalTo(PhotoView).offset(-5);
	}];
	
	UIButton *collesBtn = [UIButton creatButtonWithTitle:@"My Colles" titleColor:[UIColor gary] fontSize:614 backgroundColor:nil];
	[HomeHeadView addSubview:collesBtn];
	[collesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(HomeHeadView);
		make.right.equalTo(HomeHeadView).offset(-15);
		make.size.mas_equalTo(CGSizeMake(80, 40));
	}];
	[collesBtn addTarget:self action:@selector(didCollectBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	{
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		
		id<AYDelegateBase> delegate_found = [self.delegates objectForKey:@"Home"];
		id obj = (id)delegate_found;
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
		obj = (id)delegate_found;
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
		
		NSArray *arr_cell_name = @[@"AYHomeTopicsCellView", @"AYHomeAroundCellView", @"AYHomeAssortmentCellView"];
		for (NSString *cell_name in arr_cell_name) {
			id class_name = [cell_name copy];
			kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name);
		}
		
		tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
		tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools whiteColor];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kTABLEMARGINTOP, SCREEN_WIDTH, SCREEN_HEIGHT - kTABLEMARGINTOP);
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
- (void)didCollectBtnClick {
	
	AYViewController* des = DEFAULTCONTROLLER(@"CollectServ");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
}

- (NSDictionary*)sortDataForSearchAroundWithSkiped:(NSInteger)skiped {
	
	if (!search_pin) {
		NSString *title = @"正在定位，请稍等...";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];
	
	return [dic_search copy];
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
	[dic_condt setValue:[NSNumber numberWithLongLong:[NSDate date].timeIntervalSince1970*1000] forKey:kAYCommArgsRemoteDate];
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
	[args setValue:[serviceDataFound copy] forKey:@"result_data"];
	
	[dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic_show_module];
	
	return nil;
}

- (id)willOpenMapMatch {
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
	[args setValue:[serviceDataFound copy] forKey:@"result_data"];
	
	[dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic_show_module];
	
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

- (id)didOneTopicClick:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"TopicContent");
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:args forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd_show_module = PUSH;
		[cmd_show_module performWithResult:&dic];
	});
	return nil;
}

- (id)didAssortmentMoreBtnClick {
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

- (id)didSelectAssortmentAtIndex:(id)args {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	[dic setObject:[args objectForKey:@"cover"] forKey:kAYControllerImgForFrameKey];
	[dic setValue:[args objectForKey:kAYServiceArgsSelf] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push_animate = PUSH;
	[cmd_push_animate performWithResult:&dic];
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
