//
//  AYSetCourseSignDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetCourseSignDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYServiceArgsDefines.h"

@implementation AYSetCourseSignDelegate {
    NSMutableArray *titleArr;
    NSString *coustomStr;
	
	NSString *thridlyCatStr;
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

#pragma marlk -- commands
- (id)changeQueryData:(id)args {
    
    NSDictionary *info_categ = (NSDictionary*)args;
    NSString *cat_secondary = [info_categ objectForKey:kAYServiceArgsCatSecondary];
    
    thridlyCatStr = [info_categ objectForKey:kAYServiceArgsCatThirdly];		//be or not
    
    NSDictionary *thridlyData = kAY_service_course_title_ofall;
    titleArr = [NSMutableArray array];
    [titleArr addObjectsFromArray:[thridlyData objectForKey:cat_secondary]];
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = @"AYSetCourseSignCellView";
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[NSNumber numberWithBool:NO] forKey:@"is_set"];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	if (thridlyCatStr && [titleArr indexOfObject:thridlyCatStr] == indexPath.row) {
		[tmp setValue:[NSNumber numberWithBool:YES] forKey:@"is_set"];
	}
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
    cell.controller = self.controller;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *tmp = [titleArr objectAtIndex:indexPath.row];
	kAYDelegateSendNotify(self, @"courseCansSeted:", &tmp)
	
}

#pragma mark -- notifies set service info



@end
