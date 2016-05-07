//
//  HomeCell.h
//  BabySharing
//
//  Created by monkeyheng on 16/3/10.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryContent.h"
//#import "QueryCellDelegate.h"
#import "AYQueryModelDefines.h"
#import "AYViewBase.h"

@interface AYHomeCellView : UITableViewCell <AYViewBase>

@property (nonatomic, strong) UILabel *number;
@property (nonatomic, weak) NSIndexPath *indexPath;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath;
- (void)stopViedo;
- (void)updateViewWith:(QueryContent *)content;

@end
