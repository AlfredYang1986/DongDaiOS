//
//  AYHomeAssortmentCellItem.h
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYHomeAssortmentCellItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImage;
- (void)setItemInfo:(NSDictionary*)itemInfo;

@end
