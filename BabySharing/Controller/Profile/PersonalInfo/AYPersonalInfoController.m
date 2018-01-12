//
//  AYPersonalInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 27/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalInfoController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

#define userPhotoInitHeight         250

@implementation AYPersonalInfoController {
    
    NSDictionary *personal_info;
    UIImageView *coverImg;
}

- (void)postPerform {
	NSDictionary *user_info = nil;
	CURRENPROFILE(user_info)
	personal_info = user_info;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        
        kAYDelegatesSendMessage(@"PersonalInfo", @"changeQueryData:", &tmp)
        kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"PersonalInfo"];
    id obj = (id)cmd_collect;
    kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
    
    obj = (id)cmd_collect;
    kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
//	NSArray *claa_name_arr = @[@"PersonalInfoHeadCell", @"PersonalDescCell", @"PersonalValidateCell"];
	NSArray *claa_name_arr = @[@"AYPersonalDescCellView"];
	NSString *cell_name;
	for (NSString *class_name in claa_name_arr) {
		cell_name = [class_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	}
    
    NSDictionary *tmp = [personal_info copy];
    kAYDelegatesSendMessage(@"PersonalInfo", @"changeQueryData:", &tmp)
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    UITableView *tableView = (UITableView*)view_table;
    coverImg = [[UIImageView alloc]init];
    coverImg.image = [UIImage imageNamed:@"default_image"];
    coverImg.backgroundColor = [UIColor lightGrayColor];
    coverImg.contentMode = UIViewContentModeScaleAspectFill;
    coverImg.clipsToBounds = YES;
    [tableView addSubview:coverImg];
    [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView).offset(- userPhotoInitHeight);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, userPhotoInitHeight));
    }];
	
	CGFloat editBtnWidth = 52;
	UIView *btnShadowView = [[UIView alloc] init];
	btnShadowView.backgroundColor = [UIColor white];
	[self.view addSubview:btnShadowView];
	btnShadowView.layer.shadowColor = [UIColor gary].CGColor;
	btnShadowView.layer.shadowOffset = CGSizeMake(0, 0);
	btnShadowView.layer.shadowRadius = 5.f;
	btnShadowView.layer.shadowOpacity = 0.5f;
	btnShadowView.layer.cornerRadius = 3.f;
	btnShadowView.layer.cornerRadius = editBtnWidth*0.5;
	[btnShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(coverImg.mas_bottom);
		make.right.equalTo(self.view).offset(-SCREEN_MARGIN_LR);
		make.size.mas_equalTo(CGSizeMake(editBtnWidth, editBtnWidth));
	}];
	
	UIButton *editBtn = [[UIButton alloc]init];
	[editBtn setImage:IMGRESOURCE(@"icon_edit_pen") forState:UIControlStateNormal];
	[editBtn setRadius:editBtnWidth*0.5 borderWidth:0 borderColor:nil background:[UIColor white]];
	[self.view addSubview:editBtn];
	[editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(coverImg.mas_bottom);
		make.right.equalTo(self.view).offset(-SCREEN_MARGIN_LR);
		make.size.mas_equalTo(CGSizeMake(editBtnWidth, editBtnWidth));
	}];
	[editBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	[self.view sendSubviewToBack:tableView];
	[self.view bringSubviewToFront:editBtn];
	
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
	NSString* photo_name = [personal_info objectForKey:@"screen_photo"];
	if (photo_name) {
		[coverImg sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]] placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
	{
		NSMutableDictionary* dic = [Tools getBaseRemoteData];
		//	NSString* owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
		[[dic objectForKey:kAYCommArgsCondition] setValue:[personal_info objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
		
		id<AYFacadeBase> facade = [self.facades objectForKey:@"ProfileRemote"];
		AYRemoteCallCommand* cmd = [facade.commands objectForKey:@"QueryUserProfile"];
		[cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
			if (success) {
				personal_info = [result objectForKey:kAYProfileArgsSelf];
				NSDictionary *tmp = [personal_info copy];
				kAYDelegatesSendMessage(@"PersonalInfo", @"changeQueryData:", &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			}
		}];
	}
	
	
	UIButton *closeBtn = [[UIButton alloc]init];
	[closeBtn setImage:IMGRESOURCE(@"map_icon_close") forState:UIControlStateNormal];
	[self.view addSubview:closeBtn];
	[closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(25);
		make.left.equalTo(self.view).offset(10);
		make.size.mas_equalTo(CGSizeMake(51, 51));
	}];
	[closeBtn addTarget:self action:@selector(leftBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *loginOut = [UIButton creatBtnWithTitle:@"退出登录" titleColor:[UIColor white] fontSize:617 backgroundColor:nil];
	[self.view addSubview:loginOut];
	[loginOut mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.view).offset(-SCREEN_MARGIN_LR);
		make.centerY.equalTo(closeBtn);
		make.size.mas_equalTo(CGSizeMake(70, 30));
	}];
	[loginOut addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor whiteColor];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSString *title = @"个人资料";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    NSString *user_id = [personal_info objectForKey:@"user_id"];
    
    if ([user_id isEqualToString:[info objectForKey:@"user_id"]]) {
        
        UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"编辑" titleColor:[Tools black] fontSize:316.f backgroundColor:nil];
        [bar_right_btn sizeToFit];
        bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    } else {
        
        NSNumber* left_hidden = [NSNumber numberWithBool:YES];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &left_hidden)
    }
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(userPhotoInitHeight, 0, 0, 0);
	((UITableView*)view).estimatedRowHeight = 300;
	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- actions
- (void)loginOutClick {
	NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
	[notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
	[notify setValue:kAYNotifyCurrentUserLogout forKey:kAYNotifyFunctionKey];
	
	NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
	[notify setValue:[args copy] forKey:kAYNotifyArgsKey];
	
	id<AYFacadeBase> f = LOGINMODEL;
	[f performWithResult:&notify];
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

- (id)rightBtnSelected {
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[personal_info copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)scrollOffsetY:(NSNumber*)args {
    CGFloat offset_y = args.floatValue;
    CGFloat offsetH = userPhotoInitHeight + offset_y;
    
    if (offsetH < 0) {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        UITableView *tableView = (UITableView*)view_notify;
        
        [coverImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tableView);
            make.top.equalTo(tableView).offset(- userPhotoInitHeight + offsetH);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH , userPhotoInitHeight - offsetH));
            
//            make.top.equalTo(tableView).offset(-kFlexibleHeight + offsetH);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - (SCREEN_WIDTH * offsetH / kFlexibleHeight), kFlexibleHeight - offsetH));
        }];
    }
    return nil;
}

@end
