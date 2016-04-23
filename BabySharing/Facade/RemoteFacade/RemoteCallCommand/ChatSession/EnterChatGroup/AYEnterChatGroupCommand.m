//
//  AYEnterChatGroupCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEnterChatGroupCommand.h"

@implementation AYEnterChatGroupCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
