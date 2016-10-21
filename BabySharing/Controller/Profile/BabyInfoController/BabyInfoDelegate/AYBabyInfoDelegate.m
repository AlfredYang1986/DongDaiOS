//
//  AYBabyInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 12/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBabyInfoDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYSelfSettingCellDefines.h"
#import "SGActionView.h"
#import "AYViewController.h"
#import "AYSelfSettingCellView.h"

@implementation AYBabyInfoDelegate {
    NSMutableArray *querydate;
    UITableView *babyTable;
    
    NSInteger current_selected;
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

#pragma mark -- table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return querydate == nil ? 0 : querydate.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    babyTable = tableView;
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = @"AYBabyInfoCellView";
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    if (cell == nil) {
        cell = VIEW(@"BabyInfoCell", @"BabyInfoCell");
    }
    cell.controller = self.controller;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSDictionary *info_dic = querydate[indexPath.section];
    if (indexPath.row == 0) {
        [dic setValue:@"宝宝出生时间" forKey:@"title"];
        [dic setValue:[info_dic objectForKey:@"brith"] forKey:@"content"];
    }else{
        [dic setValue:@"宝宝性别" forKey:@"title"];
        [dic setValue:[info_dic objectForKey:@"baby_sex"] forKey:@"content"];
    }
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [cmd performWithResult:&dic];
    
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    current_selected = indexPath.section;
    if (indexPath.row == 0) {
        id<AYCommand> cmd = [self.notifies objectForKey:@"showPicker:"];
        NSNumber *index = [NSNumber numberWithInteger:indexPath.section];
        [cmd performWithResult:&index];
    }else{
        id<AYCommand> cmd = [self.notifies objectForKey:@"showPicker2:"];
        NSNumber *index = [NSNumber numberWithInteger:indexPath.section];
        [cmd performWithResult:&index];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section != 0 ? 60 : 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc]init];
    UIButton *delete = [[UIButton alloc]init];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    delete.titleLabel.font = [UIFont systemFontOfSize:14.f];
    delete.tag = section;
    [head addSubview:delete];
    [head bringSubviewToFront:delete];
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(head).offset(-15);
        make.bottom.equalTo(head).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    [delete addTarget:self action:@selector(didDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    return head;
}

-(id)changeQueryData:(NSArray*)args{
    querydate = [args mutableCopy];
    return nil;
}

-(void)didDeleteClick:(UIButton*)btn{
    [querydate removeObjectAtIndex:btn.tag];
    
    id<AYCommand> del = [self.notifies objectForKey:@"sendDelMessage:"];
    NSNumber *index = [NSNumber numberWithInteger:btn.tag];
    [del performWithResult:&index];
    
    [babyTable reloadData];
    NSLog(@"%ld",(long)btn.tag);
}

-(id)queryCurrentSelected:(id)args{
    
    return [NSNumber numberWithInteger:current_selected];
}
@end
