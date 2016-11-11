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
#import <CoreLocation/CoreLocation.h>

@interface AYMainInfoDelegate ()
//@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYMainInfoDelegate {
    NSMutableArray *titles;
    NSMutableArray *sub_titles;
    
    UIImage *napPhoto;
    NSString *napPhotoName;
    NSString *napTitle;
    NSString *napDesc;
    
    NSDictionary *napAges;
    NSDictionary *napBabyArgsInfo;
    
    NSNumber *napThemeNote;
    NSDictionary *napThemeInfo;
    
    NSNumber *napCost;
    NSDictionary *napCostInfo;
    
    NSDictionary *napAdressInfo;
    
//    NSDictionary *dic_device;
    NSNumber *napDeviceNote;
    NSString *customDeviceName;
    
    BOOL isEditModel;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    titles = [NSMutableArray arrayWithObjects:@"添加图片", @"设置类型", @"撰写标题", @"撰写描述", @"设置孩子年龄", @"设置价格", @"场地友好性(选填)", nil];
    sub_titles = [NSMutableArray arrayWithObjects:
                  @"添加图片",
                  @"选择您的服务类型",
                  @"与众不同的标题可以展示您的魅力",
                  @"总结您的服务亮点",
                  @"您服务适合的孩子年龄范围",
                  @"一开始可以试试具有吸引力的价格",
                  @"为孩子提供更友好的场地体验",  nil];
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
    
//    isEditModel = NO;
    
    NSDictionary *dic = (NSDictionary*)args;
    
    NSString *key = [dic objectForKey:@"key"];
    
    if ([key isEqualToString:@"nap_cover"]) {
        napPhoto = [[dic objectForKey:@"content"] objectAtIndex:0];
        
    } else if([key isEqualToString:@"nap_title"]){
        napTitle = [dic objectForKey:@"title"];
        
    } else if([key isEqualToString:@"nap_desc"]){
        napDesc = [dic objectForKey:@"content"];
        
    } else if([key isEqualToString:@"nap_ages"]){
        napAges = [dic objectForKey:@"age_boundary"];
        napBabyArgsInfo = [dic copy];
        
    } else if([key isEqualToString:@"nap_cost"]){
        napCost = [dic objectForKey:@"price"];
        napCostInfo = [dic copy];
        
    } else if([key isEqualToString:@"nap_adress"]){
        napAdressInfo = [dic copy];
        
    } else if([key isEqualToString:@"nap_device"]){
        napDeviceNote = [dic objectForKey:@"facility"];
        
    } else if ([key isEqualToString:@"nap_theme"]) {
        napThemeNote = [dic objectForKey:@"cans"];
        napThemeInfo = [dic copy];
    }
    
    return nil;
}

