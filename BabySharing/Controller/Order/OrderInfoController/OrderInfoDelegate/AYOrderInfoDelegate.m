//
//  AYOrderInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoDelegate.h"
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

@implementation AYOrderInfoDelegate {
    NSDictionary *querydata;
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

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell;
    
    if (indexPath.section == 0) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
//        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
//        //        [tmp setValue:[[querydata objectForKey:@"images"] objectAtIndex:0] forKey:@"cover"];
//        //        [tmp setValue:[querydata objectForKey:@"title"] forKey:@"title"];
//        [tmp setValue:[querydata objectForKey:@"service"] forKey:@"service"];
//        
//        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
//        [cmd performWithResult:&tmp];
    } else if (indexPath.section == 1) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
//        NSString *tmp = [[querydata objectForKey:@"service"] objectForKey:@"owner_id"];
//        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
//        [cmd performWithResult:&tmp];
        
    } else if (indexPath.section == 2) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
//        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
//        [tmp setValue:[[querydata objectForKey:@"service"] objectForKey:@"price"] forKey:@"price"];
//        [tmp setValue:[querydata objectForKey:@"order_date"] forKey:@"order_date"];
//        [tmp setValue:[querydata objectForKey:@"status"] forKey:@"status"];
//        //二维码
//        
//        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
//        [cmd performWithResult:&tmp];
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderInfoPayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        //        id tmp = [querydata objectAtIndex:indexPath.row];
        //        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        //        [cmd performWithResult:&tmp];
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 280;
    } else if (indexPath.section == 1) {
        return 150;
    } else if (indexPath.section == 2) {
        return 150;
    } else if(indexPath.section == 3) {
        return 100;
    }else
        return 270;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end
