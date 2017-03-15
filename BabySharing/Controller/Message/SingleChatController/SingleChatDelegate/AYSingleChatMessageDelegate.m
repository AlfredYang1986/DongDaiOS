//
//  AYGroupChatMessagesDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSingleChatMessageDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYChatMessageCellDefines.h"

@implementation AYSingleChatMessageDelegate {
    NSArray* querydata;
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
    return querydata.count== 0 ? 0 : querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYChatMessageCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(kAYChatMessageCellName, kAYChatMessageCellName);
    }
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    
    id tmp = [querydata objectAtIndex:indexPath.row];
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:tmp forKey:kAYChatMessageCellContentKey];
    [dic setValue:cell forKey:kAYChatMessageCellCellKey];
    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    querydata = (NSArray*)args;
    return nil;
}
@end
