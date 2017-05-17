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

#define kLIMITEDSHOWNAVBAR  (-70.5)
#define kFlexibleHeight     250
#define btmViewHeight       70
#define bookBtnTitleNormal  @"查看可预约时间"
#define bookBtnTitleSeted  @"申请预订"

//#define CarouseNumb			

@implementation AYServicePageController {
    NSMutableDictionary *service_info;
    
    UIButton *shareBtn;
    CGFloat offset_y;
	BOOL isBlackLeftBtn;
	
    UIButton *bar_like_btn;
    UIView *flexibleView;
	
	/****/
	UICollectionView *CarouselView;
	UIPageControl *pageControl;
	int carouselNumb;
	CGFloat HeadViewHeight;
	/****/
	
//	UIButton *bookBtn;
	UILabel *bookBtn;
	
	NSMutableArray *offer_date_mutable;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		NSMutableDictionary *tmp_args = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
		id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
		id<AYCommand> cmd = [facade.commands objectForKey:@"ParseServiceTMProtocol"];
		id args = [tmp_args objectForKey:@"tms"];
		[cmd performWithResult:&args];
		
		[tmp_args setValue:[args copy] forKey:kAYServiceArgsOfferDate];
		service_info = [tmp_args copy];
		
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
//		bookBtn.text = bookBtnTitleSeted;
    }
}

#pragma mark --<UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return carouselNumb == 0 ? 1 : carouselNumb;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarouselCell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	[cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	UIImageView *tipView = [[UIImageView alloc]init];
	tipView.contentMode = UIViewContentModeScaleAspectFill;
	NSArray *images = [service_info objectForKey:@"images"];
	if (images.count != 0) {
		if ([[images firstObject] isKindOfClass:[NSString class]]) {
			
			id<AYFacadeBase> f_load = DEFAULTFACADE(@"FileRemote");
			AYRemoteCallCommand* cmd_load = [f_load.commands objectForKey:@"DownloadUserFiles"];
			NSString *PRE = cmd_load.route;
			[tipView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PRE, [images objectAtIndex:indexPath.row]]] placeholderImage:IMGRESOURCE(@"default_image")];
			
		} else {
			
			tipView.image = [images objectAtIndex:indexPath.row];
		}
		
	} else
		tipView.image = IMGRESOURCE(@"default_image");
	
	[cell addSubview:tipView];
	tipView.frame = cell.bounds;
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
	
	HeadViewHeight = 250;
	
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServicePage"];
    
    id obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
    obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceTitleCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceDescCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceCalendarCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceNotiCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	/*********************************************/
	{
		id<AYViewBase> view_table = [self.views objectForKey:kAYTableView];
        UITableView *tableView = (UITableView*)view_table;
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
		[flexibleView addSubview:CarouselView];
		[CarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(flexibleView);
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
        
        UIView *bottom_view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - btmViewHeight, SCREEN_WIDTH, btmViewHeight)];
        bottom_view.backgroundColor = [Tools whiteColor];
		bottom_view.layer.shadowColor = [Tools garyColor].CGColor;
		bottom_view.layer.shadowOffset = CGSizeMake(0, -0.5);
		bottom_view.layer.shadowOpacity = 0.4f;
        [self.view addSubview:bottom_view];
        [self.view bringSubviewToFront:bottom_view];
		
