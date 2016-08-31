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
    NSMutableArray *titles;
    NSMutableArray *sub_titles;
    
    UITableView *infoTableView;
    
    UIImage *napPhoto;
    NSString *napPhotoName;
    NSString *napTitle;
    NSString *napDesc;
    NSDictionary *napAges;
    NSDictionary *dic_cost;
    NSString *napCost;
    NSDictionary *dic_adress;
    NSString *napAdress;
    NSDictionary *dic_device;
    NSString *napDevice;
    
    NSMutableDictionary *push_info_dic;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
//    origs = @[@"切换为看护妈妈",@"我心仪的服务",@"设置"];
//    servs = @[@"身份验证",@"社交账号",@"手机号码",@"实名认证"];
    
    titles = [NSMutableArray arrayWithObjects:@"添加图片", @"标题", @"服务孩子年龄", @"服务主题", @"主题服务价格", @"位置", @"场地友好设施", nil];
    sub_titles = [NSMutableArray arrayWithObjects:
                  @"添加图片",
                  @"为您的服务添加一个有趣的标题",
                  @"您接收孩子服务年龄阶段",
                  @"添加一个具体的服务类型",
                  @"添加一个您值得的价格",
                  @"更准确的访问到您的位置",
                  @"为孩子提供更友好的场地",  nil];
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
        napPhoto = [[dic objectForKey:@"content"] objectAtIndex:0];
        
        
    } else if([key isEqualToString:@"nap_title"]){
        napTitle = [dic objectForKey:@"content"];
        
    } else if([key isEqualToString:@"nap_desc"]){
        napDesc = [dic objectForKey:@"content"];
        
    } else if([key isEqualToString:@"nap_ages"]){
        napAges = [dic objectForKey:@"age_boundary"];
        
    } else if([key isEqualToString:@"nap_cost"]){
        dic_cost = [dic objectForKey:@"content"];
        napCost = [dic_cost objectForKey:@"cost"];
        
    } else if([key isEqualToString:@"nap_adress"]){
        dic_adress = [dic objectForKey:@"content"];
        napAdress = [NSString stringWithFormat:@"%@%@",[dic_adress objectForKey:@"head"], [dic_adress objectForKey:@"detail"]];
        
    } else if([key isEqualToString:@"nap_device"]){
        dic_device = [dic objectForKey:@"content"];
        napDevice = [dic_device objectForKey:@"option_custom"];
        
    }
    [infoTableView reloadData];
    return nil;
}

-(id)changeQueryInfo:(NSDictionary*)info {
    
    napPhotoName = [[info objectForKey:@"images"] objectAtIndex:0];
    napTitle = [info objectForKey:@"title"];
    napDesc = [info objectForKey:@"description"];
    napAges = [info objectForKey:@"age_boundary"];
    napCost = [info objectForKey:@"price"];
    napAdress = @"Dongda_Note_NOEDIT";
    
    {
        NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
        [dic_options setValue:[info objectForKey:@"facility"] forKey:@"option_pow"];
        [dic_options setValue:@"自填" forKey:@"option_custom"];
        dic_device = dic_options;
    }
    
    {
        NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
        [dic_options setValue:[info objectForKey:@"cans"] forKey:@"option_pow"];
        [dic_options setValue:@"自填" forKey:@"option_custom"];
        [dic_options setValue:[info objectForKey:@"price"] forKey:@"price"];
        dic_cost = dic_options;
    }
    
    [infoTableView reloadData];
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    infoTableView = tableView;
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell = nil;
    if (indexPath.row == 0) {
        NSString* class_name = @"AYNapPhotosCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"NapPhotosCell", @"NapPhotosCell");
        }
        cell.controller = self.controller;
        if (napPhoto){
            id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
            UIImage *info = napPhoto;
            [set_cmd performWithResult:&info];
        } else if (napPhotoName) {
            id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
            NSString *info = napPhotoName;
            [set_cmd performWithResult:&info];
        }
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
    } else {
        NSString* class_name = @"AYNapBabyAgeCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        if (cell == nil) {
            cell = VIEW(@"NapBabyAgeCell", @"NapBabyAgeCell");
        }
        cell.controller = self.controller;
        
        NSMutableDictionary *cell_info = [[NSMutableDictionary alloc]init];
        [cell_info setValue:[titles objectAtIndex:indexPath.row] forKey:@"title"];
        [cell_info setValue:[sub_titles objectAtIndex:indexPath.row] forKey:@"sub_title"];
        
        if (napTitle && indexPath.row == 1) {
            [cell_info setValue:napTitle forKey:@"args"];
        }
        if (napAges && indexPath.row == 2) {
            NSNumber *usl = ((NSNumber *)[napAges objectForKey:@"usl"]);
            NSNumber *lsl = ((NSNumber *)[napAges objectForKey:@"lsl"]);
            NSString *ages = [NSString stringWithFormat:@"%d ~ %d 岁",lsl.intValue,usl.intValue];
            [cell_info setValue:ages forKey:@"args"];
        }
        if (dic_cost && indexPath.row == 3) {
            [cell_info setValue:dic_cost forKey:@"args"];
        }
        if (dic_cost && indexPath.row == 4) {
            [cell_info setValue:dic_cost forKey:@"args"];
        }
        if (napAdress && indexPath.row == 5) {
            [cell_info setValue:napAdress forKey:@"args"];
        }
        if (dic_device && indexPath.row == 6) {
            [cell_info setValue:dic_device forKey:@"args"];
        }
        
        id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [set_cmd performWithResult:&cell_info];
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
    }
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    } else return 10;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.5;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = [UIColor lightGrayColor];
//    return line;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 225;
    } else {
        return 64;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    } else if (indexPath.row == 1){
        [self setNapTitle];
    } else if (indexPath.row == 2){
        [self setNapBabyAges];
    } else if (indexPath.row == 3){
        [self setNapCost];
    } else if (indexPath.row == 4){
        [self setNapCost];
    } else if (indexPath.row == 5){
        [self setNapAdress];
    } else {
        [self setNapDevice];
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

-(void)setNapTitle {
    id<AYCommand> cmd = [self.notifies objectForKey:@"inputNapTitleAction:"];
    NSString *info = napTitle;
    [cmd performWithResult:&info];
}

-(void)setNapBabyAges {
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapBabyAges:"];
    NSDictionary *info = [napAges mutableCopy];
    [cmd performWithResult:&info];
}

-(void)setNapCost{
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapCost:"];
    NSDictionary *dic = [dic_cost mutableCopy];
    [cmd performWithResult:&dic];
}
-(void)setNapAdress{
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapAdress:"];
    NSDictionary *dic = [dic_adress mutableCopy];
    [cmd performWithResult:&dic];
}
-(void)setNapDevice{
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapDevice:"];
    NSDictionary *dic = [dic_device mutableCopy];
    [cmd performWithResult:&dic];
}

@end
