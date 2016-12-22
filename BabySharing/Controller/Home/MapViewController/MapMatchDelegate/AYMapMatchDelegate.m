//
//  AYMapMatchDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapMatchDelegate.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"
#import "AYProfileOrigCellView.h"
#import "AYMapMatchCellView.h"

@implementation AYMapMatchDelegate {
	NSArray *servicesData;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (id)changeQueryData:(id)args {
	servicesData = (NSArray*)args;
	return nil;
}

#pragma mark -- collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"MapMatchCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	AYMapMatchCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:class_name forIndexPath:indexPath];
	
	NSArray *tmp = [NSArray array];
	cell.serviceData = tmp;
	cell.didTouchUpInSubCell = ^(NSDictionary *service_info) {
		
	};
//	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	return (UICollectionViewCell*)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	return CGSizeMake(SCREEN_WIDTH, 260);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
}

#pragma mark -- actions


@end
