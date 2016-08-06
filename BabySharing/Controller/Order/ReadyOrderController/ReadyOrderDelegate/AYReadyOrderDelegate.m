//
//  AYReadyOrderDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYReadyOrderDelegate.h"
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

@implementation AYReadyOrderDelegate {
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

- (id)changeQueryData:(NSDictionary*)info{
    querydata = info;
    
    return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSNumber *status = [querydata objectForKey:@"status"];
    if (status.intValue == 0) {
        return 4;
    }else return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"OrderHeadCell", @"OrderHeadCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
//        [tmp setValue:[[querydata objectForKey:@"images"] objectAtIndex:0] forKey:@"cover"];
//        [tmp setValue:[querydata objectForKey:@"title"] forKey:@"title"];
        [tmp setValue:[querydata objectForKey:@"service"] forKey:@"service"];
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
        
        return (UITableViewCell*)cell;
    } else if (indexPath.section == 1) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"OrderContactCell", @"OrderContactCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *tmp = [[querydata objectForKey:@"service"] objectForKey:@"owner_id"];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
        
        return (UITableViewCell*)cell;
    } else if (indexPath.section == 2) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderStateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"OrderStateCell", @"OrderStateCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:[[querydata objectForKey:@"service"] objectForKey:@"price"] forKey:@"price"];
        [tmp setValue:[querydata objectForKey:@"order_date"] forKey:@"order_date"];
        [tmp setValue:[querydata objectForKey:@"status"] forKey:@"status"];
        //二维码
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
        
        return (UITableViewCell*)cell;
    } else if (indexPath.section == 3) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"OrderPayCell", @"OrderPayCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        id tmp = [querydata objectAtIndex:indexPath.row];
        //        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        //        [cmd performWithResult:&tmp];
        
        return (UITableViewCell*)cell;
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"OrderMapCell", @"OrderMapCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        id tmp = [[querydata objectForKey:@"service"] objectForKey:@"location"];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
        
        return (UITableViewCell*)cell;
    }
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
