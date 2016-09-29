//
//  AYOneProfileDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 11/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOneProfileDelegate.h"
#import "AYNotificationCellDefines.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"

#import "Notifications.h"

#import "AYModelFacade.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

@interface AYOneProfileDelegate ()
@property (nonatomic, strong) NSDictionary* querydata;
@end

@implementation AYOneProfileDelegate{
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
    origs = @[@"切换为看护妈妈",@"我心仪的服务",@"设置"];
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

-(id)changeQueryData:(NSDictionary*)args {
    _querydata = args;
    
    user_info = [[NSMutableDictionary alloc]init];
    [user_info setValue:[_querydata objectForKey:@"user_id"] forKey:@"user_id"];
    [user_info setValue:[_querydata objectForKey:@"screen_photo"] forKey:@"screen_photo"];
    [user_info setValue:[_querydata objectForKey:@"screen_name"] forKey:@"screen_name"];
    [user_info setValue:[_querydata objectForKey:@"role_tag"] forKey:@"role_tag"];
    [user_info setValue:[_querydata objectForKey:@"kids"] forKey:@"kids"];
    
    return nil;
}

#pragma mark -- table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else{
        return 6;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ProfileHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
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
        
    } else {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3) {
            NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OneProfileAboutCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"OneProfileAboutCell", @"OneProfileAboutCell");
            }
            cell.controller = self.controller;
            
            id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
            NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
            if (indexPath.row == 0) {
                [info setValue:@"关于妈妈" forKey:@"title"];
                [info setValue:@"dfhdhhgk啊风格的设计开发" forKey:@"sub_title"];
            } else if (indexPath.row == 1){
                [info setValue:@"回复率" forKey:@"title"];
                [info setValue:@"100%" forKey:@"sub_title"];
            } else{
                [info setValue:@"已验证的身份" forKey:@"title"];
                [info setValue:@"single" forKey:@"validate"];
            }
            [set_cmd performWithResult:&info];
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
            
        } else if (indexPath.row == 2){
            NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OneProfileContentCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"OneProfileContentCell", @"OneProfileContentCell");
            }
            cell.controller = self.controller;
            id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
            NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
            
            [set_cmd performWithResult:&info];
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
            
        } else {
            AYProfileServCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"AYProfileOrigCellView"];
            if (cell == nil) {
                cell = [[AYProfileServCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYProfileOrigCellView"];
            }
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:servs[indexPath.row -4] forKey:@"title"];
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"isFirst"];
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"isLast"];
            if(indexPath.row == 5) {
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"isLast"];
            }
            cell.dic_info = dic;
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        }
    }
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
    } else {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3) {
            return 90;
        }else if (indexPath.row == 2){
            return 220;
        }else {
            return 40;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    } else {
        if (indexPath.row == 4) {
//            return;
        }else if (indexPath.row == 5){
//            [self confirmSNS];
        }else {
            return;
        }
        
    }
}

-(void)infoSetting{
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[user_info copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

-(void)collectService{
    AYViewController* des = DEFAULTCONTROLLER(@"CollectServ");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithInt:0] forKey:kAYControllerChangeArgsKey]; //0收藏的服务 /1自己发布的服务
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)pushNewService {
    
    
}

-(void)setting{
    NSLog(@"setting view controller");
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
-(void)becomeServicer{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}
@end
