//
//  AYUserRelationsDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserRelationsDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYUserDisplayDefines.h"

@interface AYUserRelationsDelegate ()
@property (nonatomic, weak, readonly, getter=getCurrentShowingData) NSArray* querydata;
@end

@implementation AYUserRelationsDelegate {
    NSArray* friends_data;
    NSArray* following_data;
    NSArray* followed_data;
    
    int current_showing_index;
}

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
    return [self.querydata count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserDisplayTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
    }
  
    NSDictionary* tmp = [self.querydata objectAtIndex:indexPath.row];
    {
        id<AYCommand> cmd = [cell.commands objectForKey:@"setDisplayUserInfo:"];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[tmp objectForKey:@"user_id"] forKey:kAYUserDisplayTableCellSetUserIDKey];
        [dic setValue:[tmp objectForKey:@"screen_photo"] forKey:kAYUserDisplayTableCellSetUserScreenPhotoKey];
        [dic setValue:[tmp objectForKey:@"relations"] forKey:kAYUserDisplayTableCellSetUserRelationsKey];
        [dic setValue:[tmp objectForKey:@"screen_name"] forKey:kAYUserDisplayTableCellSetUserScreenNameKey];
        [dic setValue:[tmp objectForKey:@"role_tag"] forKey:kAYUserDisplayTableCellSetUserRoleTagKey];
        [dic setValue:cell forKey:kAYUserDisplayTableCellKey];
        
        [cmd performWithResult:&dic];
    }
    
    return (UITableViewCell*)cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
    id<AYCommand> cmd = [cell.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

#pragma mark -- message commands
- (id)isFriendsDataReady {
    return [NSNumber numberWithBool:friends_data != nil];
}

- (id)isFollowingDataReady {
    return [NSNumber numberWithBool:following_data != nil];
}

- (id)isFollowedDataReady {
    return [NSNumber numberWithBool:followed_data != nil];
}

- (id)changeFriendsData:(id)obj {
    friends_data = (NSArray*)obj;
    return nil;
}

- (id)changeFollowingData:(id)obj {
    following_data = (NSArray*)obj;
    return nil;
}

- (id)changeFollowedData:(id)obj {
    followed_data = (NSArray*)obj;
    return nil;
}

- (id)resetCurrentShowingIndex:(id)obj {
    current_showing_index = ((NSNumber*)obj).intValue;
    return nil;
}

- (NSArray*)getCurrentShowingData {
    switch (current_showing_index) {
        case 0:
            return friends_data;
        case 1:
            return following_data;
        case 2:
            return followed_data;
        default:
            return nil;
    }
}
@end
