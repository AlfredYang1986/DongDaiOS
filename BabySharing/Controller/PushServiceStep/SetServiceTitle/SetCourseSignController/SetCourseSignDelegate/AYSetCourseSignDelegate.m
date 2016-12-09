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

@implementation AYSetCourseSignDelegate {
    NSMutableArray *titleArr;
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
    NSNumber *type = (NSNumber*)args;
    
    NSArray *courseAllArr = kAY_service_options_title_courses_ofall;
//    NSMutableArray *tmp = [[NSMutableArray alloc]initWithObjects:@"添加我自己的服务标签", nil];
    
//    [tmp addObjectsFromArray:[courseAllArr objectAtIndex:type.integerValue]];
//    titleArr = [tmp copy];
    
    titleArr = [NSMutableArray array];
    [titleArr addObjectsFromArray:[courseAllArr objectAtIndex:type.integerValue]];
    [titleArr insertObject:@"添加我自己的服务标签" atIndex:0];
    
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = @"AYSetServiceThemeCellView";
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    NSString *title = titleArr[indexPath.row];
    kAYViewSendMessage(cell, @"setCellInfo:", &title)
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        id<AYCommand> dest = DEFAULTCONTROLLER(@"InputCoustom");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        
//        [dic_push setValue:titleAndCourseSignInfo forKey:kAYControllerChangeArgsKey];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
    else if (indexPath.row == 1) {
        
    }
    else {
        
    }
}

#pragma mark -- notifies set service info


@end
