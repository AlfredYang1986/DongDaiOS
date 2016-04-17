//
//  AYFoundRoleTagDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundRoleTagDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"

#import "Tools.h"
#import "AYSearchDefines.h"

@implementation AYFoundRoleTagDelegate {
    NSArray* querydata;
    NSArray* previewDic;
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
#define PHOTO_PER_LINE      3
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (previewDic.count == 0) {
        return 1;
    } else {
        return previewDic.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (previewDic == nil || previewDic.count == 0) {
        id<AYViewBase> cell= [tableView dequeueReusableCellWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:FoundHotCell] stringByAppendingString:kAYFactoryManagerViewsuffix] forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(FoundHotCell, FoundHotCell);
        }
        
        cell.controller = self.controller;
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setHotTagsText:"];
        NSArray* arr = [querydata copy];
        [cmd performWithResult:&arr];
        
        return (UITableViewCell*)cell;
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        if (cell ==  nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"alfred test";
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> header = VIEW(FoundHotCell, FoundHotCell);
    id<AYCommand> cmd = [header.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<AYViewBase> header = VIEW(FoundSearchHeader, FoundSearchHeader);
    id<AYCommand> cmd = [header.commands objectForKey:@"queryHeaderHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<AYViewBase> header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:FoundSearchHeader] stringByAppendingString:kAYFactoryManagerViewsuffix]];
    if (header == nil) {
        header = VIEW(FoundSearchHeader, FoundSearchHeader);
    }
    
    header.controller = self.controller;
   
    {
        id<AYCommand> cmd = [header.commands objectForKey:@"changeHeaderTitle:"];
        NSString* str = nil;
        if (previewDic.count == 0) {
            str = @"热门角色";
        } else {
            str = @"搜索结果";
        }
        [cmd performWithResult:&str];
    }
    
    {
        id<AYCommand> cmd = [header.commands objectForKey:@"isLeftAlignment:"];
        NSNumber* b = [NSNumber numberWithBool:YES];
        [cmd performWithResult:&b];
    }
    
    UITableViewHeaderFooterView* v = (UITableViewHeaderFooterView*)header;
    v.backgroundView = [[UIImageView alloc] initWithImage:[Tools imageWithColor:[UIColor whiteColor] size:v.bounds.size]];
    return (UIView*)header;
}

#pragma mark -- messages
- (id)changeQueryData:(id)obj {
    querydata = (NSArray*)obj;
    return nil;
}

- (id)changePreviewData:(id)obj {
    previewDic = (NSArray*)obj;
    return nil;
}
@end
