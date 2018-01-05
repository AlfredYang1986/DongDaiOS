//
//  AYHomeAssortmentCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeAssortmentCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYHomeAssortmentItem.h"

@implementation AYHomeAssortmentCellView {
	UILabel *titleLabel;
	UILabel *subTitleLabel;
	
	UICollectionView *CollectionView;
	NSArray *serviceData;
	
	CGSize itemSizeData;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleLabel = [Tools creatLabelWithText:@"分类" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(self).offset(0);
		}];
		
		subTitleLabel = [UILabel creatLabelWithText:@"一句话简单描述" textColor:[UIColor gary] fontSize:13 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(2);
		}];
		
		UIButton *moreBtn = [Tools creatUIButtonWithTitle:@"查看更多" andTitleColor:[UIColor theme] andFontSize:313.f andBackgroundColor:nil];
		[self addSubview:moreBtn];
		[moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.bottom.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(60, 20));
		}];
		[moreBtn addTarget:self action:@selector(didAssortmentMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		flowLayout.minimumInteritemSpacing = 8;
		flowLayout.minimumLineSpacing = 8;
		
		CollectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 250) collectionViewLayout:flowLayout];
		CollectionView.delegate = self;
		CollectionView.dataSource = self;
		CollectionView.showsVerticalScrollIndicator = NO;
		CollectionView.showsHorizontalScrollIndicator = NO;
		CollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 0);
		[CollectionView setBackgroundColor:[UIColor clearColor]];
		[CollectionView registerClass:NSClassFromString(@"AYHomeAssortmentItem") forCellWithReuseIdentifier:@"AYHomeAssortmentItem"];
		[CollectionView registerClass:NSClassFromString(@"AYHomeMoreItem") forCellWithReuseIdentifier:@"AYHomeMoreItem"];
		[self addSubview:CollectionView];
		[CollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(65);
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.bottom.equalTo(self);
		}];
		
	}
	return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return serviceData.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == serviceData.count) {
		AYHomeMoreItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYHomeMoreItem" forIndexPath:indexPath];
		return cell;
	} else {
		
		AYHomeAssortmentItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYHomeAssortmentItem" forIndexPath:indexPath];
		
		NSMutableDictionary *tmp = [[serviceData objectAtIndex:indexPath.row] copy];
//		[tmp setValue:[serviceData objectAtIndex:indexPath.row] forKey:kAYServiceArgsSelf];
		cell.itemInfo = [tmp copy];
		return cell;
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	
	if (indexPath.row == serviceData.count) {
		NSString *title = titleLabel.text;
		[(AYViewController*)self.controller performSel:@"didAssortmentMoreBtnClick:" withResult:&title];
	} else {
		
		AYHomeAssortmentItem *item = (AYHomeAssortmentItem*)[collectionView cellForItemAtIndexPath:indexPath];
		UIImageView *cover = item.coverImage;
		[dic setValue:cover forKey:@"cover"];
		[dic setValue:[serviceData objectAtIndex:indexPath.row] forKey:kAYServiceArgsSelf];
	}
	
	id tmp = [dic copy];
	[(AYViewController*)self.controller performSel:@"didSelectAssortmentAtIndex:" withResult:&tmp];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (serviceData.count == indexPath.row && itemSizeData.height == 320) {
		
		return CGSizeMake(106+SCREEN_MARGIN_LR, itemSizeData.height);
	} else {
		return itemSizeData;
	}
}

#pragma mark -- life cycle

#pragma mark -- commands
- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
- (void)didAssortmentMoreBtnClick {
	NSString *title = titleLabel.text;
	[(AYViewController*)self.controller performSel:@"didAssortmentMoreBtnClick:" withResult:&title];
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	NSString *cat = [[args objectForKey:@"service"] objectForKey:@"service_type"];
	itemSizeData = CGSizeMake(160, 250);
	NSString *subStr;
	if ([cat isEqualToString:@"看顾"]) {
		itemSizeData = CGSizeMake(320, 320);
		subStr = @"看顾看顾看顾";
	}
	else if ([cat isEqualToString:@"艺术"]) {
		subStr = @"看顾看顾看顾";
	}
	else if ([cat isEqualToString:@"运动"]) {
		subStr = @"看顾看顾看顾";
	}
	else {
		subStr = @"科学看顾看顾";
	}
	
	titleLabel.text = cat;
	subTitleLabel.text = subStr;
	
	serviceData = [[args objectForKey:@"service"] objectForKey:@"services"];
	[CollectionView reloadData];
	
	return nil;
}

@end
