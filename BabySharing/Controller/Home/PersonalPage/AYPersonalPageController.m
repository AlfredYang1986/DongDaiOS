//
//  AYPersonalPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalPageController.h"
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
#define btmViewHeight       80

@implementation AYPersonalPageController {
    NSDictionary *service_info;
    
    UIButton *shareBtn;
    UIButton *collectionBtn;
    UIButton *unCollectionBtn;
    CGFloat offset_y;
    
    UIButton *bar_unlike_btn;
    UIButton *bar_like_btn;
    
    UIView *flexibleView;
    SDCycleScrollView *cycleScrollView;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    UILabel *secret = [Tools creatUILabelWithText:@"有温度的儿童主题看顾社区" andTextColor:[UIColor colorWithWhite:0.88 alpha:1.f] andFontSize:12.f andBackgroundColor:nil andTextAlignment:1];
//    [self.view addSubview:secret];
//    [self.view sendSubviewToBack:secret];
//    [secret mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(28);
//        make.centerX.equalTo(self.view);
//    }];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServicePage"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_class = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name_00 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceTitleCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&class_name_00];
    
    NSString* class_name_01 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceDescCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&class_name_01];
    
    NSString* class_name_02 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&class_name_02];
    
    NSString* class_name_03 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceFacilityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&class_name_03];
    
    NSString* class_name_04 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&class_name_04];
    
    NSString* class_name_05 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceCalendarCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&class_name_05];
    
    NSString* class_name_06 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceNotiCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&class_name_06];
    
    {
        UITableView *tableView = (UITableView*)view_table;
        flexibleView = [[UIView alloc]init];
        [tableView addSubview:flexibleView];
        [flexibleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableView).offset(-kFlexibleHeight);
            make.centerX.equalTo(tableView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kFlexibleHeight));
        }];
        
        NSArray *images = [service_info objectForKey:@"images"];
        if ([[images firstObject] isKindOfClass:[NSString class]]) {
            
            id<AYFacadeBase> f_load = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd_load = [f_load.commands objectForKey:@"DownloadUserFiles"];
            NSString *PRE = cmd_load.route;
            NSMutableArray *tmp = [NSMutableArray array];
            for (int i = 0; i < images.count; ++i) {
                NSString *obj = images[i];
                obj = [PRE stringByAppendingString:obj];
                [tmp addObject:obj];
            }
            
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFlexibleHeight) delegate:self placeholderImage:IMGRESOURCE(@"default_image")];
            cycleScrollView.imageURLStringsGroup = [tmp copy];
        } else {
            
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFlexibleHeight) shouldInfiniteLoop:YES imageNamesGroup:[service_info objectForKey:@"images"]];
            cycleScrollView.localizationImageNamesGroup = [service_info objectForKey:@"images"];
            cycleScrollView.delegate = self;
        }
        
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.currentPageDotColor = [Tools themeColor];
        cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        [flexibleView addSubview:cycleScrollView];
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.autoScrollTimeInterval = 99999.0;   //99999秒 滚动一次 ≈ 不自动滚动
//        [cycleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(flexibleView);
//        }];
		
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
        
        UIButton *popImage = [[UIButton alloc]init];
        [popImage setImage:IMGRESOURCE(@"bar_left_white") forState:UIControlStateNormal];
        [flexibleView addSubview:popImage];
        [popImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(flexibleView).offset(12);
            make.top.equalTo(flexibleView).offset(25);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [popImage addTarget:self action:@selector(didPOPClick) forControlEvents:UIControlEventTouchUpInside];
        
        collectionBtn = [[UIButton alloc]init];
        [collectionBtn setImage:IMGRESOURCE(@"bar_unlike_btn") forState:UIControlStateNormal];
        [collectionBtn setImage:IMGRESOURCE(@"bar_like_btn") forState:UIControlStateSelected];
        [flexibleView addSubview:collectionBtn];
        [flexibleView bringSubviewToFront:collectionBtn];
        [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(flexibleView).offset(-35);
            make.centerY.equalTo(popImage);
            make.size.mas_equalTo(CGSizeMake(27, 27));
        }];
        [collectionBtn addTarget:self action:@selector(didCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL isLike = ((NSNumber*)[service_info objectForKey:kAYServiceArgsIsCollect]).boolValue;
        bar_like_btn.selected = collectionBtn.selected = isLike;
        
//        UILabel *costLabel = [Tools creatUILabelWithText:@"Service Price" andTextColor:[Tools whiteColor] andFontSize:16.f andBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.6f] andTextAlignment:NSTextAlignmentCenter];
//        [flexibleView addSubview:costLabel];
//        [costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(flexibleView);
//            make.bottom.equalTo(flexibleView).offset(-15);
//            make.size.mas_equalTo(CGSizeMake(125, 35));
//        }];
//        costLabel.text = [NSString stringWithFormat:@"¥ %.f／小时",((NSString*)[service_info objectForKey:@"price"]).floatValue];
    }
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"ServicePage"];
    id<AYCommand> cmd_change_data = [cmd_notify.commands objectForKey:@"changeQueryData:"];
    NSDictionary *tmp = [service_info copy];
    [cmd_change_data performWithResult:&tmp];
    
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
    [self.view bringSubviewToFront:(UINavigationBar*)navBar];
    ((UINavigationBar*)navBar).alpha = 0;
    
    /*
     shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:IMGRESOURCE(@"service_share") forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    [self.view bringSubviewToFront:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.view.mas_top).offset(kFlexibleHeight);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    [shareBtn addTarget:self action:@selector(didShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    NSNumber *per_mode = [service_info objectForKey:@"perview_mode"];
    if (!per_mode) {
        
        UIView *bottom_view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - btmViewHeight, SCREEN_WIDTH, btmViewHeight)];
        bottom_view.backgroundColor = [Tools whiteColor];
        [self.view addSubview:bottom_view];
        [self.view bringSubviewToFront:bottom_view];
		
		[Tools creatCALayerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) andColor:[Tools garyLineColor] inSuperView:bottom_view];
		[Tools creatCALayerWithFrame:CGRectMake(90, 0, 1, btmViewHeight) andColor:[Tools garyLineColor] inSuperView:bottom_view];
		
		UIButton *chatBtn = [[UIButton alloc]init];
		[chatBtn setImage:IMGRESOURCE(@"service_chat") forState:UIControlStateNormal];
		[chatBtn setTitle:@"沟通" forState:UIControlStateNormal];
		chatBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.f];
		[chatBtn setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
		[chatBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, -27, 0, 0)];
		[chatBtn setImageEdgeInsets:UIEdgeInsetsMake(-25, 31, 0, 0)];
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
			make.bottom.equalTo(bottom_view.mas_centerY).offset(-2);
		}];
		
		UILabel *capacityLabel = [Tools creatUILabelWithText:@"服务最少预定" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[bottom_view addSubview:capacityLabel];
		[capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(bottom_view.mas_centerY).offset(2);
			make.left.equalTo(priceLabel);
		}];
		
		NSString *unitCat;
		NSNumber *leastTimesOrHours;
		NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
		if (service_cat.intValue == ServiceTypeLookAfter) {
			unitCat = @"小时";
			leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastHours];
			
		}
		else if (service_cat.intValue == ServiceTypeCourse) {
			unitCat = @"次";
			leastTimesOrHours = [service_info objectForKey:kAYServiceArgsLeastTimes];
			
		} else {
			
			NSLog(@"---null---");
			unitCat = @"单价";
			leastTimesOrHours = @0;
		}
		NSNumber *price = [service_info objectForKey:kAYServiceArgsPrice];
		NSString *tmp = [NSString stringWithFormat:@"%@", price];
		int length = (int)tmp.length;
		NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, unitCat];
		
		NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, length+1)];
		[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
		priceLabel.attributedText = attributedText;
		
		capacityLabel.text = [NSString stringWithFormat:@"最少预定%@%@", leastTimesOrHours, unitCat];
		
        UIButton *bookBtn = [Tools creatUIButtonWithTitle:@"申请预订" andTitleColor:[Tools whiteColor] andFontSize:-14.f andBackgroundColor:[Tools themeColor]];
		[Tools setViewRadius:bookBtn withRadius:2.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
        [bookBtn addTarget:self action:@selector(didBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottom_view addSubview:bookBtn];
		[bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(bottom_view);
			make.left.equalTo(bottom_view).offset(215);
			make.right.equalTo(bottom_view).offset(-20);
			make.height.equalTo(@44);
		}];
		
    }
    else {
        bar_like_btn.hidden = collectionBtn.hidden = YES;
    }
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"服务详情";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    id right = [NSNumber numberWithBool:YES];
    [cmd_right performWithResult:&right];
    /*
    UIButton *bar_share_btn = [[UIButton alloc]init];
    [bar_share_btn setImage:IMGRESOURCE(@"bar_share_btn") forState:UIControlStateNormal];
    [view addSubview:bar_share_btn];
    [bar_share_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-35);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(23, 24));
    }];
    [bar_share_btn addTarget:self action:@selector(didShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *speart = [[UIView alloc]init];
    speart.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.f];
    [view addSubview:speart];
    [speart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bar_share_btn.mas_left).offset(-24);
        make.centerY.equalTo(bar_share_btn);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    */
    bar_like_btn = [[UIButton alloc]init];
    [bar_like_btn setImage:IMGRESOURCE(@"bar_unlike_btn") forState:UIControlStateNormal];
    [bar_like_btn setImage:IMGRESOURCE(@"bar_like_btn") forState:UIControlStateSelected];
    [bar_like_btn addTarget:self action:@selector(didCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bar_like_btn];
    [bar_like_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-35);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusBar.backgroundColor = [UIColor whiteColor];
    [view addSubview:statusBar];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
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

-(id)sendPopMessage {
    [self leftBtnSelected];
    return nil;
}

-(id)scrollOffsetY:(NSNumber*)y {
    offset_y = y.floatValue;
//    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
    
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
    [self.view bringSubviewToFront:(UINavigationBar*)navBar];
    if (offset_y > kLIMITEDSHOWNAVBAR) { //偏移的绝对值 小于 abs(-75)
        
        [UIView animateWithDuration:0.5 animations:^{
            ((UINavigationBar*)navBar).alpha = 1.f;
        }];
        
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            ((UINavigationBar*)navBar).alpha = 0;
        }];
    }
    
