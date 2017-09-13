//
//  AYAssortmentSKUController.m
//  BabySharing
//
//  Created by Alfred Yang on 24/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentSKUController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYThumbsAndPushDefines.h"
#import "AYModelFacade.h"

#import "AYAssortmentSKUItem.h"

@implementation AYAssortmentSKUController {
	UICollectionView *SKUCollectionView;
	NSInteger focusSKUIndex;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYAssortmentSKUItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYAssortmentSKUItem" forIndexPath:indexPath];
	[item setCornerRadius:(indexPath.row == focusSKUIndex ? 25 : 16)];
	return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == focusSKUIndex) {
		return CGSizeMake(136, 50);
	} else
		return CGSizeMake(88, 32);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	focusSKUIndex = indexPath.row;
//	[collectionView reloadItemsAtIndexPaths:@[indexPath]];
	[collectionView reloadData];
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
	
	UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
	flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
	flowLayout.minimumInteritemSpacing = 15.f;
	flowLayout.minimumLineSpacing = 0;
	
	SKUCollectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 50) collectionViewLayout:flowLayout];
	SKUCollectionView.delegate = self;
	SKUCollectionView.dataSource = self;
	SKUCollectionView.showsHorizontalScrollIndicator = NO;
	[SKUCollectionView setBackgroundColor:[UIColor clearColor]];
	[SKUCollectionView registerClass:NSClassFromString(@"AYAssortmentSKUItem") forCellWithReuseIdentifier:@"AYAssortmentSKUItem"];
	[self.view addSubview:SKUCollectionView];
	SKUCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"Assortment"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"AssortmentCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	view.backgroundColor = [Tools whiteColor];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	view.backgroundColor = [Tools whiteColor];
	
	NSString *title = @"热门分类001";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
	return nil;
}

- (id)TableLayout:(UIView*)view {
	CGFloat marginTop = 140.f;
	view.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
	return nil;
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
@end
