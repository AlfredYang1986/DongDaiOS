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
    
    UIView *cover;
    NSString *notePostId;
	
    NSInteger skipCount;
	NSMutableArray *servicesData;
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
        if (backArgs) {
            
            if ([backArgs isKindOfClass:[NSString class]]) {
                
                NSString *title = (NSString*)backArgs;
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
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
	
	{
		UILabel *tipsLabel = [Tools creatUILabelWithText:@"为您的孩子找个好去处" andTextColor:[Tools blackColor] andFontSize:15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[tableView addSubview:tipsLabel];
		[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(tableView).offset(20);
			make.right.equalTo(tableView).offset(-20);
			make.bottom.equalTo(tableView.mas_top).offset(-40);
		}];
		
		NSDate *nowDate = [NSDate date];
		NSDateFormatter *format = [Tools creatDateFormatterWithString:@"HH"];
		NSString *dateStr = [format stringFromDate:nowDate];
		
		NSString *on = nil;
		int timeSpan = dateStr.intValue;
		if (timeSpan >= 6 && timeSpan < 12) {
			on = @"上午好";
		} else if (timeSpan >= 12 && timeSpan < 18) {
			on = @"下午好";
		} else if((timeSpan >= 18 && timeSpan < 24) || (timeSpan >= 0 && timeSpan < 6)){
			on = @"晚上好";
		} else {
			on = @"获取系统时间错误";
		}
		
		UILabel *hello = [Tools creatUILabelWithText:on andTextColor:[Tools blackColor] andFontSize:125.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[tableView addSubview:hello];
		[hello mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(tableView).offset(20);
			make.bottom.equalTo(tipsLabel.mas_top).offset(-12);
		}];
		
		CALayer *sepLayer = [CALayer layer];
		sepLayer.frame = CGRectMake(20, - 20.5, 50, 0.5);
		sepLayer.backgroundColor = [Tools garyLineColor].CGColor;
		[tableView.layer addSublayer:sepLayer];
	}
	
	tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
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
	
//	servicesData = [[NSMutableArray alloc]init];
	
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
	
	NSNumber *is_hidden_left = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden_left)
	
//	NSNumber *is_hidden_right = [NSNumber numberWithBool:YES];
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden_right)
	
	UIImage* right = IMGRESOURCE(@"map_icon");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnImgMessage, &right)
	
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(TableContentInsetTop, 0, 0, 0);
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
				
				skipCount += result.count;
				id arr = (NSArray*)result;
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
			
			skipCount = result.count;
			servicesData = [(NSArray*)result mutableCopy];
			id arr = (NSArray*)result;
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
