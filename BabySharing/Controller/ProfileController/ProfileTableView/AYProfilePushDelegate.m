//
//  AYProfilePushDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYProfilePushDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "QueryContent.h"
#import "QueryContentItem.h"
#import "AYAlbumDefines.h"
#import "AYQueryModelDefines.h"
#import "AYFactoryManager.h"

#import "Notifications.h"

@interface AYProfilePushDelegate ()
@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYProfilePushDelegate{
    
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ProfilePushCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(@"ProfilePushCell", @"ProfilePushCell");
    }
    
    cell.controller = self.controller;
    
//    id tmp = [self.querydata objectAtIndex:indexPath.row];
//    NSDictionary* dic = [tmp mutableCopy];
//    
//    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
//    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell = VIEW(@"ProfilePushCell", @"ProfilePushCell");
    id<AYCommand> cmd = [cell.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5.f;
//}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    self.querydata = (NSArray*)args;
    return nil;
}
@end
