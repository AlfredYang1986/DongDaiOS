//
//  AYUpdateUserDetailCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUpdateUserDetailCommand.h"
#import "RemoteInstance.h"

@implementation AYUpdateUserDetailCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"request confirm code from sever: %@", args);
//    NSError * error = nil;
//    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingPrettyPrinted error:&error];
//    
//    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:self.route]];
//    NSLog(@"request result from sever: %@", result);
//    
//    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
//        NSDictionary* reVal = [result objectForKey:@"result"];
//        block(YES, reVal);
//    } else {
//        NSDictionary* reError = [result objectForKey:@"error"];
//        block(NO, reError);
//    }
}
@end
