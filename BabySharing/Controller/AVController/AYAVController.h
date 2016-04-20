//
//  AYAVController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"

@interface AYAVController : AYViewController

@property (nonatomic) NSInteger current_seg_index;

- (id)FunctionBarLayout:(UIView*)view;
- (id)FakeNavBarLayout:(UIView*)view;
- (id)SetNevigationBarTitleLayout:(UIView*)view;
- (id)DongDaSegLayout:(UIView*)view;
@end
