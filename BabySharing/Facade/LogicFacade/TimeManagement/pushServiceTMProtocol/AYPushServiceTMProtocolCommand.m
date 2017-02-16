//
//  AYPushServiceTMProtocolCommand.m
//  BabySharing
//
//  Created by BM on 15/02/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import "AYPushServiceTMProtocolCommand.h"
#import "AYFactoryManager.h"

@implementation AYPushServiceTMProtocolCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    // need to be modified
    
    NSMutableArray* result = [[NSMutableArray alloc]init];
    
    NSArray* offer_date = (NSArray*)*obj;
    NSLog(@"选择的时间是：%@", offer_date);
    
    for (NSDictionary* dic in offer_date) {
        int day = ((NSNumber*)[dic objectForKey:@"day"]).intValue;
        
        NSMutableDictionary* re_one = [[NSMutableDictionary alloc]init];
        [re_one setValue:[NSNumber numberWithLong:[self startdateFromDay:day]] forKey:@"startdate"];
        [re_one setValue:[NSNumber numberWithLong:[self enddateFromDay:day]] forKey:@"enddate"];
        
        for (NSDictionary* hours in [dic objectForKey:@"occurance"]) {
            NSNumber* starthours = [hours objectForKey:@"start"];
            NSNumber* endhours = [hours objectForKey:@"end"];
            NSLog(@"start hour is %@", starthours);
            
            NSMutableDictionary* re = [re_one mutableCopy];
            [re setValue:starthours forKey:@"starthours"];
            [re setValue:endhours forKey:@"endhours"];
            
            [re setValue:[NSNumber numberWithInt:1] forKey:@"pattern"];
            
            [result addObject:[re copy]];
        }
        
        //[result addObject:[re_one copy]];
    }
    
    NSLog(@"time managemant result is %@", result);
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

#pragma mark -- get day 
- (long)startdateFromDay:(int)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger cur = [comps weekday] % 7;
    
    NSInteger gap = (day + cur) * 60 * 60 * 24;
    return ([now timeIntervalSince1970] + gap) * 1000;
}

- (long)enddateFromDay:(int)day {
    return -1;
}
@end
