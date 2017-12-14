//
//  AYTopicContentController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTopicContentController.h"

#define kCOLLECTIONVIEWTOP			(kStatusAndNavBarH + 141)

@interface AYTopicContentController ()

@end

@implementation AYTopicContentController {
	UIStatusBarStyle statusStyle;
	
	UIView *bannerView;
	UILabel *bannerTitle;
	UILabel *bannerCount;
	UIButton *navLeftBtn;
	
	UILabel *navTitleLabel;
	UILabel *navCountLabel;
	
	NSString *sortCateg;
	NSInteger skipedCount;
	NSMutableArray *remoteDataArr;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return remoteDataArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYAssortmentItemView *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYAssortmentItemView" forIndexPath:indexPath];
	id tmp = [remoteDataArr objectAtIndex:indexPath.row];
	[item setItemInfo:tmp];
	return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic setValue:[remoteDataArr objectAtIndex:indexPath.row] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
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
	
	bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCOLLECTIONVIEWTOP + 30)];
	[self.view addSubview:bannerView];
	[self.view bringSubviewToFront:bannerView];
	UIImageView *cover = [[UIImageView alloc] initWithFrame:bannerView.bounds];
	
	NSArray *assortmentArr = kAY_top_assortment_titles;
	NSString *coverImgName = [NSString stringWithFormat:@"topsort_list_%ld", [assortmentArr indexOfObject:sortCateg]];
	cover.image = IMGRESOURCE(coverImgName);
	[bannerView addSubview:cover];
	
	UIView *navBar = [self.views objectForKey:kAYFakeNavBarView];
	UIView *statusBar = [self.views objectForKey:kAYFakeStatusBarView];
	[self.view bringSubviewToFront:navBar];
	[self.view bringSubviewToFront:statusBar];
	
	navLeftBtn = [[UIButton alloc] init];
	[navLeftBtn setImage:IMGRESOURCE(@"bar_left_black") forState:UIControlStateNormal];
	[navLeftBtn setImage:IMGRESOURCE(@"bar_left_white") forState:UIControlStateSelected];
	[self.view addSubview:navLeftBtn];
	[navLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(navBar).offset(10.5);
		make.centerY.equalTo(navBar);
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	navLeftBtn.selected = YES;
	[navLeftBtn addTarget:self action:@selector(leftBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	bannerTitle = [Tools creatUILabelWithText:@"# The Topic #" andTextColor:[Tools whiteColor] andFontSize:622.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[bannerView addSubview:bannerTitle];
	[bannerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(bannerView).offset(15);
		make.top.equalTo(bannerView).offset(kStatusAndNavBarH+20);
	}];
	
	NSShadow *sdw = [[NSShadow alloc] init];
	sdw.shadowColor = [Tools colorWithRED:173 GREEN:186 BLUE:222 ALPHA:1.f];
	sdw.shadowOffset = CGSizeMake(1, 1);
	sdw.shadowBlurRadius = 2.f;
	
	if (sortCateg) {
		NSString *categStr = [NSString stringWithFormat:@"#%@#", sortCateg];
		
		NSDictionary *shadowAttr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:22.f],
									 NSForegroundColorAttributeName :[Tools whiteColor],
									 NSShadowAttributeName:sdw};
		
		NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:categStr];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22.f], NSForegroundColorAttributeName :[Tools themeColor]} range:NSMakeRange(0, 1)];
		[attributedText setAttributes:shadowAttr range:NSMakeRange(1, categStr.length - 2)];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22.f], NSForegroundColorAttributeName :[Tools themeColor]} range:NSMakeRange(categStr.length - 1, 1)];
		bannerTitle.attributedText = attributedText;
	}
	
	bannerCount = [UILabel creatLabelWithText:nil textColor:[Tools whiteColor] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	bannerCount.numberOfLines = 0;
	NSString *countstr = @"为您准备了6个儿童服务,为您准备了6个儿童服务,为您准备了6个儿童服务为您准备了6个儿童服务,为您准备了6个儿童服务,为您准备了6个儿童服务.";
	NSDictionary *shadowAttr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f],
								 NSForegroundColorAttributeName :[Tools whiteColor],
								 NSShadowAttributeName:sdw};
	
	NSAttributedString *countAttrStr = [[NSAttributedString alloc] initWithString:countstr attributes:shadowAttr];
	bannerCount.attributedText = countAttrStr;
	[bannerView addSubview:bannerCount];
	[bannerCount mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(bannerTitle);
		make.right.equalTo(bannerView.mas_right).offset(-15);
		make.top.equalTo(bannerTitle.mas_bottom).offset(15);
	}];
	
	
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	
	id<AYDelegateBase> delegate_found = [self.delegates objectForKey:@"TopicContent"];
	id obj = (id)delegate_found;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	obj = (id)delegate_found;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	
	NSArray *arr_cell_name = @[@"AYHomeServPerCellView"];
	for (NSString *cell_name in arr_cell_name) {
		id class_name = [cell_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name);
	}
	
	[self.view bringSubviewToFront:tableView];
	
//	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	
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
		
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		if (success) {
			remoteDataArr = [[result objectForKey:@"services"] mutableCopy];
			skipedCount = remoteDataArr.count;
			
			id tmp = [remoteDataArr copy];
			kAYDelegatesSendMessage(@"TopicContent", kAYDelegateChangeDataMessage, &tmp)
			[tableView reloadData];
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		[tableView.mj_header endRefreshing];
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
		
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		if (success) {
			NSArray *reArr = [result objectForKey:@"services"];
			if (reArr.count != 0) {
				[remoteDataArr addObjectsFromArray:reArr];
				skipedCount = remoteDataArr.count;
				
				id tmp = [remoteDataArr copy];
				kAYDelegatesSendMessage(@"TopicContent", kAYDelegateChangeDataMessage, &tmp)
				[tableView reloadData];
			} else {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		[tableView.mj_footer endRefreshing];
	}];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools whiteColor];
	view.alpha = 0;
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools whiteColor];
	view.alpha = 0;
	
	NSString *title = sortCateg;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	//	UIImage* left = IMGRESOURCE(@"bar_left_black");
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
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
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
	view.layer.shadowColor = [Tools garyColor].CGColor;
	view.layer.shadowOffset = CGSizeMake(0, 3);
	view.layer.shadowOpacity = 0.25f;
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
	view.backgroundColor = [UIColor clearColor];
	((UITableView*)view).contentInset = UIEdgeInsetsMake(141, 0, 0, 0);
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
- (id)scrollViewDidScroll:(id)args {
	CGFloat offset_y = [args floatValue];
	
	UIView *navBar = [self.views objectForKey:@"FakeNavBar"];
	UIView *statusBar = [self.views objectForKey:@"FakeStatusBar"];
	
	if (offset_y < 0 ) {
		
		CGFloat alp = fabs(offset_y) / (kCOLLECTIONVIEWTOP - kStatusAndNavBarH);		// UP -> small
		if (alp > 0.7) {
			navLeftBtn.selected = YES;
			statusStyle = UIStatusBarStyleLightContent;
			[self setNeedsStatusBarAppearanceUpdate];
		} else if (alp < 0.7) {
			navLeftBtn.selected = NO;
			statusStyle = UIStatusBarStyleDefault;
			[self setNeedsStatusBarAppearanceUpdate];
		}
		else if (alp >= 1)
			alp = 1.f;
		NSLog(@"alp : %f", alp);
		
		navBar.alpha = statusBar.alpha = 1 - alp;
		bannerView.alpha = alp;
	}
	
	return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	//	[self setNeedsStatusBarAppearanceUpdate];
	return statusStyle;
}

@end

