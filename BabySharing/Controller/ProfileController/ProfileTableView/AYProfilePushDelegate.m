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
    
    
    id tmp = [self.querydata objectAtIndex:indexPath.row];
    NSLog(@"sunfei -- %@",tmp);
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [cmd performWithResult:&tmp];
    
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

//-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<AYViewBase> cell = VIEW(@"ProfilePushCell", @"ProfilePushCell");
    cell.controller = self.controller;
    id<AYCommand> cmd = [cell.notifies objectForKey:@"selectedValueChanged:"];
    id args = [NSNumber numberWithFloat:indexPath.row];
    [cmd performWithResult:&args];
    
}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    
    NSArray* transArray = (NSArray*)args;
    
    NSMutableArray* tempArr = nil;
    tempArr = [[NSMutableArray alloc] initWithCapacity:transArray.count];
    for (QueryContent* item in transArray) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        
        for (QueryContentItem * cur in item.items) {
            if (cur.item_type.unsignedIntegerValue != PostPreViewMovie) {
                [dict setObject:cur.item_name forKey:@"owner_photo"];
                break;
            }
        }
        [dict setObject:item.owner_name forKey:@"owner_name"];
        [dict setObject:item.content_description forKey:@"content_description"];
        [dict setObject:item.content_post_date forKey:@"content_post_date"];
        
        [tempArr addObject:dict];
    }
    self.querydata = [tempArr copy];
    return nil;
}
@end
