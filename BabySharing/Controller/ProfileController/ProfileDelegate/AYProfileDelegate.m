//
//  AYProfileDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 6/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYProfileDelegate.h"
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

@interface AYProfileDelegate ()
@property (nonatomic, strong) NSDictionary* querydata;
@end

@implementation AYProfileDelegate{
    NSMutableArray *origs;
    NSArray *confirmData;
    
    NSMutableDictionary *user_info;
}

@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    origs = [NSMutableArray arrayWithObjects:@"成为服务者", @"我心仪的服务", @"设置", nil];
    confirmData = @[@"身份验证",@"社交账号",@"手机号码",@"实名认证"];
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
    
    user_info = [[NSMutableDictionary alloc]init];
    [user_info setValue:[_querydata objectForKey:@"user_id"] forKey:@"user_id"];
    [user_info setValue:[_querydata objectForKey:@"screen_photo"] forKey:@"screen_photo"];
    [user_info setValue:[_querydata objectForKey:@"screen_name"] forKey:@"screen_name"];
    [user_info setValue:[_querydata objectForKey:@"address"] forKey:@"address"];
    [user_info setValue:[_querydata objectForKey:@"kids"] forKey:@"kids"];
    
    NSNumber *model = [_querydata objectForKey:@""];
    if (model.intValue == 1) {
        [origs replaceObjectAtIndex:0 withObject:@"切换到服务者"];
    }
    if (model.intValue == 2) {
        [origs replaceObjectAtIndex:1 withObject:@"切换到看护家庭"];
    }
    
    return nil;
}

#pragma mark -- table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return origs.count;
    } else {
        return confirmData.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* class_name = @"AYProfileHeadCellView";
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"ProfileHeadCell", @"ProfileHeadCell");
        }
        cell.controller = self.controller;
        id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
        NSDictionary *info = user_info;
        [set_cmd performWithResult:&info];
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
        
    } else if(indexPath.section == 1){
        AYProfileOrigCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"AYProfileOrigCellView"];
        if (cell == nil) {
            cell = [[AYProfileOrigCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYProfileOrigCellView"];
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:origs[indexPath.row] forKey:@"title"];
        [dic setValue:[NSNumber numberWithBool:NO] forKey:@"isLast"];
        if(indexPath.row == origs.count - 1) {
            [dic setValue:[NSNumber numberWithBool:YES] forKey:@"isLast"];
        }
        cell.dic_info = dic;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
    }
    else {
        AYProfileServCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"AYProfileOrigCellView"];
        if (cell == nil) {
            cell = [[AYProfileServCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYProfileOrigCellView"];
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:confirmData[indexPath.row] forKey:@"title"];
        [dic setValue:[NSNumber numberWithBool:NO] forKey:@"isFirst"];
        [dic setValue:[NSNumber numberWithBool:NO] forKey:@"isLast"];
        if (indexPath.row == 0) {
            [dic setValue:[NSNumber numberWithBool:YES] forKey:@"isFirst"];
        } else if(indexPath.row == 3) {
            [dic setValue:[NSNumber numberWithBool:YES] forKey:@"isLast"];
        }
        cell.dic_info = dic;
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
    };
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
            // 服务者
            [self servicerOptions];
        }else if (indexPath.row == 999){
            // 看护家庭
            [self napFamilyOptions];
        }else if (indexPath.row == 1){  // 心仪的服务
            [self collectService];
        }else                           // 系统设置
            [self setting];
        
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

- (void)infoSetting {
    // 个人设置
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[user_info copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)servicerOptions {
    NSNumber *args = [NSNumber numberWithInt:1];
    NSNumber *model = [_querydata objectForKey:@""];
    if (model.intValue == 1) {
        id<AYCommand> cmd = [self.notifies objectForKey:@"sendRegMessage:"];
        [cmd performWithResult:&args];
    }else {
        id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

- (void)napFamilyOptions {
    NSNumber *model = [_querydata objectForKey:@""];
    NSNumber *args = [NSNumber numberWithInt:2];
    if (model.intValue == 1) {
        id<AYCommand> cmd = [self.notifies objectForKey:@"sendRegMessage:"];
        [cmd performWithResult:&args];
    }else {
        id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

- (void)collectService {
    AYViewController* des = DEFAULTCONTROLLER(@"CollectServ");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithInt:0] forKey:kAYControllerChangeArgsKey]; //0收藏的服务 /1自己发布的服务
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}
- (void)setting {
    // NSLog(@"setting view controller");
    id<AYCommand> setting = DEFAULTCONTROLLER(@"Setting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[user_info copy] forKey:kAYControllerChangeArgsKey];
    
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
