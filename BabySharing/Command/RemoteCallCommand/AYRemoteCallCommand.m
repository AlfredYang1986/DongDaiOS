//
//  AYRemoteCallCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallCommand.h"
//#import "AYCommandDefines.h"
#import "RemoteInstance.h"

@implementation AYRemoteCallCommand

@synthesize para = _para;
@synthesize route = _route;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    @throw [[NSException alloc]initWithName:@"error" reason:@"异步调用函数不能调用同步函数" userInfo:nil];
}

//- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
//    @throw [[NSException alloc]initWithName:@"error" reason:@"不要从基类调用，从具体的Command进行调用" userInfo:nil];
//}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"request confirm code from sever: %@", args);
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingPrettyPrinted error:&error];

    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:self.route]];
    NSLog(@"request result from sever: %@", result);

    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        block(YES, reVal);
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        block(NO, reError);
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeRemote;
}
@end