- (id)changeQueryInfo:(NSDictionary*)info {
    
    isEditModel = YES;
    titles = [NSMutableArray arrayWithObjects:
                  @"编辑图片",
                  @"编辑类型",
                  @"编辑标题",
                  @"编辑描述",
                  @"编辑孩子年龄",
                  @"编辑价格",
                  @"编辑场地友好设施",  nil];
    
    napPhotoName = [[info objectForKey:@"images"] objectAtIndex:0];
    napTitle = [info objectForKey:@"title"];
    napDesc = [info objectForKey:@"description"];
    
    NSMutableDictionary *dic_baby_args = [[NSMutableDictionary alloc]init];
    [dic_baby_args setValue:[info objectForKey:@"age_boundary"] forKey:@"age_boundary"];
    [dic_baby_args setValue:[info objectForKey:@"capacity"] forKey:@"capacity"];
    [dic_baby_args setValue:[info objectForKey:@"capacity_waiter"] forKey:@"capacity_waiter"];
    napBabyArgsInfo = [dic_baby_args copy];
    napAges = [info objectForKey:@"age_boundary"];
    
    NSMutableDictionary *dic_cost = [[NSMutableDictionary alloc]init];
    [dic_cost setValue:[info objectForKey:@"price"] forKey:@"price"];
    [dic_cost setValue:[info objectForKey:@"least_hours"] forKey:@"least_hours"];
    napCostInfo = [dic_cost copy];
    napCost = [info objectForKey:@"price"];
    
    NSMutableDictionary *dic_address = [[NSMutableDictionary alloc]init];
    [dic_address setValue:[info objectForKey:@"location"] forKey:@"location"];
    [dic_address setValue:[info objectForKey:@"address"] forKey:@"address"];
    [dic_address setValue:[info objectForKey:@"adjust_address"] forKey:@"adjust_address"];
    napAdressInfo = [dic_address copy];
//    napAdress = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"address"], [dic objectForKey:@"adjust_address"]];
    
    napDeviceNote = [info objectForKey:@"facility"];
    
    NSMutableDictionary *dic_theme = [[NSMutableDictionary alloc]init];
    [dic_theme setValue:[info objectForKey:@"cans"] forKey:@"cans"];
    [dic_theme setValue:[info objectForKey:@"allow_leave"] forKey:@"allow_leave"];
    napThemeInfo = [dic_theme copy];
    napThemeNote = [info objectForKey:@"cans"];
    
    {
        NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
        [dic_options setValue:[info objectForKey:@"facility"] forKey:@"option_pow"];
        [dic_options setValue:@"自填" forKey:@"option_custom"];
//        dic_device = dic_options;
    }
    
    {
        NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
        [dic_options setValue:[info objectForKey:@"cans"] forKey:@"option_pow"];
        [dic_options setValue:@"自填" forKey:@"option_custom"];
        [dic_options setValue:[info objectForKey:@"price"] forKey:@"price"];
//        dic_cost = dic_options;
    }
    
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell = nil;
    if (indexPath.row == 0) {
        NSString* class_name = @"AYNapPhotosCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id info = nil;
        if (napPhoto) {
            info = napPhoto;
            kAYViewSendMessage(cell, @"setCellInfo:", &info)
        }
        else if (napPhotoName) {
            info = napPhotoName;
            kAYViewSendMessage(cell, @"setCellInfo:", &info)
        }
        
    } else {
        
        NSString* class_name = isEditModel? @"AYNapEditInfoCellView" : @"AYNapBabyAgeCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *cell_info = [[NSMutableDictionary alloc]init];
        [cell_info setValue:[titles objectAtIndex:indexPath.row] forKey:@"title"];
        [cell_info setValue:[sub_titles objectAtIndex:indexPath.row] forKey:@"sub_title"];
        [cell_info setValue:[NSNumber numberWithBool:NO] forKey:@"is_seted"];
        
        if (napThemeNote.longValue != 0 && indexPath.row == 1) {
            NSArray *options_title_cans = kAY_service_options_title_cans;
            NSString *theme = @"服务主题";
            long options = napThemeNote.longValue;
            for (int i = 0; i < options_title_cans.count; ++i) {
                long note_pow = pow(2, i);
                if ((options & note_pow)) {
                    theme = [NSString stringWithFormat:@"%@",options_title_cans[i]];
                    break;
                }
            }
            [cell_info setValue:theme forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if (napTitle && ![napTitle isEqualToString:@""] && indexPath.row == 2) {
            [cell_info setValue:napTitle forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if (napDesc && ![napDesc isEqualToString:@""] && indexPath.row == 3) {
            [cell_info setValue:napDesc forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if (napAges && indexPath.row == 4) {
            NSNumber *usl = ((NSNumber *)[napAges objectForKey:@"usl"]);
            NSNumber *lsl = ((NSNumber *)[napAges objectForKey:@"lsl"]);
            NSString *ages = [NSString stringWithFormat:@"%d ~ %d 岁",lsl.intValue,usl.intValue];
            [cell_info setValue:ages forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if (napCost.floatValue != 0 && indexPath.row == 5) {
            NSString *price = [NSString stringWithFormat:@"￥ %@/小时",napCost];
            [cell_info setValue:price forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if (napDeviceNote.longValue != 0 && indexPath.row == 6) {
            NSArray *options_title_facilities = kAY_service_options_title_facilities;
            NSString *device = @"";
            long options = napDeviceNote.longValue;
            int noteCount = 0;
            for (int i = 0; i < options_title_facilities.count; ++i) {
                long note_pow = pow(2, i);
                if ((options & note_pow)) {
                    device = [[device stringByAppendingString:@"、"] stringByAppendingString:options_title_facilities[i]];
                    noteCount ++;
                    if (noteCount == 3) {
                        device = [device stringByAppendingString:@"等"];
                        break;
                    }
                }
            }
            device = [device substringFromIndex:1];
            [cell_info setValue:device forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        
        id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [set_cmd performWithResult:&cell_info];
        
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 250;
    } else {
        return 70;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    } else if (indexPath.row == 1){
        [self setNapTheme];         //服务主题
        
    } else if (indexPath.row == 2){
        [self setNapTitle];
        
    } else if (indexPath.row == 3){
//        [self setNapAdress];
        [self setServiceDesc];
        
    } else if (indexPath.row == 4){
        [self setNapBabyAges];
        
    } else if (indexPath.row == 5){
        [self setNapCost];
        
    } else {
        [self setNapDevice];
    }
}


#pragma mark -- notifies set service info
- (void)setNapTitle {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputNapTitle");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[napTitle copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setNapBabyAges {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"SetNapAges");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    [dic_push setValue:[napBabyArgsInfo copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setNapTheme {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapTheme");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[napThemeInfo copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setNapCost {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapCost");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[napCostInfo copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setNapAdress {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"InputNapAdress");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    [dic_args setValue:[napAdressInfo objectForKey:@"address"] forKey:@"address"];
    [dic_args setValue:[napAdressInfo objectForKey:@"adjust_address"] forKey:@"adjust_address"];
    NSDictionary *loc_dic = [napAdressInfo objectForKey:@"location"];
    CLLocation *napLoc = [[CLLocation alloc]initWithLatitude:((NSNumber*)[loc_dic objectForKey:@"latitude"]).doubleValue longitude:((NSNumber*)[loc_dic objectForKey:@"longtitude"]).doubleValue];
    [dic_args setValue:napLoc forKey:@"location"];
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setServiceDesc {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"ServiceDesc");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[napDesc copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setNapDevice {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    
    [dic_args setValue:[napDeviceNote copy] forKey:@"facility"];
//    [dic_args setValue:[service_info objectForKey:@"option_custom"] forKey:@"option_custom"];
    
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}

@end
