//
//  AYRemoteCallCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallCommand.h"
//#import "AYCommandDefines.h"

@implementation AYRemoteCallCommand

@synthesize para = _para;
@synthesize route = _route;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    @throw [[NSException alloc]initWithName:@"error" reason:@"异步调用函数不能调用同步函数" userInfo:nil];
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    @throw [[NSException alloc]initWithName:@"error" reason:@"不要从基类调用，从具体的Command进行调用" userInfo:nil];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeRemote;
}
@end
