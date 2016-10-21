//
//  AYPlayItemsView.h
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYPlayItemsView : UIView
@property(nonatomic, strong) UIImageView *item_icon;
@property(nonatomic, strong) UILabel *item_name;
@property(nonatomic, strong) NSDictionary *item_info;
@end
