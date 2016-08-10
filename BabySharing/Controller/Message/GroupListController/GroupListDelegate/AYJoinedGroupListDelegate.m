//
//  AYJoinedGroupListDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYJoinedGroupListDelegate.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYGroupListCellDefines.h"
#import "AYNotifyDefines.h"

#import "Targets.h"
#import "EMConversation.h"
#import "EMMessage.h"

@implementation AYJoinedGroupListDelegate {
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
    return querydata.count == 0 ? 0 : querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYGroupListCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(kAYGroupListCellName, kAYGroupListCellName);
    }
    
//    Targets* tmp = [querydata objectAtIndex:indexPath.row];
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:tmp forKey:kAYGroupListCellContentKey];
//    [dic setValue:cell forKey:kAYGroupListCellCellKey];
//    id<AYCommand> cmd = [cell.commands objectForKey:@"resetContent:"];
//    [cmd performWithResult:&dic];
    
    EMConversation *tmp = [querydata objectAtIndex:indexPath.row];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:tmp forKey:kAYGroupListCellContentKey];
    [dic setValue:cell forKey:kAYGroupListCellCellKey];
    id<AYCommand> cmd = [cell.commands objectForKey:@"resetContent:"];
    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* reVal = [[UIView alloc]init];
    reVal.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (section == 0) {
        if ([tableView numberOfRowsInSection:section] == 0) {
            label.text = @"暂无消息:)";
        } else {
            label.text = @"最近关注的:";
        }
    } else {
        label.text = @"猜你喜欢";
    }
    
    label.textColor = [UIColor colorWithWhite:0.3509 alpha:1.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:12.f];
    [label sizeToFit];
    [reVal addSubview:label];
    
    label.center = CGPointMake(10.5f + label.frame.size.width / 2, 46 / 2);
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5, 46 - 1, [UIScreen mainScreen].bounds.size.width - 10.5 * 2, 1);
    [reVal.layer addSublayer:line];
    
    return reVal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return querydata.count == 0 ? 46 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell = VIEW(kAYGroupListCellName, kAYGroupListCellName);
    id<AYCommand> cmd = [cell.commands objectForKey:@"queryContentCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation* tmp = [querydata objectAtIndex:indexPath.row];
    NSLog(@"michauxs--%@",tmp);
    
    EMMessage *last_message = tmp.latestMessage;
    
    NSString *owner_id = nil;
    if (last_message.direction == 0) {
        owner_id = last_message.to;
    } else {
        owner_id = last_message.from;
    }
    
    AYViewController* des = DEFAULTCONTROLLER(@"GroupChat");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:owner_id forKey:@"owner_id"];
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"status"];
    
//    [dic setValue:tmp.post_id forKey:@"post_id"];
//    [dic setValue:tmp.group_id forKey:@"group_id"];
    
    [dic_push setValue:[dic copy] forKey:kAYControllerChangeArgsKey];
    [_controller performWithResult:&dic_push];
}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    querydata = (NSArray*)args;
    return nil;
}
@end
