//
//  AYRoleTagRecommendCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagRecommendDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYSearchDefines.h"
#import "Tools.h"

@implementation AYTagRecommendDelegate

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize recommands_tags = _recommands_tags;

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
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell= [tableView dequeueReusableCellWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundHotCellName] stringByAppendingString:kAYFactoryManagerViewsuffix] forIndexPath:indexPath];
    if (cell == nil) {
        cell = VIEW(kAYFoundHotCellName, kAYFoundHotCellName);
    }
    
    cell.controller = self.controller;
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"setHotTagsText:"];
    NSArray* arr = [_recommands_tags copy];
    [cmd performWithResult:&arr];
    
    return (UITableViewCell*)cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id<AYViewBase> header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundSearchHeaderName] stringByAppendingString:kAYFactoryManagerViewsuffix]];
    if (header == nil) {
        header = VIEW(kAYFoundSearchHeaderName, kAYFoundSearchHeaderName);
    }
    
    header.controller = self.controller;
    
    id<AYCommand> cmd = [header.commands objectForKey:@"changeHeaderTitle:"];
    NSString* str = @"选择或者添加一个你的角色";
    [cmd performWithResult:&str];
    
    UITableViewHeaderFooterView* v = (UITableViewHeaderFooterView*)header;
    v.backgroundView = [[UIImageView alloc] initWithImage:[Tools imageWithColor:[UIColor whiteColor] size:v.bounds.size]];
    return (UIView*)header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> header = VIEW(kAYFoundHotCellName, kAYFoundHotCellName);
    id<AYCommand> cmd = [header.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<AYViewBase> header = VIEW(kAYFoundSearchHeaderName, kAYFoundSearchHeaderName);
    id<AYCommand> cmd = [header.commands objectForKey:@"queryHeaderHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

#pragma mark -- command
- (id)changeQueryData:(id)obj {
    _recommands_tags = (NSArray*)obj;
    return nil;
}
@end
