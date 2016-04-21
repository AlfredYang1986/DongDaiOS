//
//  AYFoundTagsDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundTagsDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"

#import "Tools.h"
#import "AYSearchDefines.h"
#import "AYFoundSearchResultCellDefines.h"

@implementation AYFoundTagsDelegate {
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
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setHotTags:"];
       
        NSArray* arr = [querydata copy];
        [cmd performWithResult:&arr];
        
        CALayer *line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(0, CGRectGetMaxY(((UITableViewCell*)cell).frame) - 1, [UIScreen mainScreen].bounds.size.width, 1);
        [((UITableViewCell*)cell).layer addSublayer:line];
        
        CALayer *line1 = [CALayer layer];
        line1.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.1].CGColor;
        line.borderWidth = 1.f;
        line1.frame = CGRectMake(0, CGRectGetMaxY(((UITableViewCell*)cell).frame), [UIScreen mainScreen].bounds.size.width, 1);
        [((UITableViewCell*)cell).layer addSublayer:line1];
        
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
        [dic setValue:[tmp objectForKey:@"type"] forKey:kAYFoundSearchResultCellTagTypeKey];
        [dic setValue:[tmp objectForKey:@"tag_name"] forKey:kAYFoundSearchResultCellTagNameKey];
        [dic setValue:[tmp objectForKey:@"content"] forKey:kAYFoundSearchResultCellContentKey];
        
        [cmd performWithResult:&dic];
        
        CALayer *line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(0, CGRectGetMaxY(((UITableViewCell*)cell).frame) - 1, [UIScreen mainScreen].bounds.size.width, 1);
        [((UITableViewCell*)cell).layer addSublayer:line];
        
        CALayer *line1 = [CALayer layer];
        line1.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.1].CGColor;
        line.borderWidth = 1.f;
        line1.frame = CGRectMake(0, CGRectGetMaxY(((UITableViewCell*)cell).frame), [UIScreen mainScreen].bounds.size.width, 1);
        [((UITableViewCell*)cell).layer addSublayer:line1];
        
        return (UITableViewCell*)cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYCommand> cmd = nil;
    if (previewDic.count == 0) {
        id<AYViewBase> header = VIEW(kAYFoundHotCellName, kAYFoundHotCellName);
        cmd = [header.commands objectForKey:@"queryCellHeight"];
    } else {
        id<AYViewBase> header = VIEW(kAYFoundSearchResultCellName, kAYFoundSearchResultCellName);
        cmd = [header.commands objectForKey:@"queryCellHeight"];
    }
    
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
    
    id<AYCommand> cmd = [header.commands objectForKey:@"changeHeaderTitle:"];
    NSString* str = nil;
    if (previewDic.count == 0) {
        str = @"热门标签";
    } else {
        str = @"搜索结果";
    }
    
    [cmd performWithResult:&str];
    
    UITableViewHeaderFooterView* v = (UITableViewHeaderFooterView*)header;
    v.backgroundView = [[UIImageView alloc] initWithImage:[Tools imageWithColor:[UIColor whiteColor] size:v.bounds.size]];
    return (UIView*)header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (previewDic == nil || previewDic.count == 0) {
        
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
    querydata = (NSArray*)[((NSDictionary*)obj) objectForKey:@"recommands"];
    return nil;
}

- (id)changePreviewData:(id)obj {
    previewDic = (NSArray*)obj;
    return nil;
}
@end
