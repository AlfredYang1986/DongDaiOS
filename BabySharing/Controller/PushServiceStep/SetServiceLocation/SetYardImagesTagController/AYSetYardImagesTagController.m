//
//  AYSetYardImagesTagController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetYardImagesTagController.h"

#import "AYCourseSignView.h"

@implementation AYSetYardImagesTagController {
	NSArray *imagesData;
	NSInteger pageIndex;
	
	NSArray *tagArr;
	NSMutableArray *tagViewArr;
	AYCourseSignView *tmpTagView;
	
	NewPagedFlowView *pageFlowView;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		imagesData = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:kAYServiceArgsYardImages];
		pageIndex = [[[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"index"] integerValue];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"场地图片标签" andTextColor:[Tools blackColor] andFontSize:622.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(40);
	}];
	
	pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*144/667, SCREEN_WIDTH, 200)];
	pageFlowView.delegate = self;
	pageFlowView.dataSource = self;
	pageFlowView.minimumPageAlpha = 0.5;
	pageFlowView.isCarousel = YES;
	pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
	pageFlowView.isOpenAutoScroll = NO;
	
	//初始化pageControl
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, SCREEN_WIDTH, 8)];
	pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
	pageControl.currentPageIndicatorTintColor = [Tools themeColor];
	pageFlowView.pageControl = pageControl;
	[pageFlowView addSubview:pageControl];
	[pageFlowView reloadData];
	
	[self.view addSubview:pageFlowView];
	[pageFlowView scrollToPage:pageIndex];
	
	tagViewArr = [NSMutableArray array];
	tagArr = @[@"家长休息区", @"阅读区", @"教学区", @"生活区", @"寄存区", @"户外区"];
	int row = 0, col = 0;
	int colInRow = 3;
	CGFloat margin = 16;
	CGFloat itemWith = (SCREEN_WIDTH - 80 - margin*(colInRow-1)) / colInRow;
	CGFloat itemHeight = 33;
	for (int i = 0; i < tagArr.count; ++i) {
		row = i / colInRow;
		col = i % colInRow;
		AYCourseSignView *signView = [[AYCourseSignView alloc] initWithFrame:CGRectMake(40+col*(margin+itemWith), SCREEN_HEIGHT*430/667 +row*(margin+itemHeight), itemWith, itemHeight) andTitle:[tagArr objectAtIndex:i]];
		[self.view addSubview:signView];
		signView.tag = i;
		signView.userInteractionEnabled = YES;
		[signView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagViewTap:)]];
		
		if ([[imagesData[pageIndex] objectForKey:kAYServiceArgsTag] isEqualToString:[tagArr objectAtIndex:i]]) {
			[signView setSelectStatus];
			tmpTagView = signView;
		}
		[tagViewArr addObject:signView];
	}
	
}

#pragma mark -- actios
- (void)didTagViewTap:(UITapGestureRecognizer*)tap {
	AYCourseSignView *tapView = (AYCourseSignView*)tap.view;
	if (tapView == tmpTagView) {
		return;
	}
	NSString *key = tapView.sign;
	NSInteger currentIndex= [pageFlowView currentPageIndex];
	[imagesData[currentIndex] setValue:key forKey:kAYServiceArgsTag];
	
	[tapView setSelectStatus];
	[tmpTagView setUnselectStatus];
	tmpTagView = tapView;
	
	if ([self isAllTagDone]) {
		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:616.f andBackgroundColor:nil];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	}
}

- (BOOL)isAllTagDone {
	int count = 0;
	for (NSDictionary *info in imagesData) {
		if ([info objectForKey:kAYServiceArgsTag]) {
			count ++;
		}
	}
	return count >= imagesData.count;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
	return CGSizeMake(SCREEN_WIDTH - 80, 200);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
	NSLog(@"点击了第%ld张图",(long)subIndex);
	
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
	NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
	NSString *tag = [imagesData[pageNumber] objectForKey:kAYServiceArgsTag];
	if (tag.length != 0) {
		AYCourseSignView *currentView = [tagViewArr objectAtIndex:[tagArr indexOfObject:tag]];
		[currentView setSelectStatus];
		[tmpTagView setUnselectStatus];
		tmpTagView = currentView;
	} else {
		[tmpTagView setUnselectStatus];
		tmpTagView = nil;
	}
	
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
	return imagesData.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
	PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
	if (!bannerView) {
		bannerView = [[PGIndexBannerSubiew alloc] init];
		bannerView.tag = index;
		bannerView.layer.cornerRadius = 4;
		bannerView.layer.masksToBounds = YES;
	}
	//在这里下载网络图片
	//	[bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
	
	id image = [imagesData[index] objectForKey:kAYServiceArgsPic];
	if ([image isKindOfClass:[NSString class]]) {
		[bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, image]] placeholderImage:[UIImage imageNamed:@"default_image"] options:SDWebImageLowPriority];
	} else if ([image isKindOfClass:[UIImage class]]) {
		bannerView.mainImageView.image = image;
	}
	
	return bannerView;
}

#pragma mark -- notification
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_img_tag = [[NSMutableDictionary alloc] init];
	[dic_img_tag setValue:[imagesData copy] forKey:kAYServiceArgsYardImages];
	[dic setValue:[dic_img_tag copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

@end