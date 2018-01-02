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
	
	NSArray *titleArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleArr = @[@"看顾", @"运动", @"艺术", @"科学"];
		
		titleLabel = [Tools creatUILabelWithText:@"Assortment01" andTextColor:[UIColor black] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(self).offset(15);
		}];
		
		subTitleLabel = [UILabel creatLabelWithText:@"一句话简单描述" textColor:[UIColor gary] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
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
//		flowLayout.itemSize = CGSizeMake(160, 200);
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		flowLayout.minimumInteritemSpacing = 10;
		flowLayout.minimumLineSpacing = 8;
		
		CollectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 210) collectionViewLayout:flowLayout];
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
			make.top.equalTo(self).offset(80);
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.bottom.equalTo(self);
		}];
		
//		if (reuseIdentifier != nil) {
//			[self setUpReuseCell];
//		}
	}
	return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//	return serviceData.count;
	return 6 + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 6) {
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
	
	if (indexPath.row == 6) {
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
	
	return itemSizeData;
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
	
	serviceData = [args objectForKey:@"services"];
	
	if ([[args objectForKey:@"index"] intValue] == 0) {
		itemSizeData = CGSizeMake(315, 250);
	} else
		itemSizeData = CGSizeMake(160, 210);
	
	titleLabel.text = [titleArr objectAtIndex:[[args objectForKey:@"index"] intValue]];
	
	[CollectionView reloadData];
	
	return nil;
}

@end
