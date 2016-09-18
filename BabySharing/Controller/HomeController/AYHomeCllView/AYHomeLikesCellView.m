//
//  AYHomeLikesCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 2/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeLikesCellView.h"
#import "Tools.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "GPUImage.h"
#import "Define.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYHomeCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "AYControllerActionDefines.h"

#import "AYHorizontalLayout.h"
#import "AYHomeHistoryItem.h"
#import "AYHomeLikesItem.h"

@interface AYHomeLikesCellView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation AYHomeLikesCellView {
    UICollectionView *showCollectionView;
    
    NSArray *queryData;
    
    NSNumber *cellHeight;
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
        title = [Tools setLabelWith:title andText:@"我心仪的服务" andTextColor:[Tools blackColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        title.font = [UIFont fontWithName:@"STHeitiSC-Light" size:24.f];
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
        }];
        
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        AYHorizontalLayout *layout = [[AYHorizontalLayout alloc] init];
//        layout.itemSize = CGSizeMake((width - 30), 370);
//        layout.itemSize = CGSizeMake((width - 30), self.bounds.size.height);
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.itemSize = CGSizeMake((width - 30 - 10)/2, 180);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        showCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        showCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        showCollectionView.showsHorizontalScrollIndicator = NO;
        showCollectionView.showsVerticalScrollIndicator = NO;
        showCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        [showCollectionView registerClass:[AYHomeLikesItem class] forCellWithReuseIdentifier:NSStringFromClass([AYHomeLikesItem class])];
        [showCollectionView setBackgroundColor:[UIColor clearColor]];
        showCollectionView.delegate = self;
        showCollectionView.dataSource = self;
        [self addSubview:showCollectionView];
        [showCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 15, 10, 15));
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
    id<AYViewBase> cell = VIEW(@"HomeLikesCell", @"HomeLikesCell");
    
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
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
    
    queryData = [(NSDictionary*)args objectForKey:@"collect_data"];
    [showCollectionView reloadData];
    return nil;
}

#pragma mark -- uicollectionviewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return queryData.count/4 + 1;
    
//    if (queryData.count < 4) {
//        return 1;
//    } else return queryData.count * 0.25;
    
    BOOL isB = queryData.count % 4 > 0;
    if (isB) {
        return queryData.count * 0.25 + 1;
    } else return queryData.count * 0.25;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AYHomeLikesItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AYHomeLikesItem class]) forIndexPath:indexPath];
    
    NSMutableArray *tmp = [NSMutableArray array];
    for (int i = 0; i < 4; ++i) {
        NSInteger limit_index = indexPath.row + i;
        if (limit_index < queryData.count) {
            [tmp addObject:[queryData objectAtIndex:limit_index]];
        }
    }
    cell.itemInfo = [tmp copy];
    
    cell.didTouchUpInServiceCell = ^(NSDictionary *service_info) {
        id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd_show_module = PUSH;
        [cmd_show_module performWithResult:&dic];
    };
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmp = [queryData objectAtIndex:indexPath.row];
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
}

- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake((width - 30), collectionView.bounds.size.height);
}

@end
