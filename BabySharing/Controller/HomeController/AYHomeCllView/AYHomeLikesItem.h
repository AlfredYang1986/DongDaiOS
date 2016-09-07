//
//  AYHomeLikesItem.h
//  BabySharing
//
//  Created by Alfred Yang on 5/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^touchUpInSubCell)(NSDictionary*);

@interface AYHomeLikesItem : UICollectionViewCell

@property (nonatomic, strong) NSArray *itemInfo;

@property (nonatomic, strong) touchUpInSubCell didTouchUpInServiceCell;

@end
