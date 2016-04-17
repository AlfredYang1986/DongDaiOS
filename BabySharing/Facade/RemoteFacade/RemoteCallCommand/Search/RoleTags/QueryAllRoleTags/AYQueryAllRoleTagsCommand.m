//
//  AYQueryAllRoleTagsCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryAllRoleTagsCommand.h"

@implementation AYQueryAllRoleTagsCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
