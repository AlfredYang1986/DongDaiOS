//
//  AYQueryHomeContentCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryHomeContentCommand.h"

@implementation AYQueryHomeContentCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
