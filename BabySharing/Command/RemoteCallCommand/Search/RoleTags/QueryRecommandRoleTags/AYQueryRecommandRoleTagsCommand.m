//
//  AYQueryRecommandRoleTagsCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryRecommandRoleTagsCommand.h"

@implementation AYQueryRecommandRoleTagsCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
