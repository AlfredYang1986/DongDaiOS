//
//  PhotoTagEditView.h
//  BabySharing
//
//  Created by Alfred Yang on 1/22/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTagEnumDefines.h"
#import "OBShapedButton.h"
#import "AYCommand.h"
#import "AYViewBase.h"

@interface AYTagEditView : OBShapedButton <AYViewBase>

@property (nonatomic, weak) id effect_view;
@property (nonatomic) TagType tag_type;

- (void)setUpView;
- (void)setUpReuseCommands;
@end
