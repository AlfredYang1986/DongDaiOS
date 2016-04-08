//
//  AYFoundHotTagsCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYFoundHotTagsCellView : UITableViewCell <AYViewBase>
@property (nonatomic) BOOL isDarkTheme;
@property (nonatomic, setter=setHiddenLine:) BOOL isHiddenSepline;
@property (nonatomic) CGFloat ver_margin;
@end
