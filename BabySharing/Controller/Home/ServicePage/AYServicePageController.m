//
//  AYPersonalPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServicePageController.h"
#import "TmpFileStorageModel.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYServiceImagesCell.h"
#import "AYServicePageBtmView.h"

#define kLIMITEDSHOWNAVBAR			(-70.5)
#define kFlexibleHeight				300
#define kBtmViewHeight				56
#define kBookBtnTitleNormal			@"查看可预订时间"
#define kBookBtnTitleSeted			@"申请预订"

//#define CarouseNumb			

@implementation AYServicePageController {
	NSDictionary *receiveData;
    NSMutableDictionary *service_info;
    
    UIButton *shareBtn;
    CGFloat offset_y;
	BOOL isBlackLeftBtn;
	BOOL isStatusHide;
	
//	NSNumber *cellMinY;
	
    UIButton *bar_like_btn;
    UIView *flexibleView;
	BOOL isChangeCollect;
	/****/
	UICollectionView *CarouselView;
	UIPageControl *pageControl;
	int carouselNumb;
	CGFloat HeadViewHeight;
	/****/
	
	NSMutableArray *offer_date_mutable;
}

-(void)postPerform {
	[super postPerform];
	isStatusHide = YES;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		receiveData = [dic objectForKey:kAYControllerChangeArgsKey];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
    }
}

#pragma mark --<UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return carouselNumb == 0 ? 1 : carouselNumb;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYServiceImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYServiceImagesCell" forIndexPath:indexPath];
	
	NSArray *images = [service_info objectForKey:kAYServiceArgsImages];
	if (images.count != 0) {
		if ([[images firstObject] isKindOfClass:[NSString class]]) {
			[cell setItemImageWithImageName:[images objectAtIndex:indexPath.row]];
		} else {
			[cell setItemImageWithImage:[images objectAtIndex:indexPath.row]];
		}
		
	} else
		[cell setItemImageWithImage:IMGRESOURCE(@"default_image")];
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
		return CGSizeMake(SCREEN_WIDTH, HeadViewHeight);
}

