//
//  AYUnSubsPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYUnSubsPageController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYUnSubsPageController {
	
	NSDictionary *order_info;
	UIView *payOptionSignView;
	NSString *further_message;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		order_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIImageView *checkIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"checked_icon")];
	[self.view addSubview:checkIcon];
	[checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.view.mas_top).offset(104);
		make.left.equalTo(self.view).offset(90);
		make.size.mas_equalTo(CGSizeMake(20,20));
	}];
	
	UILabel *titleH1 = [Tools creatUILabelWithText:@"确认取消订单" andTextColor:[Tools blackColor] andFontSize:616.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleH1];
	[titleH1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(checkIcon.mas_right).offset(20);
		make.centerY.equalTo(checkIcon);
	}];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"UnSubsPage"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TitleOptCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	//	id tmp = [order_past copy];
	//	kAYDelegatesSendMessage(@"UnSubsPage", kAYDelegateChangeDataMessage, &tmp)
	
	UIButton *ConfirmPayBtn = [Tools creatUIButtonWithTitle:@"提交" andTitleColor:[Tools whiteColor] andFontSize:314.f andBackgroundColor:[Tools themeColor]];
	[self.view addSubview:ConfirmPayBtn];
	[ConfirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kTabBarH));
	}];
	[ConfirmPayBtn addTarget:self action:@selector(didConfirmPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	NSString *title = @"取消原因";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH + 80, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH - 80);
	return nil;
}

#pragma mark -- actions
- (void)didConfirmPayBtnClick {
	NSDictionary *args;
	CURRENUSER(args);
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd_cancel = [facade.commands objectForKey:@"CancelOrder"];
	
	NSMutableDictionary *dic_cancel_info = [[NSMutableDictionary alloc] initWithDictionary:args];
	[dic_cancel_info setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[dic_cancel_info setValue:further_message forKey:kAYOrderArgsFurtherMessage];
	
	[cmd_cancel performWithResult:[dic_cancel_info copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			id<AYCommand> des = DEFAULTCONTROLLER(@"RemoteBack");
			NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
			[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
			[dic setValue:@{@"FBType":@"FBTypeCancelOrder", kAYCommArgsTips:@"已成功取消订单"} forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd_push = PUSH;
			[cmd_push performWithResult:&dic];
		} else {
			
		}
	}];
	
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
	
	return nil;
}

- (id)didOptionClick:(id)args {
	
	further_message = [args objectForKey:@"string"];
	
	payOptionSignView.hidden = YES;
	payOptionSignView = [args objectForKey:@"view"];
	payOptionSignView.hidden = NO;
	
	return nil;
}

@end
