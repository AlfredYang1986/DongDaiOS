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
	
	NSArray *order_past;
	UIView *payOptionSignView;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		order_past = [dic objectForKey:kAYControllerChangeArgsKey];
		
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

@end
