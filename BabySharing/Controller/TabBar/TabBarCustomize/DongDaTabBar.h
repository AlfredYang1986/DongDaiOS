//
//  DongDaTabBar.h
//  BabySharing
//
//  Created by Alfred Yang on 14/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DongDaTabBar;

@protocol DongDaTabBarDelegate <NSObject>
/**
 *  工具栏按钮被选中, 记录从哪里跳转到哪里. (方便以后做相应特效)
 */
- (void) tabBar:(DongDaTabBar *)tabBar selectedFrom:(NSInteger) from to:(NSInteger)to;

@end

@interface DongDaTabBar : UIView <UITabBarDelegate>

@property(nonatomic,weak) id<DongDaTabBarDelegate> delegate;

@property (nonatomic, readonly, getter=getTabBarItems) NSArray* items;
@property (nonatomic, readonly, getter=getTabBarItemCount) NSInteger count;
@property (nonatomic, getter=getCurrentSelectedIndex, setter=setCurrentSelectedIndex:) NSInteger selectIndex;
@property (nonatomic, weak) UITabBarController* bar;

- (id)initWithBar:(UITabBarController*)bar;
- (void)addMidItemWithImg:(UIImage*)image;
- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg;
- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg andTitle:(NSString*)title;
- (void)itemSelected:(UIButton*)sender;

- (void)changeItemImage:(UIImage*)img andIndex:(NSInteger)index;
@end
