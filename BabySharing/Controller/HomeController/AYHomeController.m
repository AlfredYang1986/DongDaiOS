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
	NSMutableArray *servicesData;
	
	UILabel *addressLabel;
	UILabel *themeCatlabel;
	
	NSDictionary *dic_location;
}

@synthesize isPushed = _isPushed;
@synthesize push_home_title = _push_home_title;

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _isPushed = YES;
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        _push_home_title = [args objectForKey:@"home_title"];
        push_content = [args objectForKey:@"content"];
        start_index = [args objectForKey:@"start_index"];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		
		if ([backArgs isKindOfClass:[NSString class]]) {
			NSString *title = (NSString*)backArgs;
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		else if ([backArgs isKindOfClass:[NSDictionary class]]) {
			NSString *key = [backArgs objectForKey:@"key"];
			if ([key isEqualToString:@"filterLocation"]) {
				addressLabel.text = [backArgs objectForKey:kAYServiceArgsAddress];
			}
			else if ([key isEqualToString:@"filterTheme"]) {
				themeCatlabel.text = [backArgs objectForKey:@"title"];
			}
		}
			
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
	UITableView *tableView = (UITableView*)view_notify;
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
	NSString* class_name_tip = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name_tip];
	
//	NSString* class_name_his = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//	[cmd_cell performWithResult:&class_name_his];
//	
//	NSString* class_name_lik = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeLikesCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//	[cmd_cell performWithResult:&class_name_lik];
	
	[self loadNewData];
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
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage *left = IMGRESOURCE(@"search_icon");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	addressLabel = [Tools creatUILabelWithText:@"场地地址" andTextColor:[Tools themeColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[view addSubview:addressLabel];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(view).offset(50);
		make.centerY.equalTo(view);
		make.width.mas_lessThanOrEqualTo(150);
	}];
	
	UIView *pointSep = [[UIView alloc]init];
	pointSep.layer.cornerRadius = 1.f;
	pointSep.clipsToBounds = YES;
	pointSep.backgroundColor = [Tools blackColor];
	[view addSubview:pointSep];
	[pointSep mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(addressLabel.mas_right).offset(15);
		make.centerY.equalTo(view);
		make.size.mas_equalTo(CGSizeMake(2, 2));
	}];
	
	themeCatlabel = [Tools creatUILabelWithText:@"服务主题" andTextColor:[Tools themeColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[view addSubview:themeCatlabel];
	[themeCatlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(pointSep.mas_right).offset(15);
		make.centerY.equalTo(view);
	}];
	
	addressLabel.userInteractionEnabled = themeCatlabel.userInteractionEnabled = YES;
	[addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddressLabelTap)]];
	[themeCatlabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didThemeCatlabelTap)]];
	
	UIImage* right = IMGRESOURCE(@"map_icon");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnImgMessage, &right)
	
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    
//    ((UITableView*)view).contentInset = UIEdgeInsetsMake(TableContentInsetTop, 0, 0, 0);
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
	NSTimeInterval timeSpan = [NSDate date].timeIntervalSince1970;
	[dic_search setValue:[NSNumber numberWithDouble:timeSpan * 1000] forKey:@"date"];
	
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
	NSTimeInterval timeSpan = [NSDate date].timeIntervalSince1970;
	[dic_search setValue:[NSNumber numberWithDouble:timeSpan * 1000] forKey:@"date"];
	
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
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"MapMatch");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[servicesData copy] forKey:kAYControllerChangeArgsKey];
	
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

@end
