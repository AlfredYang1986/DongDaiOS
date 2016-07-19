//
//  AYMainInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMainInfoDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYSelfSettingCellDefines.h"

@interface AYMainInfoDelegate ()
@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYMainInfoDelegate {
    
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
//    origs = @[@"切换为看护妈妈",@"我心仪的服务",@"设置"];
//    servs = @[@"身份验证",@"社交账号",@"手机号码",@"实名认证"];
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1){
        return 1;
    } else if (section == 2){
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            NSString* class_name = @"AYNapPhotosCellView";
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"NapPhotosCell", @"NapPhotosCell");
            }
            cell.controller = self.controller;
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        } else if (indexPath.row == 1) {
            NSString* class_name = @"AYNapTitleCellView";
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"NapTitleCell", @"NapTitleCell");
            }
            cell.controller = self.controller;
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        } else {
            NSString* class_name = @"AYNapDescCellView";
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"NapDescCell", @"NapDescCell");
            }
            cell.controller = self.controller;
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        }
        
    } else if(indexPath.section == 1){
        NSString* class_name = @"AYNapBabyAgeCellView";
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"NapBabyAgeCell", @"NapBabyAgeCell");
        }
        cell.controller = self.controller;
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
        
    } else if(indexPath.section == 2){
        NSString* class_name = @"AYNapCostCellView";
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"NapCostCell", @"NapCostCell");
        }
        cell.controller = self.controller;
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
    } else {
        if (indexPath.row == 0) {
            NSString* class_name = @"AYNapLocationCellView";
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"NapLocationCell", @"NapLocationCell");
            }
            cell.controller = self.controller;
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        } else {
            NSString* class_name = @"AYNapDeviceCellView";
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"NapDeviceCell", @"NapDeviceCell");
            }
            cell.controller = self.controller;
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else return 10;
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
        if (indexPath.row == 0) {
            return 225;
        } else {
            return 120;
        }
    } else if (indexPath.section == 1 || indexPath.section == 2){
        return 82;
    } else {
        return 82;
    }
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        [self infoSetting];             // 个人信息设置
//    } else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            //            [self regServiceObj];       // 切换服务对象
//            [self becomeServicer];
//        }else if (indexPath.row == 1){  // 心仪的服务
//            [self collectService];
//        }else {                         // 系统设置
//            [self setting];
//        }
//    } else {                            //验证
//        if (indexPath.row == 0) {
//            return;
//        }else if (indexPath.row == 1){
//            [self confirmSNS];          //验证第三方
//        }else if (indexPath.row == 2){
//            [self confirmPhoneNo];      //验证手机号码
//        }else {
//            [self confirmRealName];     //验证实名
//        }
//    }
//}

-(void)infoSetting{
//    AYModelFacade* f = LOGINMODEL;
//    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
//    
//    NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [cur setValue:tmp.who.user_id forKey:@"user_id"];
//    [cur setValue:tmp.who.auth_token forKey:@"auth_token"];
//    [cur setValue:tmp.who.screen_image forKey:@"screen_photo"];
//    [cur setValue:tmp.who.screen_name forKey:@"screen_name"];
//    [cur setValue:tmp.who.role_tag forKey:@"role_tag"];
    
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
    
}
-(void)setting{
    
}
-(void)confirmSNS{
    
}
-(void)confirmPhoneNo{
    
}
-(void)confirmRealName{
    
}
-(void)becomeServicer{
    
}
@end