//设置页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	int page = (int)(scrollView.contentOffset.x / SCREEN_WIDTH + 0.5)%carouselNumb;
	pageControl.currentPage = page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	
	HeadViewHeight = kFlexibleHeight;
	
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServicePage"];
    id obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
    obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	
	NSArray *cell_class_name_arr = @[@"ServiceTitleCell",
									 @"ServiceOwnerInfoCell",
									 @"ServiceCapacityCell",
									 @"ServiceDescCell",
									 @"ServiceMapCell",
									 @"ServiceFacilityCell",
									 @"ServiceNotiCell"];
	NSString* class_name;
	for (NSString *class_name_str in cell_class_name_arr) {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:class_name_str] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	}
	
	/*********************************************/
	
	{
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		flexibleView = [[UIView alloc]init];
		[tableView addSubview:flexibleView];
		[flexibleView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tableView).offset(-kFlexibleHeight);
			make.centerX.equalTo(tableView);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kFlexibleHeight));
		}];
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.minimumLineSpacing = 0.f;
		layout.minimumInteritemSpacing = 0.f;
		layout.itemSize = CGSizeMake(SCREEN_WIDTH, HeadViewHeight);
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		CarouselView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFlexibleHeight) collectionViewLayout:layout];
		CarouselView.backgroundColor = [UIColor clearColor];
		CarouselView.delegate = self;
		CarouselView.dataSource = self;
		CarouselView.pagingEnabled = YES;
		CarouselView.showsHorizontalScrollIndicator = NO;
		CarouselView.bounces = NO;
		[CarouselView registerClass:NSClassFromString(@"AYServiceImagesCell") forCellWithReuseIdentifier:@"AYServiceImagesCell"];
		[flexibleView addSubview:CarouselView];
	}
	
	NSNumber *per_mode = [receiveData objectForKey:@"perview_mode"];
	NSString *service_id = [receiveData objectForKey:kAYServiceArgsID];
	if (per_mode ) {
		bar_like_btn.hidden = YES;
		
		service_info = [receiveData mutableCopy];
		[self layoutServicePageBannerImages];
		NSDictionary *tmp = [service_info copy];
		kAYDelegatesSendMessage(@"ServicePage", kAYDelegateChangeDataMessage, &tmp)
		
	} else {
		
//		AYServicePageBtmView *btmView = [[AYServicePageBtmView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBtmViewHeight-HOME_IND_HEIGHT, SCREEN_WIDTH, kBtmViewHeight)];
//		[self.view addSubview:btmView];
//		[self.view bringSubviewToFront:btmView];
//		[btmView.bookBtn addTarget:self action:@selector(didBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
//		[btmView.chatBtn addTarget:self action:@selector(didChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		
		NSDictionary *user;
		CURRENUSER(user);
		NSMutableDictionary *dic_detail = [user mutableCopy];
//		NSDictionary *dic_condt = @{service_id:kAYServiceArgsID};
		NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
		[dic_condt setValue:service_id forKey:kAYServiceArgsID];
		[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
		[dic_detail setValue:dic_condt forKey:kAYCommArgsCondition];
		
		id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
		AYRemoteCallCommand* cmd_search = [f_search.commands objectForKey:@"QueryServiceDetail"];
		[cmd_search performWithResult:[dic_detail copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
			if(success) {
				
				NSMutableDictionary *tmp_args = [[result objectForKey:@"service"] mutableCopy];
				id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
				id<AYCommand> cmd = [facade.commands objectForKey:@"ParseServiceTMProtocol"];
				id args = [tmp_args objectForKey:@"tms"];
				[cmd performWithResult:&args];
				
				offer_date_mutable = [args mutableCopy];
				[offer_date_mutable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					NSArray *occurance = [obj objectForKey:kAYServiceArgsOccurance];
					[occurance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						[obj setValue:[NSNumber numberWithBool:NO] forKey:@"is_selected"];
					}];
				}];
				
				[tmp_args setValue:[args copy] forKey:kAYServiceArgsOfferDate];
				service_info = tmp_args;
				
//				[btmView setViewWithData:service_info];
				[self layoutServicePageBannerImages];
				
				NSDictionary *tmp = [service_info copy];
				kAYDelegatesSendMessage(@"ServicePage", kAYDelegateChangeDataMessage, &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
				[CarouselView reloadData];
				
			} else {
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
			}
		}];
		
	}
	
	/***************************************/
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
	id<AYViewBase> statusBar = [self.views objectForKey:@"FakeStatusBar"];
    [self.view bringSubviewToFront:(UIView*)navBar];
	[self.view bringSubviewToFront:(UIView*)statusBar];
    ((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
    UIImage* left = IMGRESOURCE(@"bar_left_white");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    id right = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right)
	
    bar_like_btn = [[UIButton alloc]init];
    [bar_like_btn setImage:IMGRESOURCE(@"details_icon_love_normal") forState:UIControlStateNormal];
    [bar_like_btn setImage:IMGRESOURCE(@"details_icon_love_select") forState:UIControlStateSelected];
    [bar_like_btn addTarget:self action:@selector(didCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bar_like_btn];
    [bar_like_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-20);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
	
    return nil;
}

- (id)TableLayout:(UIView*)view {
//	NSNumber *per_mode = [receiveData objectForKey:@"perview_mode"];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT /*- (per_mode ? 0 : kBtmViewHeight) - HOME_IND_HEIGHT*/);
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(kFlexibleHeight, 0, 0, 0);
    ((UITableView*)view).estimatedRowHeight = 300;
    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	if (isChangeCollect) {
		NSDictionary *back_args = @{@"args":service_info, @"key":@"is_change_collect"};
		[dic setValue:back_args forKey:kAYControllerChangeArgsKey];
	}
	
	id<AYCommand> cmd = POPANIMATE;
	[cmd performWithResult:&dic];
    return nil;
}

- (id)sendPopMessage {
    [self leftBtnSelected];
    return nil;
}

-(id)scrollOffsetY:(NSNumber*)y {
	
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
	id<AYViewBase> statusBar = [self.views objectForKey:@"FakeStatusBar"];
	
	offset_y = y.floatValue;
	if (offset_y < - kStatusAndNavBarH * 2) {
		((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
	}
	else if ( offset_y >= -kStatusAndNavBarH * 2) { //偏移的绝对值 小于 abs(-64)
		
		CGFloat alp = (kStatusAndNavBarH*2 + offset_y) / (kStatusAndNavBarH);
		if (alp > 0.5 && !isBlackLeftBtn) {
			UIImage* left = IMGRESOURCE(@"bar_left_black");
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
			isBlackLeftBtn = YES;
			NSString *titleStr = @"服务详情";
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &titleStr)
			isStatusHide = NO;
			[self setNeedsStatusBarAppearanceUpdate];
			
		} else if (alp <  0.5 && isBlackLeftBtn) {
			UIImage* left = IMGRESOURCE(@"bar_left_white");
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
			isBlackLeftBtn = NO;
			NSString *titleStr = @"";
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &titleStr)
			isStatusHide = YES;
			[self setNeedsStatusBarAppearanceUpdate];
		}
		
		((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:alp];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarHideBarBotLineMessage, nil)
	}
	
    CGFloat offsetH = kFlexibleHeight + offset_y;
    if (offsetH < 0) {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
		UITableView *tableView = (UITableView*)view_notify;
		HeadViewHeight = kFlexibleHeight - offsetH;
        [flexibleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tableView);
            make.top.equalTo(tableView).offset(-kFlexibleHeight + offsetH);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, HeadViewHeight));
        }];
		CarouselView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeadViewHeight);
		[CarouselView reloadData];
    }
	
    return nil;
}

