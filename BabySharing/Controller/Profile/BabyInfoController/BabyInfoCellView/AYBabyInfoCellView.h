//
//  AYBabyInfoCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 12/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

@interface AYBabyInfoCellView : UITableViewCell <AYViewBase>

@property(nonatomic, strong) NSDictionary *dic_info;
@end
