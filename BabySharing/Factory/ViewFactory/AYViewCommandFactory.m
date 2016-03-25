//
//  AYViewCommandFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYViewCommandFactory.h"
#import "AYViewCommand.h"

@implementation AYViewCommandFactory

@synthesize para = _para;

+ (id)factoryInstance {
        static AYViewCommandFactory* instance = nil;
        if (instance == nil) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                instance = [[self alloc]init];
            });
        }
        return instance;
//    return [[self alloc]init];
}

- (id)createInstance {
    NSLog(@"para is : %@", _para);
    
//    NSString* desFacade = [self.para objectForKey:@"view"];
//    id<AYViewBase> result = nil;
//    
//    Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desFacade] stringByAppendingString:kAYFactoryManagerViewsuffix]);
//    if (c == nil) {
//        @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
//    } else {
//        result = [[c alloc]init];
//        [result postPerform];
//    }
//    
//    return result;
    return nil;
}
@end
