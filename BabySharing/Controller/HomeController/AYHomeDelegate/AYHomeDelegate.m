//
//  AYHomeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 22/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeDelegate.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"
#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

@implementation AYHomeDelegate{
    NSArray *servicesData;
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
    servicesData = (NSArray*)args;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return servicesData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	cell.controller = self.controller;
	
	id tmp = [servicesData objectAtIndex:indexPath.row];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
    ((UITableViewCell*)cell).clipsToBounds = YES;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return 193;
//        
//    } else if (indexPath.row == 1) {
//        if (collectData.count == 0) {
//            return 0.001;
//        } else
//            return 235;
//        
//    } else {
//        if (collectData.count == 0) {
//            return 0.001;
//        }
//        if (collectData.count == 1 || collectData.count == 2) {
//            return 240;
//        } else
//            return 435;
//    }
	return 325;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *tmp = [servicesData objectAtIndex:indexPath.row];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollOffsetY:"];
//    CGFloat offset = scrollView.contentOffset.y;
//    NSNumber *offset_y = [NSNumber numberWithFloat:offset];
//    [cmd performWithResult:&offset_y];
}

#pragma mark -- actions


@end
