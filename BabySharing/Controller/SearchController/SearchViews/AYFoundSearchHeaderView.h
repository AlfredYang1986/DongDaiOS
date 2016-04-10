//
//  AYFoundSearchHeaderView.h
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYFoundSearchHeaderView : UITableViewHeaderFooterView <AYViewBase>
@property (weak, nonatomic) IBOutlet UILabel *headLabell;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *line;
+ (CGFloat)prefferredHeight;
@end
