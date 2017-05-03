//
//  AYBOApplyBackController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYBOApplyBackController.h"

@interface AYBOApplyBackController ()

@end

@implementation AYBOApplyBackController

- (void)viewDidLoad {
    [super viewDidLoad];
	
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
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
//	NSString *title = @"确认信息";
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"content_close");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)BOApplyBackLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT * 0.4, SCREEN_WIDTH, 100);
	return nil;
}

#pragma mark -- actions

- (void)BtmAlertOtherBtnClick {
	NSLog(@"didOtherBtnClick");
	
	[super BtmAlertOtherBtnClick];
	[super tabBarVCSelectIndex:2];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POPTOROOT;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	
	return nil;
}


-(BOOL)isActive{
	UIViewController * tmp = [Tools activityViewController];
	return tmp == self;
}

@end
