//
//  AYQueryApplicationCommand.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYQueryApplicationCommand.h"

@implementation AYQueryApplicationCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}


@end
