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
//@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYMainInfoDelegate {
    NSMutableArray *querydata;
    
    UITableView *infoTableView;
    
    UIImage *napPhoto;
    NSString *napTitle;
    NSString *napDesc;
    NSString *napAges;
    NSDictionary *dic_cost;
    NSString *napCost;
    NSString *napAdress;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
//    origs = @[@"切换为看护妈妈",@"我心仪的服务",@"设置"];
//    servs = @[@"身份验证",@"社交账号",@"手机号码",@"实名认证"];
    querydata = [NSMutableArray array];
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
-(id)changeQueryData:(id)args{
    NSDictionary *dic = (NSDictionary*)args;
    
    NSString *key = [dic objectForKey:@"key"];
    
    if ([key isEqualToString:@"nap_cover"]) {
        napPhoto = [dic objectForKey:@"content"];
    } else if([key isEqualToString:@"nap_title"]){
        napTitle = [dic objectForKey:@"content"];
    } else if([key isEqualToString:@"nap_desc"]){
        napDesc = [dic objectForKey:@"content"];
    } else if([key isEqualToString:@"nap_ages"]){
        napAges = [dic objectForKey:@"content"];
    } else if([key isEqualToString:@"nap_cost"]){
        dic_cost = [dic objectForKey:@"content"];
        napCost = [dic_cost objectForKey:@"cost"];
    } else if([key isEqualToString:@"nap_adress"]){
        napAdress = [dic objectForKey:@"content"];
    } else if([key isEqualToString:@"nap_device"]){
//        napAges = [dic objectForKey:@"content"];
    }
    
    [infoTableView reloadData];
    return nil;
}

#pragma mark -- table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    infoTableView = tableView;
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
            if (napPhoto) {
                id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
                UIImage *info = napPhoto;
                [set_cmd performWithResult:&info];
            }
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        } else if (indexPath.row == 1) {
            NSString* class_name = @"AYNapTitleCellView";
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"NapTitleCell", @"NapTitleCell");
            }
            cell.controller = self.controller;
            if (napTitle) {
                id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
                NSString *info = napTitle;
                [set_cmd performWithResult:&info];
            }
            
            ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
            return (UITableViewCell*)cell;
        } else {
            NSString* class_name = @"AYNapDescCellView";
            id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            if (cell == nil) {
                cell = VIEW(@"NapDescCell", @"NapDescCell");
            }
            cell.controller = self.controller;
            if (napDesc) {
                id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
                NSString *info = napDesc;
                [set_cmd performWithResult:&info];
            }
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
        if (napAges) {
            id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
            NSString *info = napAges;
            [set_cmd performWithResult:&info];
        }
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
        
    } else if(indexPath.section == 2){
        NSString* class_name = @"AYNapCostCellView";
        id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"NapCostCell", @"NapCostCell");
        }
        cell.controller = self.controller;
        if (napCost) {
            id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
            NSString *info = napCost;
            [set_cmd performWithResult:&info];
        }
        
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    } else if (indexPath.section == 1) {
        [self setNapBabyAges];
    } else if (indexPath.section == 2) {                            //验证
        [self setNapCost];
    }else {
        if (indexPath.row == 0) {
            
        }else {
            
        }
    }
}

-(void)infoSetting {
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

-(void)setNapBabyAges {
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapBabyAges"];
    [cmd performWithResult:nil];
}

-(void)setNapCost{
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapCost:"];
    NSDictionary *dic = [dic_cost mutableCopy];
    [cmd performWithResult:&dic];
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
