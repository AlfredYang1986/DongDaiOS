//
//  AYTagEntryView.h
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYTagEntryView : UIView <AYViewBase>
@property(strong, nonatomic) UIView* tagBand;
@property(strong, nonatomic) UIView* tagTime;
@property(strong, nonatomic) UIView* tagLocal;
@end
