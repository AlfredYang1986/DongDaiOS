//
//  AYAssortmentListDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentListDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"

@implementation AYAssortmentListDelegate {
	NSArray *assortmentArr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	assortmentArr = kAY_top_assortment_titles;
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
	
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return assortmentArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"AssortmentListCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	cell.controller = self.controller;
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[assortmentArr objectAtIndex:indexPath.row] forKey:@"title"];
	[tmp setValue:[NSNumber numberWithInteger:100] forKey:@"count_skiped"];
	[tmp setValue:[NSString stringWithFormat:@"topsort_contbg_%ld", indexPath.row] forKey:@"assortment_img"];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 152.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"Assortment");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[assortmentArr objectAtIndex:indexPath.row] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
}

@end
