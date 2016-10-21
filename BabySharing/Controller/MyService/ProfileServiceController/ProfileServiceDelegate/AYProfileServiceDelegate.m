//
//  AYProfileDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 6/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYProfileServiceDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

@interface AYProfileServiceDelegate ()
@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYProfileServiceDelegate{
    NSArray *origs;
    NSArray *servs;
    NSMutableDictionary *user_info;
}

@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    origs = @[@"切换为发单妈妈",@"我发布的服务",@"设置"];
    servs = @[@"身份验证",@"社交账号",@"手机号码",@"实名认证"];
    
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 3;
    } else {
        return 4;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell;
    if (indexPath.row == 0) {
        NSString* class_name = @"AYProfileHeadCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSDictionary *info = [user_info copy];
        kAYViewSendMessage(cell, @"setCellInfo:", &info)
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
        
    } else {
        
        NSString *class_name = @"AYProfileOrigCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSString *title = origs[indexPath.row + 1];
        kAYViewSendMessage(cell, @"setCellInfo:", &title)
    }
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    return line;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 115;
    } else if (indexPath.section == 1){
        return 70;
    } else {
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self infoSetting];             // 个人信息设置
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self regServiceObj];       // 切换服务对象
        }else if (indexPath.row == 1){  // 心仪的服务
            [self collectService];
        }else {                         // 系统设置
            [self setting];
        }
    } else {                            //验证
        if (indexPath.row == 0) {
            return;
        }else if (indexPath.row == 1){
            [self confirmSNS];          //验证第三方
        }else if (indexPath.row == 2){
            [self confirmPhoneNo];      //验证手机号码
        }else {
            [self confirmRealName];     //验证实名
        }
    }
}

-(void)infoSetting{
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:cur forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

-(void)regServiceObj{
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendRegMessage"];
    [cmd performWithResult:nil];
}

-(void)collectService{
    AYViewController* des = DEFAULTCONTROLLER(@"CollectServ");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithInt:1] forKey:kAYControllerChangeArgsKey]; //0收藏的服务 /1自己发布的服务
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}
-(void)setting{
    NSLog(@"setting view controller");
    id<AYCommand> setting = DEFAULTCONTROLLER(@"Setting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

-(void)confirmSNS{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"ConfirmSNS");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}
-(void)confirmPhoneNo{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"ConfirmPhoneNo");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}
-(void)confirmRealName{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"ConfirmRealName");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

@end