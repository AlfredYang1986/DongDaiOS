//
//  AYSetNapCostDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 23/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceFacilityDelegate.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"


@implementation AYSetServiceFacilityDelegate {
    NSArray *options_title_facilities;
	NSArray* querydata;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
	
	options_title_facilities = @[@{@"友好性设施":@[@"新风系统", @"加湿器", @"鞋套", @"无线wifi", @"无烟", @"纯净水过滤系统", @"安全护栏", @"安全插座", @"安全桌角", @"防摔地板", @"环保玩具"]},
								 @{@"安全性设施":@[@"消防设备", @"安全通道", @"监控设备"]},
								 @{@"应急设施":@[@"急救包"]}];
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

-(id)changeQueryData:(id)args {
    querydata = args;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return options_title_facilities.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapOptionsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = _controller;
	
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[options_title_facilities objectAtIndex:indexPath.row] forKey:@"title"];
    [dic setValue:querydata forKey:@"options"];
    
    id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [set_cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [Tools whiteColor];
    
    UILabel *titleLabel = [Tools creatUILabelWithText:@"场地友好性" andTextColor:[Tools themeColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(20);
        make.centerY.equalTo(headView);
    }];
	[Tools creatCALayerWithFrame:CGRectMake(20, 49.5, SCREEN_WIDTH - 40, 0.5) andColor:[Tools garyLineColor] inSuperView:headView];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}
@end
