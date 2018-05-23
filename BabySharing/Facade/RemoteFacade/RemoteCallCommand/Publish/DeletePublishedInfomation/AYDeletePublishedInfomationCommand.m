//
//  AYDeletePublishedInfomationCommand.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/18.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYDeletePublishedInfomationCommand.h"

@implementation AYDeletePublishedInfomationCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

@end
