//
//  AYCollectionViewLayout.m
//  BabySharing
//
//  Created by Alfred Yang on 2/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHorizontalLayout.h"

@implementation AYHorizontalLayout
- (instancetype) init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    return self;
}

- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(64, collectionView.bounds.size.height);
}
@end
