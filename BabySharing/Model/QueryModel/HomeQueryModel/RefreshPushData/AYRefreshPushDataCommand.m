//
//  AYRefreshPushDataCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRefreshPushDataCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "QueryContent.h"
#import "QueryContent+ContextOpt.h"

@implementation AYRefreshPushDataCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"push content : %@", *obj);
    NSDictionary* result = (NSDictionary*)*obj;
    
    NSString* post_id = [result objectForKey:@"post_id"];
//    NSNumber* push_result = [result objectForKey:@"push_result"];
    
    AYModelFacade* f = HOMECONTENTMODEL;
    NSArray* push_array =  [[result objectForKey:@"result"] objectForKey:@"push"];
    NSNumber* push_count =  [[result objectForKey:@"result"] objectForKey:@"push_count"];
    [QueryContent refreshLikesToPostWithID:post_id withArr:push_array andLikesCount:push_count inContext:f.doc.managedObjectContext];
//    [QueryContent refreshLikesToPostWithID:post_id withArr:like_array andLikesCount:like_count inContext:f.doc.managedObjectContext];
//    [QueryContent refreshIslike:like_result postId:post_id inContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
