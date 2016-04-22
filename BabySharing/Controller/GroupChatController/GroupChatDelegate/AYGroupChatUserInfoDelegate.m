//
//  AYGroupChatUserInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYGroupChatUserInfoDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYSearchDefines.h"
#import "AYUserDisplayDefines.h"
#import "Tools.h"

@implementation AYGroupChatUserInfoDelegate {
    NSArray* querydata;
    NSDictionary* owner_info;
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
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == 0) {
     
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserDisplayTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
        }
        
        NSDictionary* tmp = owner_info;
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
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"alfred test";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> view = nil;
    if (indexPath.row == 0) {
        view = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
    } else {
//        view = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
        return 115;
    }
    
    id<AYCommand> cmd = [view.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    
    return result.floatValue;
}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    owner_info = [dic objectForKey:@"owner"];
    querydata = [dic objectForKey:@"joiners"];
    return nil;
}
@end
