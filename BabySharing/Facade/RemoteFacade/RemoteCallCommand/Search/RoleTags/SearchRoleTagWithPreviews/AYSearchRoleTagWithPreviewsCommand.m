//
//  AYSearchRoleTagWithPreviewsCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchRoleTagWithPreviewsCommand.h"

@implementation AYSearchRoleTagWithPreviewsCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
