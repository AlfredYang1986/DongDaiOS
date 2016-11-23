//
//  AYServiceTimesShowDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceTimesShowDelegate.h"

@implementation AYServiceTimesShowDelegate {
    NSArray *timesArr;
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
    timesArr = (NSArray*)args;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return timesArr.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name;
    id<AYViewBase> cell;
    
    if (indexPath.row == timesArr.count) {
        class_name = @"AYServiceAddTimesCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
    } else {
        class_name = @"AYServiceTimesCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = [timesArr objectAtIndex:indexPath.row];
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    kAYDelegateSendNotify(self, @"cellShowPickerView:", &row)
    
}

//左划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == timesArr.count) {
        return NO;
    } else
        return YES;
}
- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    kAYDelegateSendNotify(self, @"cellDeleteFromTable:", &row)
}

@end
