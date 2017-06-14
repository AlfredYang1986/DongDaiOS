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

#define kLIMITEDSHOWNAVBAR  (-70.5)
#define kFlexibleHeight     250
#define kBtmViewHeight       56
#define kChatBtnWidth				69
#define kBookBtnWidth			152
#define kBookBtnTitleNormal  @"查看可预订时间"
#define kBookBtnTitleSeted  @"申请预订"

//#define CarouseNumb			

@implementation AYServicePageController {
    NSMutableDictionary *service_info;
    
    UIButton *shareBtn;
    CGFloat offset_y;
	BOOL isBlackLeftBtn;
	BOOL isStatusHide;
	NSNumber *cellMinY;
	
    UIButton *bar_like_btn;
    UIView *flexibleView;
	BOOL isChangeCollect;
	/****/
	UICollectionView *CarouselView;
	UIPageControl *pageControl;
	int carouselNumb;
	CGFloat HeadViewHeight;
	/****/
	
	UIButton *bookBtn;
//	UILabel *bookBtn;
	
	NSMutableArray *offer_date_mutable;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		isStatusHide = YES;
		
		NSMutableDictionary *tmp_args;
		cellMinY = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"cell_min_y"];
		if (cellMinY) {
			tmp_args = [[[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"service_info"] mutableCopy];
		} else {
			tmp_args = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
		}
			
		id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
		id<AYCommand> cmd = [facade.commands objectForKey:@"ParseServiceTMProtocol"];
		id args = [tmp_args objectForKey:@"tms"];
		[cmd performWithResult:&args];
		
		[tmp_args setValue:[args copy] forKey:kAYServiceArgsOfferDate];
		service_info = tmp_args;
		
		carouselNumb = (int)((NSArray*)[service_info objectForKey:@"images"]).count;
		
		offer_date_mutable = [args mutableCopy];
		[offer_date_mutable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSArray *occurance = [obj objectForKey:kAYServiceArgsOccurance];
			[occurance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				[obj setValue:[NSNumber numberWithBool:NO] forKey:@"is_selected"];
			}];
		}];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        offer_date_mutable = [dic objectForKey:kAYControllerChangeArgsKey];
    }
}

#pragma mark --<UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return carouselNumb == 0 ? 1 : carouselNumb;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	AYServiceImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYServiceImagesCell" forIndexPath:indexPath];
	
	NSArray *images = [service_info objectForKey:@"images"];
	if (images.count != 0) {
		if ([[images firstObject] isKindOfClass:[NSString class]]) {
			
			id<AYFacadeBase> f_load = DEFAULTFACADE(@"FileRemote");
			AYRemoteCallCommand* cmd_load = [f_load.commands objectForKey:@"DownloadUserFiles"];
			NSString *PRE = cmd_load.route;
			[cell setItemImageWithImageName:[NSString stringWithFormat:@"%@%@", PRE, [images objectAtIndex:indexPath.row]]];
			
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
//	[self setNeedsStatusBarAppearanceUpdate];
	
	HeadViewHeight = 250;
	
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServicePage"];
    
    id obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
    obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceTitleCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceOwnerInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceCapacityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceDescCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceFacilityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceNotiCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	/*********************************************/
	{
		id<AYViewBase> view_table = [self.views objectForKey:kAYTableView];
        UITableView *tableView = (UITableView*)view_table;
        flexibleView = [[UIView alloc]init];
        [tableView addSubview:flexibleView];
		
		if (cellMinY) {
			flexibleView.clipsToBounds = YES;
			flexibleView.frame = CGRectMake(20, -kFlexibleHeight + cellMinY.floatValue, SCREEN_WIDTH - 40, kFlexibleHeight);
			//		flexibleView.transform = CGAffineTransformMakeScale((SCREEN_WIDTH - 40)/SCREEN_WIDTH, 1.f);
		}else {
			[flexibleView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(tableView).offset(-kFlexibleHeight);
				make.centerX.equalTo(tableView);
				make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kFlexibleHeight));
			}];
		}
		
