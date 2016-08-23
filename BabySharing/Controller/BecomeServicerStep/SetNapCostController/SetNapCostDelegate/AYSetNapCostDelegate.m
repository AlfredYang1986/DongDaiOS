//
//  AYSetNapCostDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 23/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapCostDelegate.h"
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

@interface AYSetNapCostDelegate ()
@property (nonatomic, strong) NSDictionary* querydata;
@end

@implementation AYSetNapCostDelegate {
    NSArray *options;
    
    NSMutableDictionary *user_info;
}

@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    options = @[@"看书",@"做瑜伽",@"做蛋糕",@"玩玩具",@"画画",@"自填"];
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

-(id)changeQueryData:(NSDictionary*)args {
    _querydata = args;
    
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ProfileHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    if (cell == nil) {
        cell = VIEW(@"ProfileHeadCell", @"ProfileHeadCell");
    }
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
