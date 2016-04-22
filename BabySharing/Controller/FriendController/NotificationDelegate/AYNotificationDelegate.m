//
//  AYNotificationDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYNotificationDelegate.h"
#import "AYNotificationCellDefines.h"
#import "AYFactoryManager.h"

#import "Notifications.h"

@interface AYNotificationDelegate ()
@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYNotificationDelegate

@synthesize querydata = _querydata;

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
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYNotificationCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];

    if (cell == nil) {
        cell = VIEW(kAYNotificationCellName, kAYNotificationCellName);
    }
    
    cell.controller = self.controller;
    
    id tmp = [self.querydata objectAtIndex:indexPath.row];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:tmp forKey:kAYNotificationCellContentKey];
    [dic setValue:cell forKey:kAYNotificationCellCellKey];
   
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell = VIEW(kAYNotificationCellName, kAYNotificationCellName);
    id<AYCommand> cmd = [cell.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    self.querydata = (NSArray*)args;
    return nil;
}
@end
