//
//  AYPostPublishController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"

@interface AYPostPublishController : AYViewController

@property (nonatomic, strong) UIImageView* mainContentView;

- (NSString*)getNavTitle;
@end
