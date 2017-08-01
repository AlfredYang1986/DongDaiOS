//
//  AYSetServiceThemeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceThemeDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

@implementation AYSetServiceThemeDelegate {
    NSArray *titleArr;
	NSString *setedCourseStr;
	NSDictionary *queryData;
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
	queryData = args;
    NSNumber *type = [args objectForKey:kAYServiceArgsCat];
    if (type.intValue == ServiceTypeNursery) {
        titleArr = @[@"日间看顾", @"课后看顾"];
    } else if (type.intValue == ServiceTypeCourse) {
        titleArr = kAY_service_options_title_course;
		
		NSNumber *canCatSep = [queryData objectForKey:kAYServiceArgsCourseCat];
		if (canCatSep) {
			NSArray *courseAllArr = kAY_service_course_title_ofall;
			NSArray *cansArr = [courseAllArr objectAtIndex:canCatSep.integerValue];
			
			NSNumber *cansSep = [queryData objectForKey:kAYServiceArgsCourseSign];
			if (cansSep) {
				setedCourseStr = [cansArr objectAtIndex:cansSep.integerValue];
			}
		}
		
    } else {
        titleArr = @[@"参数设置错误"];
    }
	
	NSNumber *backArgs= [NSNumber numberWithInteger:titleArr.count];
    return backArgs;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = @"AYSetServiceThemeCellView";
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    NSString *title = titleArr[indexPath.row];
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:title forKey:@"title"];
		
	if (((NSNumber*)[queryData objectForKey:kAYServiceArgsCourseCat]).integerValue == indexPath.row) {
		[tmp setValue:setedCourseStr forKey:@"sub_title"];
	}
	
    kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *tmp = [NSNumber numberWithInteger:indexPath.row];
    kAYDelegateSendNotify(self, @"serviceThemeSeted:", &tmp)
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc]init];
    head.backgroundColor = [Tools garyLineColor];
//    UILabel *titleLabel = [Tools creatUILabelWithText:@"您想要发布什么主题" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//    [head addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(head);
//        make.centerY.equalTo(head);
//    }];
	
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.5;
    } else {
        return 0.001;
    }
}

#pragma mark -- notifies set service info


@end