//    CGFloat offsetH = kFlexibleHeight + offset_y;
//    if (offsetH < 0) {
//        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
//        UITableView *tableView = (UITableView*)view_notify;
//        [flexibleView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(tableView);
//            make.top.equalTo(tableView).offset(-kFlexibleHeight + offsetH);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kFlexibleHeight - offsetH));
//        }];
//    }
    
    /*[shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.view.mas_top).offset(- offset_y);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];*/
//    [collectionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(shareBtn.mas_left).offset(-20);
//        make.centerY.equalTo(shareBtn);
//        make.size.equalTo(shareBtn);
//    }];
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
    
    id<AYCommand> setting = DEFAULTCONTROLLER(@"CalendarService");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
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

- (void)didBookBtnClick:(UIButton*)btn{
    /**
     * 1. cannot order owner service
     */
    NSDictionary* user = nil;
    CURRENPROFILE(user);
    NSString *user_id = [user objectForKey:@"user_id"];
    NSString *owner_id = [service_info objectForKey:@"owner_id"];
    if ([user_id isEqualToString:owner_id]) {
        
        NSString *title = @"该服务是您自己发布";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
   
    /**
     * 2. check profile has_phone, if not, go confirmNoConsumer
     */
    if (((NSNumber*)[user objectForKey:@"has_phone"]).boolValue) {
//    if (0) {
        id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfo");
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd_show_module = PUSH;
        [cmd_show_module performWithResult:&dic];

    } else {
        id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmPhoneNoConsumer");
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd_show_module = PUSH;
        [cmd_show_module performWithResult:&dic];
    }
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
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"GroupChat");
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

//
-(void)didShareBtnClick:(UIButton*)btn{
    NSString *title = @"暂不支持该功能";
    AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
}

-(void)didCollectionBtnClick:(UIButton*)btn{
    
    NSDictionary *info = nil;
    CURRENUSER(info);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    
    if (!collectionBtn.selected) {
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
                collectionBtn.selected = bar_like_btn.selected = YES;
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
                
                collectionBtn.selected = bar_like_btn.selected = NO;
            } else {
                NSString *title = @"取消收藏失败!请检查网络链接是否正常";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (offset_y > kLIMITEDSHOWNAVBAR) {
        return UIStatusBarStyleDefault;
    }else return UIStatusBarStyleLightContent;
}

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
@end