- (id)showP2PMap {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServiceMap");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_p2p = [[NSMutableDictionary alloc]init];
	[dic_p2p setValue:[service_info copy] forKey:kAYServiceArgsInfo];
//	dic_p2p [setValue: forKey:@"self"];
	[dic setValue:[dic_p2p copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = SHOWMODULEUP;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)showCansOrFacility {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"Facility");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[service_info objectForKey:@"facility"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)showServiceOfferDate {
	
    id<AYCommand> dest = DEFAULTCONTROLLER(@"BOrderTime");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:service_info forKey:kAYServiceArgsInfo];
	[tmp setValue:offer_date_mutable forKey:kAYServiceArgsOfferDate];
    [dic_push setValue:tmp forKey:kAYControllerChangeArgsKey];
	
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic_push];
    return nil;
}

- (id)showHideDescDetail:(NSNumber*)args {
	
	UITableView *table = [self.views objectForKey:@"Table"];
	kAYDelegatesSendMessage(@"ServicePage", @"TransfromExpend:", &args)
	[table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
	
//	[table beginUpdates];
//	[table endUpdates];
    return nil;
}

#pragma mark -- actions
- (void)layoutServicePageBannerImages {
	carouselNumb = (int)((NSArray*)[service_info objectForKey:@"images"]).count;
	
	pageControl = [[UIPageControl alloc]init];
	pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.f alpha:0.5f];
	pageControl.currentPageIndicatorTintColor = [Tools whiteColor];
	pageControl.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[flexibleView addSubview:pageControl];
	pageControl.numberOfPages = carouselNumb;
	CGSize size = [pageControl sizeForNumberOfPages:carouselNumb];
	[pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(flexibleView).offset(-5);
		make.centerX.equalTo(flexibleView);
		make.size.mas_equalTo(CGSizeMake(size.width, 10));
	}];
	pageControl.hidden = carouselNumb == 1;
	
	NSNumber *iscollect = [service_info objectForKey:kAYServiceArgsIsCollect];
	bar_like_btn.selected = iscollect.boolValue;
	
}

- (void)didBookBtnClick {
	if ([self isOwnerUserSelf]) {
		return;
	}
	[self showServiceOfferDate];
}

- (BOOL)isOwnerUserSelf {
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSString *user_id = [user objectForKey:@"user_id"];
	NSString *owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
	if ([user_id isEqualToString:owner_id]) {
		NSString *title = @"该服务是您自己发布";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return YES;
	} else
		return NO;
}

- (void)didChatBtnClick:(UIButton*)btn {
	if ([self isOwnerUserSelf]) {
		return;
	}
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	NSString *user_id = [user objectForKey:@"user_id"];
	NSString *owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
	
    id<AYCommand> des = DEFAULTCONTROLLER(@"SingleChat");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
	NSMutableDictionary *dic_chat = [[NSMutableDictionary alloc]init];
	[dic_chat setValue:user_id forKey:@"user_id"];
	[dic_chat setValue:owner_id forKey:@"owner_id"];
    
    [dic setValue:dic_chat forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    
}

-(void)didCollectionBtnClick:(UIButton*)btn{
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:[service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_collect setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic setValue:dic_collect forKey:@"collections"];
	
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] initWithDictionary:dic_collect];
	[dic setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    if (!bar_like_btn.selected) {
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
				isChangeCollect = YES;
                bar_like_btn.selected = YES;
				[service_info setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
            } else {
                NSString *title = @"收藏失败!请检查网络链接是否正常";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
	else {
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
				isChangeCollect = YES;
                bar_like_btn.selected = NO;
				[service_info setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
            } else {
                NSString *title = @"取消收藏失败!请检查网络链接是否正常";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
}

- (BOOL)prefersStatusBarHidden {
	return isStatusHide;
}

//- (BOOL)prefersStatusBarHidden{
//	return YES;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleDefault;
}

@end
