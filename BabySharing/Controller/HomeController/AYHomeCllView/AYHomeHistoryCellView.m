//
//  AYHomeHistoryCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 2/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeHistoryCellView.h"
#import "Tools.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "GPUImage.h"
#import "Define.h"
#import "PhotoTagEnumDefines.h"
#import "QueryContentTag.h"
#import "QueryContentChaters.h"
#import "QueryContent+ContextOpt.h"
#import "AppDelegate.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYHomeCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "Masonry.h"

#import "AYThumbsAndPushDefines.h"

#import "AYModelFacade.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYHomeHistoryItem.h"
#import "AYHorizontalLayout.h"

@interface AYHomeHistoryCellView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation AYHomeHistoryCellView {
    
    UICollectionView *showCollectionView;
    
    NSDictionary *service;
    NSArray *queryData;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CALayer *separtor = [CALayer layer];
        separtor.frame = CGRectMake(15, 0, 40, 0.5);
        separtor.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:separtor];
        
        UILabel *title = [[UILabel alloc]init];
        title = [Tools setLabelWith:title andText:@"最近浏览过的服务" andTextColor:[Tools blackColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
        }];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"HomeHistoryCell", @"HomeHistoryCell");
    
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
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
    
}

#pragma mark -- messages
- (id)setCellInfo:(id)args{
    
    queryData = [(NSDictionary*)args objectForKey:@"collect_data"];
    
    AYHorizontalLayout *layout = [[AYHorizontalLayout alloc] init];
//    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc]init];
    
    showCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    showCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    showCollectionView.showsHorizontalScrollIndicator = NO;
    showCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [showCollectionView registerClass:[AYHomeHistoryItem class] forCellWithReuseIdentifier:NSStringFromClass([AYHomeHistoryItem class])];
    [showCollectionView setBackgroundColor:[UIColor brownColor]];
    showCollectionView.delegate = self;
    showCollectionView.dataSource = self;
    [self addSubview:showCollectionView];
    [showCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    
    return nil;
}

#pragma mark -- uicollectionviewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AYHomeHistoryItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AYHomeHistoryItem class]) forIndexPath:indexPath];
    
    cell.itemInfo = [queryData objectAtIndex:indexPath.row];
    
    return cell;
}

@end