//		[Tools creatCALayerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) andColor:[Tools garyLineColor] inSuperView:bottom_view];
		[Tools creatCALayerWithFrame:CGRectMake(90, 0, 0.5, btmViewHeight) andColor:[Tools garyLineColor] inSuperView:bottom_view];
		
		UIButton *chatBtn = [[UIButton alloc]init];
		[chatBtn setImage:IMGRESOURCE(@"service_chat") forState:UIControlStateNormal];
		[chatBtn setTitle:@"沟通" forState:UIControlStateNormal];
		chatBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12.f];
		[chatBtn setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
		[chatBtn setTitleEdgeInsets:UIEdgeInsetsMake(29, -27, 0, 0)];
		[chatBtn setImageEdgeInsets:UIEdgeInsetsMake(-25, 23, 0, 0)];
		[chatBtn addTarget:self action:@selector(didChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[bottom_view addSubview:chatBtn];
		[chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bottom_view);
			make.top.equalTo(bottom_view);
			make.size.mas_equalTo(CGSizeMake(90, 80));
		}];
		
		UILabel *priceLabel = [Tools creatUILabelWithText:@"服务价格" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[bottom_view addSubview:priceLabel];
		[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bottom_view).offset(115);
			make.bottom.equalTo(bottom_view.mas_centerY).offset(0);
		}];
		
		UILabel *capacityLabel = [Tools creatUILabelWithText:@"服务最少预定" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[bottom_view addSubview:capacityLabel];
		[capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(bottom_view.mas_centerY).offset(4);
			make.left.equalTo(priceLabel);
		}];
		
		NSString *unitCat;
		NSNumber *leastTimesOrHours;
		NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
		if (service_cat.intValue == ServiceTypeNursery) {
			unitCat = @"小时";
			leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastHours];
			
		}
		else if (service_cat.intValue == ServiceTypeCourse) {
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
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
		[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(14.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
		priceLabel.attributedText = attributedText;
		
		capacityLabel.text = [NSString stringWithFormat:@"最少预定%@%@", leastTimesOrHours, unitCat];
		
//        bookBtn = [Tools creatUIButtonWithTitle:bookBtnTitleNormal andTitleColor:[Tools whiteColor] andFontSize:315.f andBackgroundColor:[Tools themeColor]];
//		bookBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//		[Tools setViewBorder:bookBtn withRadius:2.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
//        [bookBtn addTarget:self action:@selector(didBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		
		bookBtn = [Tools creatUILabelWithText:bookBtnTitleNormal andTextColor:[Tools whiteColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:bookBtn withRadius:2.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeColor]];
		bookBtn.userInteractionEnabled = YES;
		[bookBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBookBtnClick:)]];
        [bottom_view addSubview:bookBtn];
		[bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(bottom_view);
			make.left.equalTo(bottom_view).offset(215);
			make.right.equalTo(bottom_view).offset(-20);
			make.height.equalTo(@44);
		}];
		
		if (SCREEN_WIDTH < 375) {
			bookBtn.font = [UIFont systemFontOfSize:13.f];
			[bookBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(bottom_view);
				make.left.equalTo(bottom_view).offset(205);
				make.right.equalTo(bottom_view).offset(-15);
				make.height.equalTo(@44);
			}];
		}
		
    }
    else {
        bar_like_btn.hidden = YES;
    }
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
//    NSString *title = @"服务详情";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_white");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    id right = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right)
	
    bar_like_btn = [[UIButton alloc]init];
    [bar_like_btn setImage:IMGRESOURCE(@"heart_unlike") forState:UIControlStateNormal];
    [bar_like_btn setImage:IMGRESOURCE(@"heart") forState:UIControlStateSelected];
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
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (isNap ? 0 : btmViewHeight));
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(kFlexibleHeight, 0, 0, 0);
    ((UITableView*)view).estimatedRowHeight = 300;
    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)sendPopMessage {
    [self leftBtnSelected];
    return nil;
}

-(id)scrollOffsetY:(NSNumber*)y {
    offset_y = y.floatValue;
//    [self setNeedsStatusBarAppearanceUpdate];
	
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
	id<AYViewBase> statusBar = [self.views objectForKey:@"FakeStatusBar"];
	
    if (offset_y <= -kStatusAndNavBarH && offset_y >= -kStatusAndNavBarH*2) { //偏移的绝对值 小于 abs(-64)
		
		CGFloat alp = (kStatusAndNavBarH*2 + offset_y)/(kStatusAndNavBarH);
//		NSLog(@"(64*2 + %f) / 64 = %f",offset_y, alp);
		if (alp > 0.5 && !isBlackLeftBtn) {
			UIImage* left = IMGRESOURCE(@"bar_left_black");
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
			isBlackLeftBtn = YES;
		} else if (alp <  0.5 && isBlackLeftBtn) {
			UIImage* left = IMGRESOURCE(@"bar_left_white");
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
			isBlackLeftBtn = NO;
		}
		((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:alp];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarHideBarBotLineMessage, nil)
		
	} else if (offset_y < - kStatusAndNavBarH * 2) {
		((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
	} else {
		((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
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
	[dic_p2p setValue:[service_info objectForKey:kAYServiceArgsLocation] forKey:@"2p"];
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

- (id)showMoreOrHideDescription:(NSNumber*)args {
	UITableView *table = [self.views objectForKey:@"Table"];
    [table beginUpdates];
	kAYDelegatesSendMessage(@"ServicePage", @"TransfromExpend:", &args)
    [table endUpdates];
    return nil;
}

#pragma mark -- actions
- (void)didPOPClick {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
}

- (void)didBookBtnClick:(UITapGestureRecognizer*)tap {
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
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    
    if (!bar_like_btn.selected) {
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
                bar_like_btn.selected = YES;
            } else {
                NSString *title = @"收藏失败!请检查网络链接是否正常";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }else {
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
                bar_like_btn.selected = NO;
            } else {
                NSString *title = @"取消收藏失败!请检查网络链接是否正常";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleDefault;
}

@end