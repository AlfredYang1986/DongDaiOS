//
//  AYPAYPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPAYPageController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYPAYPageController {
	
	NSString *order_id;
	NSDictionary *service_info;
	
	UIView *payOptionSignView;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//		order_past = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"PAYPage"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
//	id tmp = [order_past copy];
//	kAYDelegatesSendMessage(@"PayWayCell", kAYDelegateChangeDataMessage, &tmp)
	
	UIButton *ConfirmPayBtn = [Tools creatUIButtonWithTitle:@"Confirm Payment" andTitleColor:[Tools whiteColor] andFontSize:314.f andBackgroundColor:[Tools themeColor]];
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
	NSString *title = @"在线支付";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
	return nil;
}

#pragma mark -- actions
- (void)didConfirmPayBtnClick {
	
//#ifdef SANDBOX
//	sumPrice = 1 * scaleUnit;
//#endif
	
	
	//		id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
	//		id<AYCommand> cmd_login = [f.commands objectForKey:@"IsInstalledWechat"];
	//		NSNumber *IsInstalledWechat = [NSNumber numberWithBool:NO];
	//		[cmd_login performWithResult:&IsInstalledWechat];
	//		if (!IsInstalledWechat.boolValue ) {
	//			NSString *title = @"未安装微信！";
	//			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	//			return;
	//		}
	
	
	//			order_id = [result objectForKey:@"order_id"];
	//
	//			// 支付
	//			switch (payOptionSignView.tag) {
	//				case PayWayOptionWechat:
	//				{
	//					id<AYFacadeBase> facade = [self.facades objectForKey:@"SNSWechat"];
	//					AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"PayWithWechat"];
	//
	//					NSMutableDictionary* pay = [[NSMutableDictionary alloc]init];
	//					[pay setValue:[result objectForKey:@"prepay_id"] forKey:@"prepay_id"];
	//					[cmd performWithResult:&pay];
	//				}
	//					break;
	//				case PayWayOptionAlipay:
	//				{
	//                    id<AYFacadeBase> facade = [self.facades objectForKey:@"Alipay"];
	//                    AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"AlipayPay"];
	//
	//                    NSMutableDictionary* pay = [[NSMutableDictionary alloc]init];
	////                    [pay setValue:[result objectForKey:@"prepay_id"] forKey:@"prepay_id"];
	//                    [cmd performWithResult:&pay];
	//				}
	//					break;
	//				default:
	//					break;
	//			}
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

- (id)didPayOptionClick:(id)args {
	payOptionSignView.hidden = YES;
	payOptionSignView = args;
	payOptionSignView.hidden = NO;
	
	return nil;
}

#pragma mark -- payment notifies
- (id)WechatPaySuccess:(id)args {
	
	NSDictionary* user = nil;
	CURRENUSER(user)
	
	// 支付成功
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"PayOrder"];
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:order_id forKey:@"order_id"];
	[dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	[dic setValue:[service_info objectForKey:@"owner_id"] forKey:@"owner_id"];
	[dic setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
	
	[cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			NSString *title = @"服务预订成功! 去日程查看?";
			//            [self popToRootVCWithTip:title];
			AYShowBtmAlertView(title, BtmAlertViewTypeWitnBtn)
			
		} else {
			NSString *title = @"当前网络太慢,服务预订发生错误,请联系客服!";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
	return nil;
}

- (id)WechatPayFailed:(id)args {
	int err_code = ((NSNumber*)[args objectForKey:@"err_code"]).intValue;
	if (err_code == -2) {
		//		NSString *title = @"您已取消本次支付支付";
		//		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	} else {
		NSString *title = @"支付失败\n请改善网络环境并重试";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	}
	return nil;
}

- (id)AlipaySuccess:(id)args {
	NSLog(@"pay success");
	
	NSDictionary* user = nil;
	CURRENUSER(user)
	
	// 支付成功
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"PayOrder"];
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:order_id forKey:@"order_id"];
	[dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	[dic setValue:[service_info objectForKey:@"owner_id"] forKey:@"owner_id"];
	[dic setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
	
	[cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			NSString *title = @"服务预订成功,去日程查看";
			//            [self popToRootVCWithTip:title];
			AYShowBtmAlertView(title, BtmAlertViewTypeWitnBtn)
			
		} else {
			NSString *title = @"当前网络太慢,服务预订发生错误,请联系客服!";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
	return nil;
}

- (id)AlipayFailed:(id)args {
	NSLog(@"pay failed");
	NSString *title = @"支付失败\n请改善网络环境并重试";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	return nil;
}

@end
