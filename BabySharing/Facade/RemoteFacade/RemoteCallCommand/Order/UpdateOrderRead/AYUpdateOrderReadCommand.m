//
//  AYUpdateOrderReadCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 5/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYUpdateOrderReadCommand.h"

@implementation AYUpdateOrderReadCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
