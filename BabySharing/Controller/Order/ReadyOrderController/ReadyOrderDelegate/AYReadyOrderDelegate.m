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

- (id)changeQueryData:(id)array{
    querydata = (NSArray*)array;
    return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
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
        
//        id tmp = [querydata objectAtIndex:indexPath.row];
//        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
//        [cmd performWithResult:&tmp];
        
        return (UITableViewCell*)cell;
    } else if (indexPath.section == 1) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"OrderContactCell", @"OrderContactCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        id tmp = [querydata objectAtIndex:indexPath.row];
        //        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        //        [cmd performWithResult:&tmp];
        
        return (UITableViewCell*)cell;
    } else if (indexPath.section == 2) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderStateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"OrderStateCell", @"OrderStateCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        id tmp = [querydata objectAtIndex:indexPath.row];
        //        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        //        [cmd performWithResult:&tmp];
        
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
        
        //        id tmp = [querydata objectAtIndex:indexPath.row];
        //        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        //        [cmd performWithResult:&tmp];
        
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
    
//    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//    
////    NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
////    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd_show_module = PUSH;
//    [cmd_show_module performWithResult:&dic];
}

@end
