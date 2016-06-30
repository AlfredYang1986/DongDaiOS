//
//  AYContentListDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 13/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYContentListDelegate.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@implementation AYContentListDelegate{
    NSArray *querydata;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)changeQueryData:(NSArray*)array{
    querydata = array;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return querydata.count;
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ContentListCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(@"ContentListCell", @"ContentListCell");
    }
    
    cell.controller = self.controller;
    
    
    id tmp = [querydata objectAtIndex:indexPath.row];
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [cmd performWithResult:&tmp];
    
    return (UITableViewCell*)cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 150;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end
