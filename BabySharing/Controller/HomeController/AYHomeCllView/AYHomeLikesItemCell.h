//
//  AYHomeLikesItemCell.h
//  BabySharing
//
//  Created by Alfred Yang on 6/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchUpInSelf)(NSDictionary*);

@interface AYHomeLikesItemCell : UIView

@property (nonatomic, strong) NSDictionary *cellInfo;
@property (nonatomic, strong) touchUpInSelf touchupinself;

@end
