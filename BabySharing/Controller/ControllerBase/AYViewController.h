//
//  AYViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AYControllerBase.h"

@protocol AYViewBase;
@interface AYViewController : UIViewController <AYControllerBase>
@property (nonatomic, weak) id<AYViewBase> loading;

- (void)clearController;
@end

#import "AYControllerActionDefines.h"
