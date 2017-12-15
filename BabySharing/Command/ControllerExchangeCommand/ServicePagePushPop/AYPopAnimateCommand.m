//
//  AYPopAnimateCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 11/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved. 
//

#import "AYPopAnimateCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPopAnimateCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	NSLog(@"pop command perfrom");
	
	NSDictionary* dic = (NSDictionary*)*obj;

	AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
	
	UINavigationController * nav = source.navigationController;
	
	AYViewController* des = [nav.viewControllers objectAtIndex:nav.viewControllers.count-2];
	
	id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
	if (tmp != nil) {
		NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
		[dic_init setValue:kAYControllerActionPopBackValue forKey:kAYControllerActionKey];
		[dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
		[des performWithResult:&dic_init];
	}
	
	if (des.snapAnimateView) {
		
		[nav popViewControllerAnimated:NO];
		des.snapAnimateView.alpha = 1;
		[des.view addSubview: des.snapAnimateView];
		
		[UIView animateWithDuration:0.5 animations:^{
			des.snapAnimateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);;
			des.snapAnimateView.alpha = 0;
		} completion:^(BOOL finished) {
			[des.snapAnimateView removeFromSuperview];
			des.snapAnimateView = nil;
		}];
		
	} else {
		
		[nav popViewControllerAnimated:YES];
	}
	
//	SEL sel = NSSelectorFromString(@"respondPopAnimat");
//	Method m = class_getInstanceMethod([recev class], sel);
//	if (m) {
//		IMP imp = method_getImplementation(m);
//		id (*func)(id, SEL) = (id (*)(id, SEL))imp;
//		func(recev, sel);
//	}
	
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

@end
