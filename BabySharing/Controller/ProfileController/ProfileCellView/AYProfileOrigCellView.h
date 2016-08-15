//
//  AYProfileOrigCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 7/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYProfileOrigCellView : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottom_line;
@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, strong) NSDictionary *dic_info;
@end
