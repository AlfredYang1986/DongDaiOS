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

@implementation AYHomeController {
	
    NSArray* push_content;
    NSNumber* start_index;
    
    CATextLayer* badge;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CALayer *maskLayer;
	
    NSInteger skipCount;
	NSTimeInterval timeSpan;
	NSDictionary *search_loc;
	NSNumber *search_cansCat;
	NSNumber *search_servCat;
	NSMutableArray *servicesData;
	
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
		
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        push_content = [args objectForKey:@"content"];
        start_index = [args objectForKey:@"start_index"];
        
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

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
	
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
	
//	NSString* class_name_his = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//	[cmd_cell performWithResult:&class_name_his];
//	
//	NSString* class_name_lik = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeLikesCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//	[cmd_cell performWithResult:&class_name_lik];
	
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
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 55);
	
//	UIImage *left = IMGRESOURCE(@"search_icon");
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
//	UIImageView *searchSign = [[UIImageView alloc]init];
//	searchSign.image = IMGRESOURCE(@"search_icon");
//	[view addSubview:searchSign];
//	[searchSign mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(view).offset(15);
//		make.centerY.equalTo(view).offset(5);
//		make.size.mas_equalTo(CGSizeMake(20, 20));
//	}];
	
	addressLabel = [Tools creatUILabelWithText:@"北京市" andTextColor:[Tools themeColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[view addSubview:addressLabel];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(view).offset(20);
		make.centerY.equalTo(view).offset(5);
		make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH * 0.4);
	}];
	
	UIView *pointSep = [[UIView alloc]init];
	pointSep.layer.cornerRadius = 1.f;
	pointSep.clipsToBounds = YES;
	pointSep.backgroundColor = [Tools blackColor];
	[view addSubview:pointSep];
	[pointSep mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(addressLabel.mas_right).offset(15);
		make.centerY.equalTo(addressLabel);
		make.size.mas_equalTo(CGSizeMake(2, 2));
	}];
	
	themeCatlabel = [Tools creatUILabelWithText:@"服务主题" andTextColor:[Tools themeColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[view addSubview:themeCatlabel];
	[themeCatlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(pointSep.mas_right).offset(15);
		make.centerY.equalTo(addressLabel);
	}];
	
	addressLabel.userInteractionEnabled = themeCatlabel.userInteractionEnabled = YES;
	[addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddressLabelTap)]];
	[themeCatlabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didThemeCatlabelTap)]];
	
//	UIImage* right = IMGRESOURCE(@"map_icon");
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnImgMessage, &right)
	
	UIButton *mapBtn = [[UIButton alloc]init];
	[mapBtn setImage:IMGRESOURCE(@"map_icon") forState:UIControlStateNormal];
	[view addSubview:mapBtn];
	[mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(view).offset(5);
		make.right.equalTo(view).offset(-12);
		make.size.mas_equalTo(CGSizeMake(28, 25));
	}];
	[mapBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 75, SCREEN_WIDTH, SCREEN_HEIGHT - 75 - 49);
    ((UITableView*)view).backgroundColor = [UIColor whiteColor];
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

- (void)didThemeCatlabelTap {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"FilterTheme");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:search_cansCat forKey:kAYServiceArgsTheme];
	[tmp setValue:search_servCat forKey:kAYServiceArgsServiceCat];
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = SHOWMODULEUP;
	[cmd_show_module performWithResult:&dic];
}

- (void)loadMoreData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	
	NSMutableDictionary *dic_search = [user mutableCopy];
	[dic_search setValue:[NSNumber numberWithInteger:skipCount] forKey:@"skip"];
	[dic_search setValue:[NSNumber numberWithDouble:timeSpan * 1000] forKey:@"date"];
	[dic_search setValue:search_cansCat forKey:kAYServiceArgsTheme];
	[dic_search setValue:search_loc forKey:kAYServiceArgsLocation];
	[dic_search setValue:search_servCat forKey:kAYServiceArgsServiceCat];
	
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			NSLog(@"query recommand tags result %@", result);
			
			if (result.count == 0) {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			} else {
				
				[servicesData addObjectsFromArray:(NSArray*)result];
				skipCount = servicesData.count;
				id arr = [servicesData copy];
				kAYDelegatesSendMessage(@"Home", @"changeQueryData:", &arr)
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
	timeSpan = [NSDate date].timeIntervalSince1970;
	[dic_search setValue:[NSNumber numberWithDouble:timeSpan * 1000] forKey:@"date"];
	[dic_search setValue:search_cansCat forKey:kAYServiceArgsTheme];
	[dic_search setValue:search_loc forKey:kAYServiceArgsLocation];
	[dic_search setValue:search_servCat forKey:kAYServiceArgsServiceCat];
	
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			NSLog(@"query recommand tags result %@", result);
			
			servicesData = [NSMutableArray arrayWithArray:(NSArray*)result];
			skipCount = servicesData.count;
			id arr = [servicesData copy];
			kAYDelegatesSendMessage(@"Home", @"changeQueryData:", &arr) 
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
		[((UITableView*)view_table).mj_header endRefreshing];
		
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
	[args setValue:[servicesData copy] forKey:@"result_data"];
	[dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic_show_module];
	
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
