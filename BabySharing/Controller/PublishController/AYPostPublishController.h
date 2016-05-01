//
//  AYPostPublishController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"

typedef enum : NSUInteger {
    AYPostPublishControllerStatusReady,
    AYPostPublishControllerStatusInputing,
} AYPostPublishControllerStatus;

@interface AYPostPublishController : AYViewController

@property (nonatomic, setter=setCurrentStatus:) AYPostPublishControllerStatus status;
@property (nonatomic, strong) UIImageView* mainContentView;
@property (nonatomic, strong) NSArray* tags;

- (NSString*)getNavTitle;
- (void)setCurrentStatus:(AYPostPublishControllerStatus)status;
- (void)didSelectPostBtn;
@end
