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

#import "AYAssortmentItemView.h"
#define kCOLLECTIONVIEWTOP 205.f

@implementation AYAssortmentController {
	UIStatusBarStyle statusStyle;
	
	UICollectionView *servCollectionView;
	NSArray *serviceData;
	
	UIView *bannerView;
	UILabel *bannerTitle;
	UILabel *bannerCount;
	UIButton *navLeftBtn;
	
	UILabel *navTitleLabel;
	UILabel *navCountLabel;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 8;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYAssortmentItemView *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYAssortmentItemView" forIndexPath:indexPath];
	
	return item;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCOLLECTIONVIEWTOP + 30)];
	[self.view addSubview:bannerView];
	[self.view bringSubviewToFront:bannerView];
//	[servCollectionView addSubview:bannerView];
	UIImageView *cover = [[UIImageView alloc] initWithFrame:bannerView.bounds];
	cover.image = IMGRESOURCE(@"version_nav_cover_0");
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
	
	bannerTitle = [Tools creatUILabelWithText:@"# The Assortment Title #" andTextColor:[Tools whiteColor] andFontSize:622.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[bannerView addSubview:bannerTitle];
	[bannerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(bannerView);
		make.top.equalTo(bannerView).offset(75);
	}];
	
	bannerCount = [Tools creatUILabelWithText:@"Assortment count" andTextColor:[Tools whiteColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[bannerView addSubview:bannerCount];
	[bannerCount mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(bannerView);
		make.top.equalTo(bannerTitle.mas_bottom).offset(15);
	}];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	layout.itemSize = CGSizeMake((SCREEN_WIDTH - 28)*0.5, 250);
	layout.minimumInteritemSpacing = 8.f;
	layout.minimumLineSpacing = 8.f;
	
	servCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, kStatusAndNavBarH, SCREEN_WIDTH - 20, SCREEN_HEIGHT-kStatusAndNavBarH) collectionViewLayout:layout];
	servCollectionView.delegate = self;
	servCollectionView.dataSource = self;
	servCollectionView.backgroundColor = [UIColor clearColor];
	servCollectionView.showsVerticalScrollIndicator = NO;
	servCollectionView.contentInset = UIEdgeInsetsMake(kCOLLECTIONVIEWTOP - kStatusAndNavBarH, 0, 0, 0);
	[self.view addSubview:servCollectionView];
	[servCollectionView registerClass:NSClassFromString(@"AYAssortmentItemView") forCellWithReuseIdentifier:@"AYAssortmentItemView"];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
	
	NSString *title = @"热门分类001";
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
//	UIImage* left = IMGRESOURCE(@"bar_left_black");
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	navTitleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools blackColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[view addSubview:navTitleLabel];
	[navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(view.mas_centerY).offset(0);
		make.centerX.equalTo(view);
	}];
	
	navCountLabel = [Tools creatUILabelWithText:@"service count" andTextColor:[Tools blackColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[view addSubview:navCountLabel];
	[navCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(view.mas_centerY).offset(0);
		make.centerX.equalTo(view);
	}];
	
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
	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat offset_y = scrollView.contentOffset.y;
	
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
}

- (UIStatusBarStyle)preferredStatusBarStyle {
//	[self setNeedsStatusBarAppearanceUpdate];
	return statusStyle;
}

@end
