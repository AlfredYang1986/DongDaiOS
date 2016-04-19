//
//  AYPostPreviewController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"

typedef enum : NSUInteger {
    AYPostPhotoPreviewControllerTypeShowingTagsEntryBtn,
    AYPostPhotoPreviewControllerTypeSegAtTags,
    AYPostPhotoPreviewControllerTypeSegAtFilter,
} AYPostPhotoPreviewControllerType;

@interface AYPostPreviewController : AYViewController
@property (nonatomic, strong) UIImageView* mainContentView;
@property (nonatomic, setter=setCurrentStatus:) AYPostPhotoPreviewControllerType status;

- (NSString*)getNavTitle;
- (NSArray*)getFunctionBarItems;
@end
