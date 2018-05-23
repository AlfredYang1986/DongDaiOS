//
//  AYQueryBrandIDCommand.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/26.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYQueryBrandIDCommand.h"

@implementation AYQueryBrandIDCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

@end
