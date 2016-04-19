//
//  AYContatcerInSystemCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 18/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYContatcerInSystemCommand.h"

@implementation AYContatcerInSystemCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
