//
//  AYOrderInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoDelegate.h"
#import "Notifications.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@implementation AYOrderInfoDelegate {
    NSDictionary *querydata;
    
    BOOL isSetedDate;
    BOOL isExpend;
    
    NSNumber *setedDate;
    NSDictionary *setedTimes;
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

- (id)changeQueryData:(NSDictionary*)info {
    querydata = info;
    
    return nil;
}

- (id)setOrderDate:(id)args {
    setedDate = (NSNumber*)args;
    if (!setedTimes) {
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:@"10:00" forKey:@"start"];
        [tmp setValue:@"12:00" forKey:@"end"];
        setedTimes = [tmp copy];
    }
    return nil;
}

- (id)setOrderTimes:(NSDictionary*)args {
    setedTimes = args;
    return nil;
}

- (id)TransfromExpend {
    isExpend = !isExpend;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell;
    
    if (indexPath.row == 0) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        NSDictionary *tmp = [querydata copy];
        [cmd performWithResult:&tmp];
        
    } else if (indexPath.row == 1) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        if (setedDate) {
            [tmp setValue:setedDate forKey:@"order_date"];
        }
        if (setedTimes) {
            [tmp setValue:setedTimes forKey:@"order_times"];
        }
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
        
    } else if (indexPath.row == 2) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:[querydata copy] forKey:@"service_info"];
        if (setedTimes) {
            [tmp setValue:setedTimes forKey:@"order_times"];
        }
        [cmd performWithResult:&tmp];
        
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoPayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    ((UITableViewCell*)cell).clipsToBounds = YES;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110.f;
    } else if (indexPath.row == 1) {
        
        return setedDate?95.f:85.f;
        
    } else if (indexPath.row == 2) {
        
        return isExpend?150.f:90.f;
        
    } else {
        return 100.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end
