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
// 减速度
#define DECELERATION 400.0

#import "AYFilterCansCellView.h"
#import "UICollectionViewLeftAlignedLayout.h"

@implementation AYHomeController {
    
    CATextLayer* badge;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CALayer *maskLayer;
	
    NSInteger skipCount;
	NSTimeInterval timeInterval;
	NSDictionary *search_loc;
	
	/************旧版搜索************/
	NSNumber *search_cansCat;
	NSNumber *search_servCat;
	NSMutableArray *servicesData;
	/*************************/
	
	NSMutableArray *servDataOfCourse;
	NSMutableArray *servDataOfNursery;
	int DongDaSegIndex;		// == service_type
//	NSNumber *courseSubIndex;
//	NSNumber *nurserySubIndex;
	NSMutableDictionary *subIndexData;
	NSArray *titleArr;
	
	UICollectionView *filterCollectionView;
	
	UILabel *addressLabel;
	UILabel *themeCatlabel;
	
	NSDictionary *dic_location;
	CLLocation *loc;
}



@synthesize manager = _manager;
- (CLLocationManager *)manager{
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
			if ([key isEqualToString:@"filterLocation"]) {
				addressLabel.text = [backArgs objectForKey:kAYServiceArgsAddress];
				search_loc = [backArgs objectForKey:kAYServiceArgsLocation];
				
			}
			else if ([key isEqualToString:@"filterTheme"]) {
				
				search_cansCat = [backArgs objectForKey:kAYServiceArgsTheme];
				search_servCat = [backArgs objectForKey:kAYServiceArgsServiceCat];
				
				themeCatlabel.text = [backArgs objectForKey:@"title"];
			}
			[self loadNewData];
			NSNumber *height = [NSNumber numberWithFloat:0.f];
			kAYViewsSendMessage(kAYTableView, @"scrollToPostion:", &height)
		}
			
    }
}

#pragma mark -- CollectionView delegate datasoure
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *class_name = @"AYFilterCansCellView";
	AYFilterCansCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:class_name forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	NSNumber *comp = [subIndexData objectForKey:[NSString stringWithFormat:@"%d",DongDaSegIndex]];
	[tmp setValue:[NSNumber numberWithBool:indexPath.row == comp.integerValue && comp] forKey:@"is_selected"];
	cell.itemInfo = tmp;
	
	return (UICollectionViewCell*)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat itemHeight = 40;
	if (DongDaSegIndex == ServiceTypeCourse) {
		//		NSString *title = [courseTitleArr objectAtIndex:indexPath.row];
		return CGSizeMake(80, itemHeight);
	} else {
		return CGSizeMake(106, itemHeight);
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *key_comp = [NSString stringWithFormat:@"%d", DongDaSegIndex];
	NSNumber *index_comp = [subIndexData objectForKey:key_comp];
	
	NSNumber *index = [NSNumber numberWithInteger:indexPath.row];
	
	if ([index_comp isEqualToNumber:index]) {
		[subIndexData removeObjectForKey:key_comp];
	} else
		[subIndexData setValue:index forKey:[NSString stringWithFormat:@"%d", DongDaSegIndex]];
	
	[filterCollectionView reloadData];
	[self loadNewData];
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	DongDaSegIndex = ServiceTypeCourse;
	subIndexData = [[NSMutableDictionary alloc] init];
	timeInterval = [NSDate date].timeIntervalSince1970;
	servDataOfCourse = [NSMutableArray array];
	servDataOfNursery = [NSMutableArray array];
	
	UIView *filterViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, 44)];
	filterViewBg.backgroundColor = [Tools whiteColor];
	filterViewBg.layer.shadowColor = [Tools garyColor].CGColor;
	filterViewBg.layer.shadowOffset = CGSizeMake(0, 3.5);
	filterViewBg.layer.shadowOpacity = 0.15f;
	[self.view addSubview:filterViewBg];
	
