//
//  AYPublishInfomationCommand.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/18.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYPublishInfomationCommand.h"

@implementation AYPublishInfomationCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

@end
