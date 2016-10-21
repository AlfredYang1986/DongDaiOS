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
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

@interface AYSetNapThemeDelegate ()
@property (nonatomic, strong) NSDictionary* querydata;
@end

@implementation AYSetNapThemeDelegate {
    NSArray *options_title_cats;
}

@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    options_title_cats = kAY_service_options_title_cans;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return options_title_cats.count;
    } else
        return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    cell.controller = _controller;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[_querydata objectForKey:@"isShow"] forKey:@"isShow"];
    if (indexPath.section == 0) {
        [dic setValue:[options_title_cats objectAtIndex:indexPath.row] forKey:@"title"];
        [dic setValue:[_querydata objectForKey:@"nap_theme"] forKey:@"nap_theme"];
        [dic setValue:[NSNumber numberWithFloat:indexPath.row] forKey:@"index"];
    } else {
        NSString *allowLeaveStr = @"可以提供看护";
        [dic setValue:allowLeaveStr forKey:@"title"];
        [dic setValue:[_querydata objectForKey:@"allow_leave"] forKey:@"isAllowLeaveOption"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20.f;
    } else
        return 0.001f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *marginView = [[UIView alloc]init];
    marginView.backgroundColor = [Tools garyBackgroundColor];
    return marginView;
}

@end
