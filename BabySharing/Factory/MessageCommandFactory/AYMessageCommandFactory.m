//
//  AYMessageCommandFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMessageCommandFactory.h"
#import "AYMessageCommand.h"

@implementation AYMessageCommandFactory

@synthesize para = _para;

- (id)createInstance  {
    return [AYMessageCommand sharedInstance];
}
@end
