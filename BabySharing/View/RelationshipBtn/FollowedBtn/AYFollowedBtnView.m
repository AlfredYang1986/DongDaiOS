//
//  AYFollowedBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFollowedBtnView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"

@implementation AYFollowedBtnView
- (void)postPerform {
    [super postPerform];
    [self setBackgroundImage:PNGRESOURCE(@"friend_relation_follow") forState:UIControlStateNormal];
}

- (void)selfClicked {
    
}
@end
