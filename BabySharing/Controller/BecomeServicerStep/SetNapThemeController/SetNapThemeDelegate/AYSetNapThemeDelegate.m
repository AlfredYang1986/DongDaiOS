//
//  AYSetNapCostDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 23/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapThemeDelegate.h"
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

@interface AYSetNapThemeDelegate ()
@property (nonatomic, strong) NSDictionary* querydata;
@end

@implementation AYSetNapThemeDelegate {
    
}

@synthesize querydata = _querydata;

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

-(id)queryData:(NSDictionary*)args {
    _querydata = args;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tmp = [_querydata objectForKey:@"title"];
    return tmp.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapOptionsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    if (cell == nil) {
        cell = VIEW(@"SetNapOptionsCell", @"SetNapOptionsCell");
    }
    cell.controller = _controller;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:[options objectAtIndex:indexPath.row] forKey:@"title"];
    [dic setValue:[_querydata copy] forKey:@"options"];
    [dic setValue:[NSNumber numberWithFloat:indexPath.row] forKey:@"index"];
    
    NSArray *tmp = [_querydata objectForKey:@"title"];
    if (indexPath.row == (tmp.count - 1)) {
        [dic setValue:[NSNumber numberWithBool:YES] forKey:@"isCustom"];
    }
    id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [set_cmd performWithResult:&dic];
    
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(void)becomeServicer{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}
@end
