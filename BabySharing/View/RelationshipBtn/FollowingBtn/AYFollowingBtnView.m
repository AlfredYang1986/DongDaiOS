//
//  AYFollowingBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFollowingBtnView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"

@implementation AYFollowingBtnView
- (void)postPerform {
    [super postPerform];
    [self setBackgroundImage:PNGRESOURCE(@"friend_relation_following") forState:UIControlStateNormal];
}

- (void)selfClicked {
    
}
@end
