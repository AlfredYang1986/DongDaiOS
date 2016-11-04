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

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#import "SDCycleScrollView.h"

#define kLIMITEDSHOWNAVBAR  (-50)
#define kFlexibleHeight     250

@interface AYPersonalPageController ()<SDCycleScrollViewDelegate>

@end

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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServicePage"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServicePageCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
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
            
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 0, 0) delegate:self placeholderImage:IMGRESOURCE(@"default_image")];
            cycleScrollView.imageURLStringsGroup = [tmp copy];
        } else {
            
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 0, 0) shouldInfiniteLoop:YES imageNamesGroup:[service_info objectForKey:@"images"]];
            cycleScrollView.localizationImageNamesGroup = [service_info objectForKey:@"images"];
            cycleScrollView.delegate = self;
        }
        
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.currentPageDotColor = [Tools themeColor];
        cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        [flexibleView addSubview:cycleScrollView];
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.autoScrollTimeInterval = 99999.0;   //99999秒 滚动一次 ≈ 不自动滚动
        [cycleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(flexibleView);
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
        
        UILabel *costLabel = [[UILabel alloc]init];
        costLabel = [Tools setLabelWith:costLabel andText:@"Service Price" andTextColor:[UIColor whiteColor] andFontSize:[UIFont systemFontSize] andBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.6f] andTextAlignment:NSTextAlignmentCenter];
        costLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.f];
        [flexibleView addSubview:costLabel];
        [costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(flexibleView);
            make.bottom.equalTo(flexibleView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(125, 35));
        }];
        costLabel.text = [NSString stringWithFormat:@"¥ %.f／小时",((NSString*)[service_info objectForKey:@"price"]).floatValue];
    }
    
    id<AYFacadeBase> remote = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [remote.commands objectForKey:@"QueryUserProfile"];
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"ServicePage"];
    id<AYCommand> cmd_change_data = [cmd_notify.commands objectForKey:@"changeQueryData:"];
    NSDictionary *tmp = [service_info copy];
    [cmd_change_data performWithResult:&tmp];
    
    NSDictionary *user_info = nil;
    CURRENUSER(user_info)
    
    NSMutableDictionary* dic = [user_info mutableCopy];
    [dic setValue:[service_info objectForKey:@"owner_id"]  forKey:@"owner_user_id"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
            id<AYCommand> cmd_desc = [cmd_notify.commands objectForKey:@"changeDescription:"];
            id descr = [result objectForKey:@"personal_description"];
            [cmd_desc performWithResult:&descr];
            
//            NSMutableDictionary *tmp = [service_info mutableCopy];
//            [tmp setValue:[result objectForKey:@"personal_description"] forKey:@"description"];
//            
//            NSDictionary *dic = [tmp copy];
//            [cmd performWithResult:&dic];
            
            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
            id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
            [refresh performWithResult:nil];
        }
    }];
    
//    changeDescription
    
    
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
    [self.view bringSubviewToFront:(UINavigationBar*)navBar];
    ((UINavigationBar*)navBar).alpha = 0;
    
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
    
    collectionBtn = [[UIButton alloc]init];
    [collectionBtn setImage:IMGRESOURCE(@"service_uncollection") forState:UIControlStateNormal];
    [collectionBtn setImage:IMGRESOURCE(@"service_collection") forState:UIControlStateSelected];
    [self.view addSubview:collectionBtn];
    [self.view bringSubviewToFront:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareBtn.mas_left).offset(-20);
        make.centerY.equalTo(shareBtn);
        make.size.equalTo(shareBtn);
    }];
    [collectionBtn addTarget:self action:@selector(didCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottom_view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    bottom_view.backgroundColor = [Tools themeColor];
    [self.view addSubview:bottom_view];
    [self.view bringSubviewToFront:bottom_view];
    
    CALayer *left = [CALayer layer];
    left.frame = CGRectMake(SCREEN_WIDTH *0.5, 11, 1, 28);
    left.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f].CGColor;
    [bottom_view.layer addSublayer:left];
//    CALayer *right = [CALayer layer];
//    right.frame = CGRectMake(SCREEN_WIDTH *0.5, 0, 1, 44);
//    right.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
//    [bottom_view.layer addSublayer:right];
    
    UIButton *bookBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH *0.5 - 1, 50)];
    [bookBtn setBackgroundColor:[Tools themeColor]];
    [bookBtn setTitle:@"申请预订" forState:UIControlStateNormal];
    bookBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.f];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookBtn addTarget:self action:@selector(didBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottom_view addSubview:bookBtn];
    
    UIButton *chatBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 + 1, 0, SCREEN_WIDTH *0.5 - 1, 50)];
    [chatBtn setBackgroundColor:[Tools themeColor]];
    [chatBtn setTitle:@"沟通" forState:UIControlStateNormal];
    chatBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.f];
    [chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(didChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottom_view addSubview:chatBtn];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 55);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    id right = [NSNumber numberWithBool:YES];
    [cmd_right performWithResult:&right];
    
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
    
    bar_like_btn = [[UIButton alloc]init];
    [bar_like_btn setImage:IMGRESOURCE(@"bar_unlike_btn") forState:UIControlStateNormal];
    [bar_like_btn setImage:IMGRESOURCE(@"bar_like_btn") forState:UIControlStateSelected];
    [bar_like_btn addTarget:self action:@selector(didCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bar_like_btn];
    [bar_like_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(speart.mas_left).offset(-23);
        make.centerY.equalTo(bar_share_btn);
        make.size.mas_equalTo(CGSizeMake(23.5, 20));
    }];
    
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusBar.backgroundColor = [UIColor whiteColor];
    [view addSubview:statusBar];
    
    CALayer* line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.f].CGColor;
    line.frame = CGRectMake(0, 54, SCREEN_WIDTH, 1);
    [view.layer addSublayer:line];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(kFlexibleHeight, 0, 0, 0);
    view.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
    
//    ((UITableView*)view).estimatedRowHeight = 300;
//    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
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

-(id)sendPopMessage{
    [self leftBtnSelected];
    return nil;
}

-(id)scrollOffsetY:(NSNumber*)y {
    offset_y = y.floatValue;
//    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
    
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
    [self.view bringSubviewToFront:(UINavigationBar*)navBar];
    if (offset_y > kLIMITEDSHOWNAVBAR) {
        
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
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - (SCREEN_WIDTH * offsetH / 225), kFlexibleHeight - offsetH));
//        }];
//    }
    
    [shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.view.mas_top).offset(- offset_y);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
//    [collectionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(shareBtn.mas_left).offset(-20);
//        make.centerY.equalTo(shareBtn);
//        make.size.equalTo(shareBtn);
//    }];
    return nil;
}

- (id)showCansOrFacility:(NSNumber*)args {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"Facility");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)showServiceOfferDate {
//    NSArray *offer_date = [service_info objectForKey:@"offer_date"];
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
                
                collectionBtn.selected = YES;
                bar_like_btn.selected = YES;
            } else {
                NSLog(@"push error with:%@",result);
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请检查网络链接是否正常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    }else {
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
                collectionBtn.selected = NO;
                bar_like_btn.selected = NO;
            } else {
                NSLog(@"push error with:%@",result);
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请检查网络链接是否正常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
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
