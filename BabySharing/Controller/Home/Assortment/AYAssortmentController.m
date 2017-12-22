//
//  AYAssortmentListController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentController.h"
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

#define kCOLLECTIONVIEWTOP			(kStatusAndNavBarH + 141)

@implementation AYAssortmentController {
//	UIStatusBarStyle statusStyle;
	
	UILabel *navTitleLabel;
	UICollectionView *servCollectionView;
	
	NSString *sortCateg;
	NSInteger skipedCount;
	NSMutableArray *remoteDataArr;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return remoteDataArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYHomeAssortmentItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYHomeAssortmentItem" forIndexPath:indexPath];
	id tmp = [remoteDataArr objectAtIndex:indexPath.row];
	[item setItemInfo:tmp];
	return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
//	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
//	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//
//	[dic setValue:[remoteDataArr objectAtIndex:indexPath.row] forKey:kAYControllerChangeArgsKey];
//
//	id<AYCommand> cmd_push = PUSHANIMATE;
//	[cmd_push performWithResult:&dic];
	
	AYHomeAssortmentItem *item = (AYHomeAssortmentItem*)[collectionView cellForItemAtIndexPath:indexPath];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	[dic setObject:item.coverImage forKey:kAYControllerImgForFrameKey];
	[dic setValue:[remoteDataArr objectAtIndex:indexPath.row] forKey:kAYControllerChangeArgsKey];
	
//	id<AYCommand> cmd_push_animate = PUSHANIMATE;
//	[cmd_push_animate performWithResult:&dic];
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		sortCateg = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	skipedCount = 0;
	
//	navTitleLabel = [UILabel creatLabelWithText:@"" textColor:[UIColor black] fontSize:616 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
//	[self.view addSubview:navTitleLabel];
//	[navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(self.view).offset(15);
//		make.top.equalTo(self.view).offset(kStatusAndNavBarH);
//	}];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	layout.itemSize = CGSizeMake((SCREEN_WIDTH - 39)*0.5, 250);
	layout.minimumInteritemSpacing = 8.f;
	layout.minimumLineSpacing = 8.f;
	
	servCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT-kStatusAndNavBarH) collectionViewLayout:layout];
	servCollectionView.delegate = self;
	servCollectionView.dataSource = self;
	servCollectionView.backgroundColor = [UIColor clearColor];
	servCollectionView.showsVerticalScrollIndicator = NO;
	
	servCollectionView.contentInset = UIEdgeInsetsMake(10, 15, 0, 15);
	[self.view addSubview:servCollectionView];
	[servCollectionView registerClass:NSClassFromString(@"AYHomeAssortmentItem") forCellWithReuseIdentifier:@"AYHomeAssortmentItem"];
	
	servCollectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	servCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	
	[self loadNewData];
}

#pragma mark -- actions
- (void)loadNewData {
	
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:sortCateg forKey:kAYServiceArgsCategoryInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLongLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray* tmp = [result objectForKey:@"services"];
			remoteDataArr = [tmp mutableCopy];
			skipedCount = remoteDataArr.count;
			[servCollectionView reloadData];
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		[servCollectionView.mj_header endRefreshing];
	}];
}

- (void)loadMoreData {
	
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:sortCateg forKey:kAYServiceArgsCategoryInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	[dic_search setValue:[NSNumber numberWithInteger:skipedCount] forKey:kAYCommArgsRemoteDataSkip];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *reArr = [result objectForKey:@"services"];
			if (reArr.count != 0) {
				[remoteDataArr addObjectsFromArray:reArr];
				skipedCount = remoteDataArr.count;
				
				[servCollectionView reloadData];
			} else {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
//		[servCollectionView reloadData];
		[servCollectionView.mj_footer endRefreshing];
	}];
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
	
	NSString *title = sortCateg;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
//	navTitleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools blackColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//	[view addSubview:navTitleLabel];
//	[navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(view.mas_centerY).offset(0);
//		make.centerX.equalTo(view);
//	}];
//	
//	navCountLabel = [Tools creatUILabelWithText:@"6个服务" andTextColor:[Tools blackColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//	[view addSubview:navCountLabel];
//	[navCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.top.equalTo(view.mas_centerY).offset(0);
//		make.centerX.equalTo(view);
//	}];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	is_hidden = [NSNumber numberWithBool:YES];
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
//	view.layer.shadowColor = [Tools garyColor].CGColor;
//	view.layer.shadowOffset = CGSizeMake(0, 3);
//	view.layer.shadowOpacity = 0.25f;
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
	((UITableView*)view).contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
	return nil;
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

#pragma scroll delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	CGFloat offset_y = scrollView.contentOffset.y;
//	
//	UIView *navBar = [self.views objectForKey:@"FakeNavBar"];
//	UIView *statusBar = [self.views objectForKey:@"FakeStatusBar"];
//	
//	if (offset_y < 0 ) {
//		
//		CGFloat alp = fabs(offset_y) / (kCOLLECTIONVIEWTOP - kStatusAndNavBarH);		// UP -> small
//		if (alp > 0.7) {
//			navLeftBtn.selected = YES;
//			statusStyle = UIStatusBarStyleLightContent;
//			[self setNeedsStatusBarAppearanceUpdate];
//		} else if (alp < 0.7) {
//			navLeftBtn.selected = NO;
//			statusStyle = UIStatusBarStyleDefault;
//			[self setNeedsStatusBarAppearanceUpdate];
//		}
//		else if (alp >= 1)
//			alp = 1.f;
//		NSLog(@"alp : %f", alp);
//		
//		navBar.alpha = statusBar.alpha = 1 - alp;
//		bannerView.alpha = alp;
//	}
//}

//- (UIStatusBarStyle)preferredStatusBarStyle {
////	[self setNeedsStatusBarAppearanceUpdate];
//	return statusStyle;
//}

@end
