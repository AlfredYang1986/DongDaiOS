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
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

@interface AYProfileDelegate ()
@property (nonatomic, strong) NSDictionary* querydata;
@end

@implementation AYProfileDelegate{
    NSMutableArray *origs;
    NSArray *confirmData;
    
    BOOL isNapModel;
    BOOL is_service_provider;
}

@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
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

- (id)changeModel:(NSNumber*)args {
    
    isNapModel = args.boolValue;
    if (isNapModel) {
        origs = [NSMutableArray arrayWithObjects:@"切换到被服务者", @"我发布的服务", @"设置", nil];
    } else
        origs = [NSMutableArray arrayWithObjects:@"成为服务者", @"我心仪的服务", @"设置", nil];
    return nil;
}

-(id)changeQueryData:(NSDictionary*)args {
    _querydata = args;
    
    NSNumber *model = [_querydata objectForKey:@"is_service_provider"];
    if (model.intValue == 1) {
        is_service_provider = YES;
        if (isNapModel) {
            [origs replaceObjectAtIndex:0 withObject:@"切换到被服务者"];
        } else {
            [origs replaceObjectAtIndex:0 withObject:@"切换到服务者"];
        }
    }
    if (model.intValue == 2) {
        [origs replaceObjectAtIndex:1 withObject:@"切换到看护家庭"];
    }
    
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return origs.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell;
    if (indexPath.row == 0) {
        NSString* class_name = @"AYProfileHeadCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSDictionary *info = [_querydata copy];
        kAYViewSendMessage(cell, @"setCellInfo:", &info)
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
        
    } else {
        
        NSString *class_name = @"AYProfileOrigCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSString *title = origs[indexPath.row - 1];
        kAYViewSendMessage(cell, @"setCellInfo:", &title)
    }
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    } else {
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        [self infoSetting];             // 个人信息设置
//    } else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            // 服务者
//            [self servicerOptions];
//        }else if (indexPath.row == 999){
//            // 看护家庭
//            [self napFamilyOptions];
//        }else if (indexPath.row == 1){  // 心仪的服务
//            [self collectService];
//        }else                           // 系统设置
//            [self setting];
//        
//    } else {                            // 验证
//        if (indexPath.row == 0) {
//            return;
//        }else if (indexPath.row == 1){
//            [self confirmSNS];          // 验证第三方
//        }else if (indexPath.row == 2){
//            [self confirmPhoneNo];      // 验证手机号码
//        }else {
//            [self confirmRealName];     // 验证实名
//        }
//    }
    if (indexPath.row == 0) {
        [self showPersonalInfo];
    } else if(indexPath.row == 1) {
        [self servicerOptions];
    } else if (indexPath.row == 2) {
        [self collectService];
    } else
        [self setting];
    
}

- (void)showPersonalInfo {
    // 个人信息
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalInfo");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[_querydata copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)servicerOptions {
    
//    NSNumber *model = [_querydata objectForKey:@""];
//    NSNumber *model = [NSNumber numberWithInt:1];
    
    if (is_service_provider) {     // //michauxs 临时数据
        id<AYCommand> cmd = [self.notifies objectForKey:@"sendRegMessage:"];
        NSNumber *args = [NSNumber numberWithInt:1];
        [cmd performWithResult:&args];
        
    } else {
        NSNumber *is_has_phone = [_querydata objectForKey:@"has_phone"];
        NSNumber *is_real_name = [_querydata objectForKey:@"is_real_name_cert"];
        id<AYCommand> des;
        
        if (!is_has_phone.boolValue ) {
            des = DEFAULTCONTROLLER(@"ConfirmPhoneNo");
            
        } else if (!is_real_name.boolValue) {
            des = DEFAULTCONTROLLER(@"ConfirmRealName");
//            des = DEFAULTCONTROLLER(@"ConfirmPhoneNo");
        } else {
            des = DEFAULTCONTROLLER(@"NapArea");
//            des = DEFAULTCONTROLLER(@"ConfirmFinish");
        }
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:[NSNumber numberWithInt:1] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

//- (void)napFamilyOptions {
//    NSNumber *model = [_querydata objectForKey:@""];
//    NSNumber *args = [NSNumber numberWithInt:2];
//    if (model.intValue == 1) {
//        id<AYCommand> cmd = [self.notifies objectForKey:@"sendRegMessage:"];
//        [cmd performWithResult:&args];
//    } else {
//        id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
//        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
//        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//        [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
//        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//        [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
//        id<AYCommand> cmd = PUSH;
//        [cmd performWithResult:&dic_push];
//    }
//}

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
    [dic_push setValue:[_querydata copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

-(void)confirmSNS{
    id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmSNS");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}
-(void)confirmPhoneNo{
    id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmPhoneNo");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}
-(void)confirmRealName{
    id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmRealName");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}
@end
