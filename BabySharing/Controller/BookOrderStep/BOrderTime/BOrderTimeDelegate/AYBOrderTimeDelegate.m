//
//  AYBOrderTimeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderTimeDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYMapMatchCellView.h"
#import "AYBOrderTimeItemView.h"

@implementation AYBOrderTimeDelegate {
	NSArray *query_data;
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
	query_data = (NSArray*)args;
	return nil;
}

#pragma mark -- collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderTimeItem"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	AYBOrderTimeItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:class_name forIndexPath:indexPath];
	
	NSArray *tmp = [query_data copy];
	cell.item_data = tmp;
	cell.multiple = indexPath.row;
	cell.didTouchUpInSubBtn = ^(NSDictionary *service_info) {
		kAYDelegateSendNotify(self, @"transTimesInfo:", &service_info)
	};
	//	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	return (UICollectionViewCell*)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat offset_x = scrollView.contentOffset.x;
	NSNumber *tmp = [NSNumber numberWithFloat:offset_x];
	kAYDelegateSendNotify(self, @"scrollOffsetX:", &tmp)
}

#pragma mark -- actions


@end
