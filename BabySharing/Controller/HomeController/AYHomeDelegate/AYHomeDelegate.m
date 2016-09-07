//
//  AYHomeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 22/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeDelegate.h"
#import "AYNotificationCellDefines.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"

#import "Notifications.h"

#import "AYModelFacade.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height

@interface AYHomeDelegate ()

@end

@implementation AYHomeDelegate{
    NSArray *collectData;
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

- (id)changeQueryData:(id)args {
    collectData = (NSArray*)args;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell;
    if (indexPath.row == 0) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeTipCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name];
        
    } else if (indexPath.row == 1) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[collectData copy] forKey:@"collect_data"];
        [cmd performWithResult:&dic];
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeLikesCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[collectData copy] forKey:@"collect_data"];
        [cmd performWithResult:&dic];
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).clipsToBounds = YES;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return 193;
    } else if (indexPath.row == 1) {
        if (collectData.count == 0) {
            return 0.001;
        } else
            return 235;
    } else {
        if (collectData.count == 0) {
            return 0.001;
        }
        if (collectData.count == 1 || collectData.count == 2) {
            return 240;
        } else
            return 435;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollOffsetY:"];
    CGFloat offset = scrollView.contentOffset.y;
    NSNumber *offset_y = [NSNumber numberWithFloat:offset];
    [cmd performWithResult:&offset_y];
    if (fabs(offset) < 450) {
        
    } else {
//        static CGFloat set = scrollView.contentOffset.y;
//        scrollView.contentOffset = CGPointMake(0, -450);
    }
}

#pragma mark -- actions


@end
