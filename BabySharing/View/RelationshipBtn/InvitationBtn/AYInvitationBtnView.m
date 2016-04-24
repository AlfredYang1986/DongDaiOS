//
//  AYInvitationBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInvitationBtnView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"

@implementation AYInvitationBtnView
- (void)postPerform {
    [super postPerform];
    [self setBackgroundImage:PNGRESOURCE(@"friend_invitation") forState:UIControlStateNormal];
}

- (void)selfClicked {
    
}
@end
