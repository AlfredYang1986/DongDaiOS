//
//  AYMessageCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMessageCommand.h"
#import "AYCommandDefines.h"
#import "GotyeOCAPI.h"

static NSString* const kAYMessageCommandRegisterID = @"1afd2cc8-4060-41eb-aa5a-ee9460370156";
static NSString* const kAYMessageCommandRegisterName = @"DongDa";

static AYMessageCommand* instance = nil;

@implementation AYMessageCommand

@synthesize para = _para;

+ (AYMessageCommand*)sharedInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+ (id) allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)init {
    @synchronized(self) {
        self = [super init];
        if (self) {
            
        }
        return self;
    }
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeMessage;
}

- (void)postPerform {
    status im_register_result = [GotyeOCAPI init:kAYMessageCommandRegisterID packageName:kAYMessageCommandRegisterName];
    if (im_register_result != GotyeStatusCodeOK) {
        NSLog(@"IM Register Error!");
    } else {
        NSLog(@"IM Register Success!");
    }
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {

}
@end
