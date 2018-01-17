//
//  AYTopicContentController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTopicContentController.h"

#define kCOLLECTIONVIEWTOP			(kStatusBarH + 161)

@interface AYTopicContentController ()

@end

@implementation AYTopicContentController {
	UIStatusBarStyle statusStyle;
	
	UIView *bannerView;
	UILabel *bannerTitle;
	UIButton *navLeftBtn;
	
	UILabel *navTitleLabel;
	UILabel *navCountLabel;
	
	NSString *albumCateg;
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
- (void)postPerform {
	[super postPerform];
	statusStyle = UIStatusBarStyleLightContent;
}

- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		albumCateg = [dic objectForKey:kAYControllerChangeArgsKey];
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	skipedCount = 0;
	
	bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 303)];
	[self.view addSubview:bannerView];
	[self.view bringSubviewToFront:bannerView];
	UIImageView *cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 303)];
	
	NSString *coverImgName = [NSString stringWithFormat:@"album_content_bg_%ld", [kAY_home_album_titles indexOfObject:albumCateg]];
	cover.image = IMGRESOURCE(coverImgName);
	[bannerView addSubview:cover];
	
	UIView *navBar = [self.views objectForKey:kAYFakeNavBarView];
	UIView *statusBar = [self.views objectForKey:kAYFakeStatusBarView];
	
	navLeftBtn = [[UIButton alloc] init];
	[navLeftBtn setImage:IMGRESOURCE(@"bar_left_black") forState:UIControlStateNormal];
	[navLeftBtn setImage:IMGRESOURCE(@"bar_left_white") forState:UIControlStateSelected];
	[navBar addSubview:navLeftBtn];
	[navLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(navBar).offset(10.5);
		make.centerY.equalTo(navBar);
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	navLeftBtn.selected = YES;
	[navLeftBtn addTarget:self action:@selector(leftBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	bannerTitle = [UILabel creatLabelWithText:albumCateg textColor:[UIColor white] fontSize:317 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[navBar addSubview:bannerTitle];
	[bannerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(bannerView).offset(15);
//		make.top.equalTo(bannerView).offset(kStatusAndNavBarH+20);
		make.center.equalTo(navBar);
	}];
	
////	NSDictionary *shadowAttr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f],NSForegroundColorAttributeName :[UIColor white],NSShadowAttributeName:sdw};
//	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//	paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//	paraStyle.alignment = NSTextAlignmentLeft;
//	paraStyle.minimumLineHeight = 23;
//
//	NSDictionary *dic_attr = @{ NSParagraphStyleAttributeName:paraStyle,
//				  NSForegroundColorAttributeName:[UIColor white],
//				  NSFontAttributeName:[UIFont systemFontOfSize:15]
//				  };
//
//	NSAttributedString *countAttrStr = [[NSAttributedString alloc] initWithString:albumDesc attributes:dic_attr];
//
//
//	CGSize size = [countAttrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-SCREEN_MARGIN_LR*2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//	NSLog(@"%f-%f", size.width, size.height);
	
	
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	
	id<AYDelegateBase> delegate_found = [self.delegates objectForKey:@"TopicContent"];
	id obj = (id)delegate_found;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	obj = (id)delegate_found;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSArray *arr_cell_name = @[@"AYTopicDescCellView", @"AYTopicContentCellView"];
	for (NSString *cell_name in arr_cell_name) {
		id class_name = [cell_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name);
	}
	
	[self.view bringSubviewToFront:tableView];
	[self.view bringSubviewToFront:navBar];
	[self.view bringSubviewToFront:statusBar];
	
	NSString *albumDesc = [kAY_home_album_desc_dic objectForKey:albumCateg];
	NSDictionary *tmp = @{@"desc":albumDesc};
	kAYDelegatesSendMessage(@"TopicContent", kAYDelegateChangeDataMessage, &tmp)
	
//	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	
	[self loadNewData];
}

#pragma mark -- actions
- (void)loadNewData {
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData:user];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:albumCateg forKey:kAYServiceArgsAlbumInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
//	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLongLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		if (success) {
			remoteDataArr = [[result objectForKey:@"services"] mutableCopy];
			skipedCount = remoteDataArr.count;
			
			id tmp = @{kAYServiceArgsInfo:[remoteDataArr copy]};
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
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:albumCateg forKey:kAYServiceArgsCategoryInfo];
//	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
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
	view.backgroundColor = [UIColor colorWithWhite:1 alpha: 0];
//	view.alpha = 0;
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [UIColor colorWithWhite:1 alpha: 0];
//	view.alpha = 0;
	
	NSString *title = @"";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
//	view.layer.shadowColor = [Tools garyColor].CGColor;
//	view.layer.shadowOffset = CGSizeMake(0, 3);
//	view.layer.shadowOpacity = 0.25f;
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	view.backgroundColor = [UIColor clearColor];
//	((UITableView*)view).contentInset = UIEdgeInsetsMake(kCOLLECTIONVIEWTOP - kStatusAndNavBarH, 0, 0, 0);
	((UITableView*)view).estimatedRowHeight = 300;
	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
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

- (id)showHideDetail:(NSNumber*)args {
	UITableView *table = [self.views objectForKey:kAYTableView];
	kAYDelegatesSendMessage(@"TopicContent", @"TransfromExpend:", &args)
	[table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
	return nil;
}


- (id)willCollectWithRow:(id)args {
	
	NSDictionary *service_info = [args objectForKey:kAYServiceArgsInfo];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	//	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
	//	NSArray *resultArr = [serviceDataFound filteredArrayUsingPredicate:pre_id];
	//	if (resultArr.count != 1) {
	//		return nil;
	//	}
	//	id service_data = resultArr.firstObject;
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData:user];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:[service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
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
				//				[resultArr.firstObject setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
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
				//				[resultArr.firstObject setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	return nil;
}

#pragma scroll delegate
- (id)scrollViewDidScroll:(id)args {
	CGFloat offset_y = [args floatValue]+20;
	
	UIView *navBar = [self.views objectForKey:@"FakeNavBar"];
	UIView *statusBar = [self.views objectForKey:@"FakeStatusBar"];
	NSLog(@"offset_y : %f", offset_y);
	if (offset_y > 0 ) {
		
		CGFloat alp = ((60+kStatusBarH) - fabs(offset_y)) / (60+kStatusBarH);		// UP -> small
		if (alp > 0.7) {
			navLeftBtn.selected = YES;
			bannerTitle.textColor = [UIColor white];
			statusStyle = UIStatusBarStyleLightContent;
			[self setNeedsStatusBarAppearanceUpdate];
		} else if (alp < 0.7) {
			navLeftBtn.selected = NO;
			bannerTitle.textColor = [UIColor black];
			statusStyle = UIStatusBarStyleDefault;
			[self setNeedsStatusBarAppearanceUpdate];
		}
		else if (alp >= 1)
			alp = 1.f;
		NSLog(@"alp : %f", alp);
		
//		navBar.alpha = statusBar.alpha = 1 - alp;
		navBar.backgroundColor = statusBar.backgroundColor = [UIColor colorWithWhite:1 alpha: 1-alp];
		bannerView.alpha = alp;
	}
	
	return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	//	[self setNeedsStatusBarAppearanceUpdate];
	return statusStyle;
}

@end

