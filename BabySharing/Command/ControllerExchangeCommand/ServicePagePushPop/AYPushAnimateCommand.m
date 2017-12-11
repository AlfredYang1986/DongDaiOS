//
//  AYPushAnimateCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 11/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPushAnimateCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPushAnimateCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	NSLog(@"pop command perfrom");
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		@throw [[NSException alloc]initWithName:@"error" reason:@"push command 只能出来push 操作" userInfo:nil];
	}
	
	AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
	AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
	
	if (source.navigationController == nil) {
		@throw [[NSException alloc]initWithName:@"error" reason:@"push command source controler 必须是一个navigation controller" userInfo:nil];
	}
	
	id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
	if (tmp != nil) {
		NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
		[dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
		[dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
		[des performWithResult:&dic_init];
	}
	
	des.hidesBottomBarWhenPushed = YES;
	[source.navigationController pushViewController:des animated:NO];
	
	//	MXSProfileVC *firstVC = f_vc;
	//	MXSShowImageVC *secondVC = t_vc;
	//
	//	MXShowTableCell *cell = [firstVC.showTable cellForRowAtIndexPath:args];
	//
	//	UIView *snapShotView = [firstVC.tabBarController.view snapshotViewAfterScreenUpdates:NO];
	//	CGRect firstFrame  = [firstVC.view convertRect:cell.img.frame fromView:cell];
	//	//	CGRect secondFrame = [secondVC.view convertRect:secondVC.showImg.frame fromView:secondVC.view];
	//
	//	secondVC.popFrame = firstFrame;
	//
	//	((MXSViewController*)t_vc).hidesBottomBarWhenPushed = YES;
	//	[[(MXSViewController*)f_vc navigationController] pushViewController:t_vc animated:NO];
	//
	//	//	secondVC.showImg.hidden = YES;
	//
	//	CGRect secondFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	//	snapShotView.frame = secondFrame;
	//	firstVC.animatImgView = snapShotView;
	//	[secondVC.view addSubview:snapShotView];
	//
	//	CGFloat scala_w = SCREEN_WIDTH/firstFrame.size.width;
	//	CGFloat scala_h = 160/firstFrame.size.height;
	//
	//	CGRect retFrame = CGRectMake(- firstFrame.origin.x * scala_w, - firstFrame.origin.y * scala_h + 60, SCREEN_WIDTH*scala_w, secondFrame.size.height * scala_h);
	//
	//	[UIView animateWithDuration:0.5 animations:^{
	//		snapShotView.frame = retFrame;
	//		snapShotView.alpha = 0;
	//	} completion:^(BOOL finished) {
	//		secondVC.showImg.hidden = NO;
	//	}];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

@end
