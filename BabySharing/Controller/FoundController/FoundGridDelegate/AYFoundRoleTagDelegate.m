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
#import "AYFoundSearchResultCellDefines.h"

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (previewDic.count == 0) {
        return 1;
    } else {
        return previewDic.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (previewDic == nil || previewDic.count == 0) {
        id<AYViewBase> cell= [tableView dequeueReusableCellWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundHotCellName] stringByAppendingString:kAYFactoryManagerViewsuffix] forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(kAYFoundHotCellName, kAYFoundHotCellName);
        }
        
        cell.controller = self.controller;
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setHotTagsText:"];
        NSArray* arr = [querydata copy];
        [cmd performWithResult:&arr];
        
        return (UITableViewCell*)cell;
    } else {
        id<AYViewBase> cell= [tableView dequeueReusableCellWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundSearchResultCellName] stringByAppendingString:kAYFactoryManagerViewsuffix] forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(kAYFoundSearchResultCellName, kAYFoundSearchResultCellName);
        }
        
        cell.controller = self.controller;
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        
        NSDictionary* tmp = [previewDic objectAtIndex:indexPath.row];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:cell forKey:kAYFoundSearchResultCellCellKey];
        [dic setValue:[NSNumber numberWithInteger:-1] forKey:kAYFoundSearchResultCellTagTypeKey];
        [dic setValue:[tmp objectForKey:@"role_tag"] forKey:kAYFoundSearchResultCellTagNameKey];
        [dic setValue:[tmp objectForKey:@"content"] forKey:kAYFoundSearchResultCellContentKey];
        
        [cmd performWithResult:&dic];
        
        return (UITableViewCell*)cell;
    }
    
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

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<AYViewBase> header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundSearchHeaderName] stringByAppendingString:kAYFactoryManagerViewsuffix]];
    if (header == nil) {
        header = VIEW(kAYFoundSearchHeaderName, kAYFoundSearchHeaderName);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (previewDic != nil && previewDic.count != 0) {
        NSDictionary* dic = [previewDic objectAtIndex:indexPath.row];
        NSString* role_tag = [dic objectForKey:@"role_tag"];
        
        AYViewController* des = DEFAULTCONTROLLER(@"UserPerview");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        
        [dic_push setValue:role_tag forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (previewDic == nil || previewDic.count == 0) {
        return NO;
    } else return YES;
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollToHideKeyBoard"];
    [cmd performWithResult:nil];
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