//	UIView *view_collect = [self.views objectForKey:kAYCollectionVerView];
//	[self.view bringSubviewToFront:view_collect];
	
	titleArr = kAY_service_options_title_course;
	UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
	layout.minimumInteritemSpacing = 20.f;
	layout.minimumLineSpacing = 25.f;
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108.f - 90, SCREEN_WIDTH, 90) collectionViewLayout:layout];
	filterCollectionView.backgroundColor = [UIColor whiteColor];
	filterCollectionView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:filterCollectionView];
	filterCollectionView.delegate =self;
	filterCollectionView.dataSource =self;
	filterCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
	[Tools creatCALayerWithFrame:CGRectMake(-20, 89.5, SCREEN_WIDTH*10, 0.5) andColor:[Tools garyLineColor] inSuperView:filterCollectionView];
	
	NSString *item_class_name = @"AYFilterCansCellView";
	[filterCollectionView registerClass:NSClassFromString(item_class_name) forCellWithReuseIdentifier:item_class_name];
	
	[self.view bringSubviewToFront:filterCollectionView];
	UIView *view_status = [self.views objectForKey:@"FakeStatusBar"];
	UIView *view_nav = [self.views objectForKey:kAYFakeNavBarView];
	[self.view bringSubviewToFront:filterViewBg];
	[self.view bringSubviewToFront:view_nav];
	[self.view bringSubviewToFront:view_status];
	
	UIButton *filterBtn = [[UIButton alloc]init];
	[filterBtn setImage:IMGRESOURCE(@"home_icon_filter") forState:UIControlStateNormal];
	[filterBtn setImage:IMGRESOURCE(@"home_icon_filter") forState:UIControlStateSelected];
	[filterViewBg addSubview:filterBtn];
	[filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(filterViewBg);
		make.centerX.equalTo(filterViewBg.mas_right).offset(-30);
		make.size.mas_equalTo(CGSizeMake(28, 25));
	}];
	filterBtn.selected = NO;
	[filterBtn addTarget:self action:@selector(didFilterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	UIView *segView = [self.views objectForKey:@"DongDaSeg"];
	[filterViewBg addSubview:segView];
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
	UITableView *tableView = (UITableView*)view_notify;
	
	UILabel *tipsLabel = [Tools creatUILabelWithText:@"没有匹配的结果" andTextColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[tableView addSubview:tipsLabel];
	[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tableView).offset(180);
		make.centerX.equalTo(tableView);
	}];
	[tableView sendSubviewToBack:tipsLabel];
	
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Home"];
	id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
	
	id obj = (id)cmd_notify;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_notify;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name];
	class_name = @"HomeTopTipCell";
	[cmd_cell performWithResult:&class_name];
	
	id<AYDelegateBase> delegate_collect = [self.delegates objectForKey:@"HomeCollect"];
	id dele = delegate_collect;
	kAYViewsSendMessage(kAYCollectionVerView, kAYTableRegisterDelegateMessage, &dele)
	dele = delegate_collect;
	kAYViewsSendMessage(kAYCollectionVerView, kAYTableRegisterDatasourceMessage, &dele)
	
//	NSString *item_class_name = @"AYFilterCansCellView";
//	kAYViewsSendMessage(kAYCollectionVerView, kAYTableRegisterCellWithClassMessage, &item_class_name)
	
//	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
//	[tmp setValue:[NSNumber numberWithInt:DongDaSegIndex] forKey:kAYServiceArgsServiceCat];
//	[tmp setValue:[NSNumber numberWithInt:-1] forKey:@"sub_index"];
//	kAYDelegatesSendMessage(@"HomeCollect", kAYDelegateChangeDataMessage, &tmp)
	
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
	
	UIButton *mapBtn = [[UIButton alloc]init];
	[mapBtn setImage:IMGRESOURCE(@"home_icon_mapfilter") forState:UIControlStateNormal];
	[view addSubview:mapBtn];
	[mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(view);
		make.centerX.equalTo(view.mas_right).offset(-30);
		make.size.mas_equalTo(CGSizeMake(28, 25));
	}];
	[mapBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
	[Tools addBtmLineWithMargin:0 andAlignment:NSTextAlignmentCenter andColor:[Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.f] inSuperView:view];
	return nil;
}

