//
//  AYUserTablePreviewDelegate.m
//  BabySharing
//
//  Created by BM on 4/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserTablePreviewDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYUserTableCellDefines.h"
#import "AYControllerActionDefines.h"

@implementation AYUserTablePreviewDelegate {
    NSArray* querydata;
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
    return querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
   
    if (cell == nil) {
        cell = VIEW(kAYUserTableCellName, kAYUserTableCellName);
    }
    
    cell.controller = self.controller;
    
    NSDictionary* tmp = [querydata objectAtIndex:indexPath.row];
    NSLog(@"user info is %@", tmp);
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:cell forKey:kAYUserTableCellCellKey];
    [args setValue:[tmp objectForKey:@"user_id"] forKey:kAYUserTableCellUserIDKey];
    [args setValue:[tmp objectForKey:@"screen_name"] forKey:kAYUserTableCellScreenNameKey];
    [args setValue:[tmp objectForKey:@"screen_photo"] forKey:kAYUserTableCellScreenPhotoKey];
    [args setValue:[tmp objectForKey:@"role_tag"] forKey:kAYUserTableCellRoleTagKey];
    [args setValue:[tmp objectForKey:@"relations"] forKey:kAYUserTableCellRelationKey];
    [args setValue:[tmp objectForKey:@"preview"] forKey:kAYUserTableCellImgPreviewKey];
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [cmd performWithResult:&args];
    
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    id<AYViewBase> view = VIEW(kAYUserTableCellName, kAYUserTableCellName);
    id<AYCommand> cmd = [view.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* tmp = [querydata objectAtIndex:indexPath.row];
    NSString* user_id = [tmp objectForKey:@"user_id"];

    UIViewController* des = DEFAULTCONTROLLER(@"Profile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:user_id forKey:kAYControllerChangeArgsKey];
    
    [_controller performWithResult:&dic_push];
}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    querydata = (NSArray*)args;
    return nil;
}
@end
