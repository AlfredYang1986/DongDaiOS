//
//  AYTabBarServiceController.h
//  BabySharing
//
//  Created by Alfred Yang on 11/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYControllerBase.h"

@interface AYTabBarServiceController : UITabBarController <AYControllerBase>
@property (nonatomic, assign) NSNumber *type;
@end