#import "AYDongDaSegDefines.h"
- (id)DongDaSegLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, 0, 180, 44);		//重新加入了self.view 的子view   0,0,w,h
	
	id<AYViewBase> seg = (id<AYViewBase>)view;
	id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
	
	NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
	[dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
	[dic_add_item_0 setValue:@"课程" forKey:kAYSegViewTitleKey];
	[cmd_add_item performWithResult:&dic_add_item_0];
	
	NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
	[dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
	[dic_add_item_1 setValue:@"看顾" forKey:kAYSegViewTitleKey];
	[cmd_add_item performWithResult:&dic_add_item_1];
	
	NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
	[dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
	[dic_user_info setValue:[NSNumber numberWithFloat:20] forKey:kAYSegViewMarginBetweenKey];
	
	id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
	[cmd_info performWithResult:&dic_user_info];
	
	return nil;
}

- (id)TableLayout:(UIView*)view {
	CGFloat topmargin = 108.f;
    view.frame = CGRectMake(0, topmargin, SCREEN_WIDTH, SCREEN_HEIGHT - topmargin - 49);
    ((UITableView*)view).backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)CollectionVerLayout:(UIView*)view {
	CGFloat topMargin = 108.f;
	view.frame = CGRectMake(0, topMargin, SCREEN_WIDTH, 90);
//	view.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.75f];
	view.backgroundColor = [UIColor whiteColor];
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
- (void)didAddressLabelTap {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"FilterLocation");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd_show_module = SHOWMODULEUP;
	[cmd_show_module performWithResult:&dic];
	
}

- (void)didFilterBtnClick:(UIButton*)btn {
//	UICollectionView *view_collect = [self.views objectForKey:kAYCollectionVerView];
	
	btn.selected = !btn.selected;
	NSLog(@"%d", btn.selected);
	if (btn.selected) {
		[UIView animateWithDuration:0.25 animations:^{
			filterCollectionView.frame = CGRectMake(0, 108.f, SCREEN_WIDTH, 90);
		}];
	} else {
		
		[UIView animateWithDuration:0.25 animations:^{
			filterCollectionView.frame = CGRectMake(0, 108.f - 90, SCREEN_WIDTH, 90);
		}];
	}
}

- (void)loadMoreData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	
	NSMutableDictionary *dic_search = [user mutableCopy];
	[dic_search setValue:[NSNumber numberWithInteger:skipCount] forKey:@"skip"];
	[dic_search setValue:[NSNumber numberWithDouble:timeInterval * 1000] forKey:@"date"];
	[dic_search setValue:search_loc forKey:kAYServiceArgsLocation];
	
	[dic_search setValue:[NSNumber numberWithInt:DongDaSegIndex] forKey:kAYServiceArgsServiceCat];
	[dic_search setValue:[subIndexData objectForKey:[NSString stringWithFormat:@"%d",DongDaSegIndex]] forKey:kAYServiceArgsTheme];
	
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			NSLog(@"query recommand tags result %@", result);
			NSArray *remoteArr = [result objectForKey:@"result"];
			
			if (remoteArr.count == 0) {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
			else {
				
				id tmp;
				if (DongDaSegIndex == ServiceTypeCourse) {
//					NSPredicate *pre_course = [NSPredicate predicateWithFormat:@"self.%@=%d", kAYServiceArgsServiceCat, ServiceTypeCourse];
//					NSArray *arr_course = [remoteArr filteredArrayUsingPredicate:pre_course];
					[servDataOfCourse addObjectsFromArray:remoteArr];
					
					tmp = [servDataOfCourse copy];
				} else {
//					NSPredicate *pre_nursery = [NSPredicate predicateWithFormat:@"self.%@=%d", kAYServiceArgsServiceCat, ServiceTypeNursery];
//					NSArray *arr_nursery = [remoteArr filteredArrayUsingPredicate:pre_nursery];
					[servDataOfNursery addObjectsFromArray:remoteArr];
					
					tmp = [servDataOfNursery copy];
				}
				
				skipCount = servDataOfNursery.count + servDataOfNursery.count;
				
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
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	
	NSMutableDictionary *dic_search = [user mutableCopy];
	[dic_search setValue:[NSNumber numberWithDouble:timeInterval * 1000] forKey:@"date"];
	[dic_search setValue:search_loc forKey:kAYServiceArgsLocation];
	
	[dic_search setValue:[NSNumber numberWithInt:DongDaSegIndex] forKey:kAYServiceArgsServiceCat];
	[dic_search setValue:[subIndexData objectForKey:[NSString stringWithFormat:@"%d",DongDaSegIndex]] forKey:kAYServiceArgsTheme];
	
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		UITableView *view_table = [self.views objectForKey:@"Table"];
		if (success) {
			NSLog(@"query recommand tags result %@", result);
			NSArray *remoteArr = [result objectForKey:@"result"];
			
//			NSPredicate *pre_course = [NSPredicate predicateWithFormat:@"self.%@=%d", kAYServiceArgsServiceCat, ServiceTypeCourse];
//			NSPredicate *pre_nursery = [NSPredicate predicateWithFormat:@"self.%@=%d", kAYServiceArgsServiceCat, ServiceTypeNursery];
//			servDataOfCourse = [[remoteArr filteredArrayUsingPredicate:pre_course] mutableCopy];
//			servDataOfNursery = [[remoteArr filteredArrayUsingPredicate:pre_nursery] mutableCopy];
			
			id tmp;
			if (DongDaSegIndex == ServiceTypeCourse) {
				servDataOfCourse = [remoteArr mutableCopy];
				tmp = [servDataOfCourse copy];
			} else if(DongDaSegIndex == ServiceTypeNursery) {
				servDataOfNursery = [remoteArr mutableCopy];
				tmp = [servDataOfNursery copy];
			}
			
			skipCount = servDataOfNursery.count + servDataOfNursery.count;
			
			kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			[view_table scrollsToTop];
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		[view_table.mj_header endRefreshing];
		
	}];
}

#pragma mark -- notifies
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
	if (DongDaSegIndex == ServiceTypeCourse) {
		[args setValue:[servDataOfCourse copy] forKey:@"result_data"];
	} else {
		[args setValue:[servDataOfNursery copy] forKey:@"result_data"];
	}
	
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
	
	DongDaSegIndex = index.intValue;
	
	id tmp;
	if (index.intValue == ServiceTypeCourse) {
		
		titleArr = kAY_service_options_title_course;
		if (servDataOfCourse.count != 0) {
			tmp = [servDataOfCourse copy];
			kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		} else {
			[self loadNewData];
		}
		
	} else {
		titleArr = kAY_service_options_title_nursery;
		if (servDataOfNursery.count != 0) {
			tmp = [servDataOfNursery copy];
			kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		} else {
			[self loadNewData];
		}
	}
	
	[filterCollectionView reloadData];
	
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
	if ([CLLocationManager locationServicesEnabled]) {
		
		[self.manager startUpdatingLocation];
	} else {
		NSString *title = @"请在iPhone的\"设置-隐私-定位\"中允许-咚哒-定位服务";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
}

//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	
	loc = [locations firstObject];
	[manager stopUpdatingLocation];
	
}


@end
