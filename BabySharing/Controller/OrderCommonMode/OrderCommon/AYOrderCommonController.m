//
//  AYOrderCommonController.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderCommonController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYOrderCommonController {
	
	NSArray *order_info;
	UILabel *leastNews;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
		
		id tmp = [args copy];
		kAYDelegatesSendMessage(@"BOrderMain", @"changeQueryData:", &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	/****************************************/
	[Tools creatCALayerWithFrame:CGRectMake(85, SCREEN_HEIGHT * 0.5, 1.f, SCREEN_HEIGHT * 0.5 - 49) andColor:[Tools lightGreyColor] inSuperView:self.view];
	UIView *tableView = [self.views objectForKey:kAYTableView];
	[self.view bringSubviewToFront:tableView];
	/****************************************/
	
	UIView *newsBoardView = [[UIView alloc]init];
	newsBoardView.backgroundColor = [Tools whiteColor];
	newsBoardView.layer.shadowColor = [Tools garyColor].CGColor;
	newsBoardView.layer.shadowOffset = CGSizeMake(0, 0);
	newsBoardView.layer.shadowOpacity = 0.5f;
	[self.view addSubview:newsBoardView];
	[newsBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.view).offset(30);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 95));
	}];
	
	UILabel *title = [Tools creatUILabelWithText:@"最新动态" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[newsBoardView addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(newsBoardView).offset(15);
		make.top.equalTo(newsBoardView).offset(20);
	}];
	
	UIButton *allNewsBtn  = [Tools creatUIButtonWithTitle:@"全部动态" andTitleColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil];
	[newsBoardView addSubview:allNewsBtn];
	[allNewsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(title);
		make.right.equalTo(newsBoardView).offset(-15);
		make.size.mas_equalTo(CGSizeMake(70, 30));
	}];
	[allNewsBtn addTarget:self action:@selector(didAllNewsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	leastNews = [Tools creatUILabelWithText:@"暂时没有新的动态" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[newsBoardView addSubview:leastNews];
	[leastNews mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(title);
		make.top.equalTo(title.mas_bottom).offset(18);
	}];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderCommon"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	NSDictionary *tmp = [order_info copy];
	kAYDelegatesSendMessage(@"BOrderMain:", @"changeQueryData:", &tmp)
	
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
	
	NSString *title = @"确认信息";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_HEIGHT - 140 - 49);
	return nil;
}

#pragma mark -- actions
- (void)didAllNewsBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderListNews");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//	id tmp ;
//	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	
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
