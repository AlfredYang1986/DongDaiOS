//
//  AYHomeCourseCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 7/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeCourseCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYHomeCourseCellView {
	UICollectionView *collectionView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		UILabel *titleLabel = [Tools creatUILabelWithText:@"#分类#" andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(10);
		}];
		
		UILabel *subTitleLabel = [Tools creatUILabelWithText:@"#分类一句描述的话#" andTextColor:[Tools blackColor] andFontSize:613.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(titleLabel.mas_bottom).offset(5);
		}];
		
		UIButton *moreBtn = [Tools creatUIButtonWithTitle:@"188个服务" andTitleColor:[Tools RGB153GaryColor] andFontSize:313.f andBackgroundColor:[Tools themeColor]];
		[self addSubview:moreBtn];
		[moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.bottom.equalTo(subTitleLabel);
			make.size.mas_equalTo(CGSizeMake(60, 20));
		}];
		[moreBtn addTarget:self action:@selector(didMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
		flowLayout.itemSize  = CGSizeMake(140, 160);
		flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
		flowLayout.minimumInteritemSpacing = 10;
		flowLayout.minimumLineSpacing = 8;
		
		collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 170) collectionViewLayout:flowLayout];
		collectionView.delegate = self;
		collectionView.dataSource = self;
		collectionView.showsVerticalScrollIndicator = NO;
		collectionView.showsHorizontalScrollIndicator = NO;
		collectionView.contentInset = UIEdgeInsetsMake(5, 20, 0, 0);
		[collectionView setBackgroundColor:[UIColor clearColor]];
		[collectionView registerClass:NSClassFromString(@"AYHomeServPerItem") forCellWithReuseIdentifier:@"AYHomeServPerItem"];
		[self addSubview:collectionView];
		
//		if (reuseIdentifier != nil) {
//			[self setUpReuseCell];
//		}
	}
	return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return 6 ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYHomeServPerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYHomeServPerItem" forIndexPath:indexPath];
	
//	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
//	[tmp setValue:[assortmentArr objectAtIndex:indexPath.row] forKey:@"title"];
//	//	[tmp setValue:[NSNumber numberWithInteger:100] forKey:@"count_skiped"];
//	[tmp setValue:[NSString stringWithFormat:@"topsort_home_%ld", indexPath.row] forKey:@"assortment_img"];
//	[cell setItemInfo:[tmp copy]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	//	NSNumber *index = [NSNumber numberWithInteger:indexPath.row];
//	NSString *sort = [assortmentArr objectAtIndex:indexPath.row];
//	kAYViewSendNotify(self, @"didSelectAssortmentAtIndex:", &sort)
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"HomeCourseCell", @"HomeCourseCell");
	
	NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
	for (NSString* name in cell.commands.allKeys) {
		AYViewCommand* cmd = [cell.commands objectForKey:name];
		AYViewCommand* c = [[AYViewCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_commands setValue:c forKey:name];
	}
	self.commands = [arr_commands copy];
	
	NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
	for (NSString* name in cell.notifies.allKeys) {
		AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
		AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_notifies setValue:c forKey:name];
	}
	self.notifies = [arr_notifies copy];
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
- (void)didMoreBtnClick {
	
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	
	
	
	return nil;
}

@end