//		flexibleView.layer.shadowColor = [Tools garyColor].CGColor;
//		flexibleView.layer.shadowOffset = CGSizeMake(0, 3.f);
//		flexibleView.layer.shadowOpacity = 0.45f;
//		flexibleView.layer.shadowRadius = 3.f;
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.minimumLineSpacing = 0.f;
		layout.minimumInteritemSpacing = 0.f;
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		CarouselView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFlexibleHeight) collectionViewLayout:layout];
		CarouselView.backgroundColor = [UIColor clearColor];
		CarouselView.delegate = self;
		CarouselView.dataSource = self;
		[CarouselView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CarouselCell"];
		CarouselView.pagingEnabled = YES;
		CarouselView.showsHorizontalScrollIndicator = NO;
		CarouselView.showsVerticalScrollIndicator = NO;
		CarouselView.bounces = NO;
		[CarouselView registerClass:NSClassFromString(@"AYServiceImagesCell") forCellWithReuseIdentifier:@"AYServiceImagesCell"];
		[flexibleView addSubview:CarouselView];
		[CarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(flexibleView);
			make.width.mas_equalTo(SCREEN_WIDTH);
			make.height.equalTo(flexibleView);
		}];
		
		pageControl = [[UIPageControl alloc]init];
		pageControl.numberOfPages = carouselNumb;
		CGSize size = [pageControl sizeForNumberOfPages:carouselNumb];
		pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.f alpha:0.75f];
		pageControl.currentPageIndicatorTintColor = [Tools themeColor];
		[flexibleView addSubview:pageControl];
		[pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(flexibleView).offset(-10);
			make.centerX.equalTo(flexibleView);
			make.size.mas_equalTo(size);
		}];
		pageControl.hidden = carouselNumb == 1;
		
        UIImageView *topMaskVeiw = [[UIImageView alloc]init];
        topMaskVeiw.image = IMGRESOURCE(@"service_page_mask");
		topMaskVeiw.contentMode = UIViewContentModeTopLeft;
        topMaskVeiw.userInteractionEnabled = NO;
        [flexibleView addSubview:topMaskVeiw];
        [topMaskVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(flexibleView);
            make.centerX.equalTo(flexibleView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 78.5));
        }];
		
        BOOL isLike = ((NSNumber*)[service_info objectForKey:kAYServiceArgsIsCollect]).boolValue;
		bar_like_btn.selected = isLike;
    }
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"ServicePage"];
    id<AYCommand> cmd_change_data = [cmd_notify.commands objectForKey:@"changeQueryData:"];
    NSDictionary *tmp = [service_info copy];
    [cmd_change_data performWithResult:&tmp];
    
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
	id<AYViewBase> statusBar = [self.views objectForKey:@"FakeStatusBar"];
    [self.view bringSubviewToFront:(UIView*)navBar];
	[self.view bringSubviewToFront:(UIView*)statusBar];
    ((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
	
	/***************************************/
    NSNumber *per_mode = [service_info objectForKey:@"perview_mode"];
    if (!per_mode) {
        UIView *bottom_view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBtmViewHeight, SCREEN_WIDTH, kBtmViewHeight)];
        bottom_view.backgroundColor = [Tools whiteColor];
		bottom_view.layer.shadowColor = [Tools garyColor].CGColor;
		bottom_view.layer.shadowOffset = CGSizeMake(0, -0.5);
		bottom_view.layer.shadowOpacity = 0.4f;
        [self.view addSubview:bottom_view];
        [self.view bringSubviewToFront:bottom_view];
		
		[Tools creatCALayerWithFrame:CGRectMake(kChatBtnWidth, 0, 0.5, kBtmViewHeight) andColor:[Tools garyLineColor] inSuperView:bottom_view];
		
		UIButton *chatBtn = [[UIButton alloc]init];
		[chatBtn setImage:IMGRESOURCE(@"service_chat") forState:UIControlStateNormal];
		[chatBtn setTitle:@"沟通" forState:UIControlStateNormal];
		chatBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
		[chatBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
		[chatBtn setImageEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, -24)];
		[chatBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, -31, 0)];
		[chatBtn addTarget:self action:@selector(didChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[bottom_view addSubview:chatBtn];
		[chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bottom_view);
			make.top.equalTo(bottom_view);
			make.size.mas_equalTo(CGSizeMake(kChatBtnWidth, kBtmViewHeight));
		}];
		
		NSString *unitCat;
		NSNumber *leastTimesOrHours;
		NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
		if (service_cat.intValue == ServiceTypeNursery) {
			unitCat = @"小时";
			leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastHours];
		}else if (service_cat.intValue == ServiceTypeCourse) {
			unitCat = @"次";
			leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastTimes];
		} else {
			NSLog(@"---null---");
			unitCat = @"单价";
			leastTimesOrHours = @1;
		}
		NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
		NSString *tmp = [NSString stringWithFormat:@"%@", price];
		int length = (int)tmp.length;
		NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
		
		NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
		[attributedText setAttributes:@{NSFontAttributeName:kAYFontMedium(18.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f], NSForegroundColorAttributeName :[Tools garyColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
		
		UILabel *priceLabel = [Tools creatUILabelWithText:@"Price 0f Serv" andTextColor:[Tools blackColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[bottom_view addSubview:priceLabel];
		[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(chatBtn.mas_right).offset((SCREEN_WIDTH - kBookBtnWidth - kChatBtnWidth) * 0.5);
			make.bottom.equalTo(bottom_view.mas_centerY).offset(2);
		}];
		
		UILabel *capacityLabel = [Tools creatUILabelWithText:@"MIN Book Times" andTextColor:[Tools garyColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[bottom_view addSubview:capacityLabel];
		[capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(bottom_view.mas_centerY).offset(4);
			make.left.equalTo(priceLabel);
		}];
		
		priceLabel.attributedText = attributedText;
		capacityLabel.text = [NSString stringWithFormat:@"最少预定%@%@", leastTimesOrHours, unitCat];
		
        bookBtn = [Tools creatUIButtonWithTitle:kBookBtnTitleNormal andTitleColor:[Tools whiteColor] andFontSize:615.f andBackgroundColor:[Tools themeColor]];
		UIImage *bgimage = IMGRESOURCE(@"details_button_checktime");
		bookBtn.layer.contents = (__bridge id _Nullable)(bgimage.CGImage);
        [bookBtn addTarget:self action:@selector(didBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
        [bottom_view addSubview:bookBtn];
		[bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(bottom_view);
			make.right.equalTo(bottom_view);
			make.size.mas_equalTo(CGSizeMake(kBookBtnWidth, kBtmViewHeight));
		}];
    }
    else {
        bar_like_btn.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (cellMinY) {
		[UIView animateWithDuration:0.25 animations:^{
			flexibleView.frame = CGRectMake(0, -kFlexibleHeight, SCREEN_WIDTH, kFlexibleHeight);
		}completion:^(BOOL finished) {
			flexibleView.clipsToBounds = NO;
		}];
	}
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
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
    
    AYViewController* comp = DEFAULTCONTROLLER(@"TabBar");
    BOOL isNap = ![self.tabBarController isKindOfClass:[comp class]];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (isNap ? 0 : kBtmViewHeight));
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(kFlexibleHeight, 0, 0, 0);
    ((UITableView*)view).estimatedRowHeight = 300;
    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	if (isChangeCollect) {
		NSDictionary *back_args = @{@"args":service_info, @"key":@"is_change_collect"};
		[dic setValue:back_args forKey:kAYControllerChangeArgsKey];
	}
	
	id<AYCommand> cmd = POP;
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
        [flexibleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tableView);
            make.top.equalTo(tableView).offset(-kFlexibleHeight + offsetH);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kFlexibleHeight - offsetH));
        }];
		HeadViewHeight = kFlexibleHeight - offsetH;
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
- (void)didBookBtnClick {
	[self showServiceOfferDate];
}

- (void)didChatBtnClick:(UIButton*)btn{
    NSDictionary* user = nil;
    CURRENUSER(user);
	
    NSString *user_id = [user objectForKey:@"user_id"];
    NSString *owner_id = [service_info objectForKey:@"owner_id"];
    if ([user_id isEqualToString:owner_id]) {
        NSString *title = @"该服务是您自己发布";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
    
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
    
    NSDictionary *info = nil;
    CURRENUSER(info);
    
    NSMutableDictionary *dic = [info mutableCopy];
    [dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    
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
