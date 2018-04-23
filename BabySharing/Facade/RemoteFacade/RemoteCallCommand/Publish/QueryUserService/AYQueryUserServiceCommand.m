//
//  AYQueryUserServiceCommand.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/11.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYQueryUserServiceCommand.h"

@implementation AYQueryUserServiceCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

@end
