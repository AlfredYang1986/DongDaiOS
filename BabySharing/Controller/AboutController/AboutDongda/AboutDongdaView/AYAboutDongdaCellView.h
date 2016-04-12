//
//  AYAboutDongdaCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 12/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYAboutDongdaCellView : UITableViewCell<AYViewBase,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *image;
@end
