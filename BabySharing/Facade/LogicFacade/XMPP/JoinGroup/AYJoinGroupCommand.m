//
//  AYJoinGroupCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYJoinGroupCommand.h"
#import "GotyeOCAPI.h"

@implementation AYJoinGroupCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSNumber* group_id = (NSNumber*)*obj;
    GotyeOCGroup* group = [GotyeOCGroup groupWithId:group_id.longLongValue];
    [GotyeOCAPI joinGroup:group];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
