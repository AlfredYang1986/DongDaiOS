//
//  AYFinalConfirmController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYFinalConfirmController.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYFinalConfirmController {
	NSMutableDictionary *push_service_info;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:nil andTextColor:[Tools themeColor] andFontSize:124.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(25);
		make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 110/667);
	}];
	
	// 调整行间距
	NSString *titleStr = @"非常好！\n现在即将发布您的服务。";
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:6];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
	titleLabel.attributedText = attributedString;
	
	UIButton* PushBtn = [Tools creatUIButtonWithTitle:@"确认发布" andTitleColor:[Tools whiteColor] andFontSize:-16.f andBackgroundColor:[Tools themeColor]];
	[Tools setViewBorder:PushBtn withRadius:25.f andBorderWidth:0 andBorderColor:0 andBackground:[Tools themeColor]];
	[self.view addSubview:PushBtn];
	[PushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.centerY.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(125, 50));
	}];
	
	[PushBtn addTarget:self action:@selector(didPushBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	//    view.backgroundColor = [UIColor whiteColor];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	//    view.backgroundColor = [UIColor whiteColor];
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	//	NSString *title = @"服务类型";
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	
	//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

#pragma mark -- actions
- (void)didPushBtnClick {
	
	NSArray *napPhotos = [push_service_info objectForKey:@"images"];
	AYRemoteCallCommand* cmd_upload = MODULE(@"PostPhotos");
	[cmd_upload performWithResult:(NSDictionary*)napPhotos andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSDictionary* user_info = nil;
			CURRENUSER(user_info)
			
			[push_service_info setValue:[user_info objectForKey:@"user_id"]  forKey:@"owner_id"];
			[push_service_info setValue:(NSArray*)result forKey:@"images"];
			
			id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
			AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushServiceInfo"];
			[cmd_push performWithResult:[push_service_info copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
				if (success) {
					
					id<AYFacadeBase> facade = LOGINMODEL;
					id<AYCommand> cmd = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
					NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
					[dic setValue:[NSNumber numberWithBool:YES] forKey:@"is_service_provider"];
					[cmd performWithResult:&dic];
					
					//                    NSString *tip = @"服务发布成功,去管理服务?";
					//                    [self popToRootVCWithTip:tip];
					
					AYViewController* compare = DEFAULTCONTROLLER(@"TabBarService");
					BOOL isNap = [self.tabBarController isKindOfClass:[compare class]];
					if (isNap) {
						[super tabBarVCSelectIndex:2];
					} else {
						[self exchangeWindowsWithDest:compare];
					}
					
				} else {
					
					NSString *title = @"服务上传失败";
					AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
				}
			}];
		} else {
			NSString *title = @"图片上传失败,请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
}

- (void)exchangeWindowsWithDest:(id)dest {
	AYViewController *des = dest;
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc] init];
	[dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_exchange = [[NSMutableDictionary alloc]init];
	[dic_exchange setValue:[NSNumber numberWithInteger:2] forKey:@"index"];
	[dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeUnloginToAllModel] forKey:@"type"];
	[dic_show_module setValue:dic_exchange forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
	[cmd_show_module performWithResult:&dic_show_module];
	
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
	[dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic_pop];
	return nil;
}

- (id)rightBtnSelected {
	
	return nil;
}

@end