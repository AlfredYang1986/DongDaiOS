//
//  AYJoinChatGroupCommand.m
//  BabySharing
//
//  Created by BM on 4/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYJoinChatGroupCommand.h"

@implementation AYJoinChatGroupCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
