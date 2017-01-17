//
//  AYOrderInfoPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoPageController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYOrderInfoPageController {
	
	NSDictionary *order_info;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderInfoPage"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	id tmp = [order_info copy];
	kAYDelegatesSendMessage(@"OrderInfoPage", @"changeQueryData:", &tmp)
	
	UIButton *historyBtn  = [Tools creatUIButtonWithTitle:@"查看历史记录" andTitleColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
	//	historyBtn.layer.shadowColor = [Tools garyColor].CGColor;
	//	historyBtn.layer.shadowOffset = CGSizeMake(0, -0.5);
	//	historyBtn.layer.shadowOpacity = 0.4f;
	[Tools creatCALayerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:historyBtn];
	[self.view addSubview:historyBtn];
	[historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.bottom.equalTo(self.view).offset(-49);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
	}];
	[historyBtn addTarget:self action:@selector(didHistoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
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
	view.backgroundColor = [UIColor clearColor];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	view.backgroundColor = [UIColor clearColor];
	//	NSString *title = @"确认信息";
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	
	//	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_HEIGHT - 140 - 49 - 49); //5 margin
	return nil;
}

#pragma mark -- actions


- (void)didHistoryBtnClick:(UIButton*)btn {
	
//	id<AYCommand> des = DEFAULTCONTROLLER(@"ServantHistory");
//	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//	[dic setValue:[order_past copy] forKey:kAYControllerChangeArgsKey];
//	
//	id<AYCommand> cmd_push = PUSH;
//	[cmd_push performWithResult:&dic];
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

@end
