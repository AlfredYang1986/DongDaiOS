//
//  MessageChatGroupHeader3.h
//  BabySharing
//
//  Created by Alfred Yang on 3/11/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

@interface AYGroupChatHeaderView : UIView <AYViewBase>

@property (nonatomic, strong, setter=setThemeLabelText:) NSString* theme_label_text;
@property (nonatomic, strong, setter=setThemeTags:) NSArray* theme_tags;

- (CGFloat)preferredHeight;
@end
