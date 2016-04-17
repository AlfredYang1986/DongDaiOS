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
#define PHOTO_PER_LINE      3
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (previewDic.count == 0) {
        return 1;
    } else {
        return previewDic.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = @"alfred test";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
    
//    if ([tableView numberOfRowsInSection:section] > 1) {
//        header.line.hidden = NO;
//    } else {
//        header.line.hidden = YES;
//    }
    
    id<AYCommand> cmd = [header.commands objectForKey:@"changeHeaderTitle:"];
    NSString* str = nil;
    if (previewDic.count == 0) {
        str = @"热门标签";
//        header.headLabell.text = @"热门标签";
//        header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
//        header.headLabell.font = [UIFont systemFontOfSize:14.f];
    } else {
        str = @"搜索结果";
//        header.headLabell.text = @"搜索结果";
//        header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
//        header.headLabell.font = [UIFont systemFontOfSize:14.f];
    }
    
    [cmd performWithResult:&str];
    
    UITableViewHeaderFooterView* v = (UITableViewHeaderFooterView*)header;
    v.backgroundView = [[UIImageView alloc] initWithImage:[Tools imageWithColor:[UIColor whiteColor] size:v.bounds.size]];
    return (UIView*)header;
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
