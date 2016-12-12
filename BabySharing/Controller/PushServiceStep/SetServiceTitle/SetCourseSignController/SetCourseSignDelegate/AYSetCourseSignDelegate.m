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
    NSNumber *courseSign;
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
    
    NSDictionary *args_info = (NSDictionary*)args;
    NSNumber *type = [args_info objectForKey:kAYServiceArgsTheme];
    long sepNumb = log2(type.longValue);
    
//    long testArgs = pow(2, 2) * pow(2, 8) + pow(2, 3);
//    long f_sep = log2(testArgs/pow(2, 8));
//    long s_sep = log2(testArgs - pow(2, f_sep) * pow(2, 8));
    
    NSArray *courseAllArr = kAY_service_options_title_courses_ofall;
    
    courseSign = [args_info objectForKey:kAYServiceArgsCourseSign];
    
    titleArr = [NSMutableArray array];
    [titleArr addObjectsFromArray:[courseAllArr objectAtIndex:(NSUInteger)sepNumb]];
    [titleArr insertObject:@"添加我自己的服务标签" atIndex:0];
    
    coustomStr = [args_info objectForKey:kAYServiceArgsCourseCoustom];
    if (coustomStr) {
        [titleArr insertObject:coustomStr atIndex:1];
    }
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name;
    id<AYViewBase> cell;
    if (indexPath.row == 0) {
        class_name = @"AYSetServiceThemeCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        NSString *title = titleArr[indexPath.row];
        kAYViewSendMessage(cell, @"setCellInfo:", &title)
    } else {
        
        class_name = @"AYSetCourseSignCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:[NSNumber numberWithBool:NO] forKey:@"is_set"];
        [tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
        
        if (indexPath.row == 1 && coustomStr) {
            [tmp setValue:[NSNumber numberWithBool:YES] forKey:@"is_set"];
        }
        else if (courseSign && indexPath.row-(coustomStr ? 2 : 1) == courseSign.integerValue ) {
            [tmp setValue:[NSNumber numberWithBool:YES] forKey:@"is_set"];
        }
        
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    else if (indexPath.row == 1 && coustomStr) {
        
        return;
    }
    else {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
        [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        
        NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
        [dic_info setValue:[NSNumber numberWithInteger:indexPath.row - (coustomStr ? 2 : 1)] forKey:kAYServiceArgsCourseSign];
        [dic_info setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"signStr"];
        [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
    }
}

#pragma mark -- notifies set service info



@end
