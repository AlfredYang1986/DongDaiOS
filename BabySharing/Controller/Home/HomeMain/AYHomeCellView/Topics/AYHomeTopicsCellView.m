//
//  AYHomeTopicsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeTopicsCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

@implementation AYHomeTopicsCellView  {
	UILabel *titleLabel;
	UILabel *subTitleLabel;
	
	UICollectionView *collectionView;
	
	NSArray *topicsArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		topicsArr = kAY_top_assortment_titles;
		
		
		titleLabel = [Tools creatUILabelWithText:@"Zhuanji01" andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
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
		
		UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
		flowLayout.itemSize  = CGSizeMake(200, 250);
		flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
		flowLayout.minimumInteritemSpacing = 0;
		flowLayout.minimumLineSpacing = 16;
		
		collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 270) collectionViewLayout:flowLayout];
		collectionView.delegate = self;
		collectionView.dataSource = self;
		collectionView.showsVerticalScrollIndicator = NO;
		collectionView.showsHorizontalScrollIndicator = NO;
		collectionView.contentInset = UIEdgeInsetsMake(5, 15, 0, 0);
		[collectionView setBackgroundColor:[UIColor clearColor]];
		[collectionView registerClass:NSClassFromString(@"AYHomeTopicItem") forCellWithReuseIdentifier:@"AYHomeTopicItem"];
		[self addSubview:collectionView];
		
	}
	return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return topicsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYHomeTopicItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYHomeTopicItem" forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[topicsArr objectAtIndex:indexPath.row] forKey:@"title"];
	//	[tmp setValue:[NSNumber numberWithInteger:100] forKey:@"count_skiped"];
//	[tmp setValue:[NSString stringWithFormat:@"topsort_home_%ld", indexPath.row] forKey:@"assortment_img"];
	[cell setItemInfo:[tmp copy]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sort = [topicsArr objectAtIndex:indexPath.row];
	//	kAYViewSendNotify(self, @"didSelectAssortmentAtIndex:", &sort)
//	[self performNotify:@"didOneTopicClick:" withResult:&sort];
//	[self controller:self.controller performSeletor:@"didOneTopicClick:" withResult:&sort];
	[(AYViewController*)self.controller performSel:@"didOneTopicClick:" withResult:&sort];
}

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
- (void)didTopicsMoreBtnClick {
	kAYViewSendNotify(self, @"didTopicsMoreBtnClick", nil)
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	return nil;
}

@end
