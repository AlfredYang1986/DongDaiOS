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

#import "AYServiceArgsDefines.h"

@interface AYMainInfoDelegate ()
//@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYMainInfoDelegate {
    NSMutableArray *titles;
    NSMutableArray *sub_titles;
    ServiceType service_cat;
    
    UIImage *napPhoto;
    NSString *napPhotoName;
    
    NSString *napTitle;
    NSDictionary *napTitleInfo;
    
    NSString *napDesc;
    
    NSDictionary *napAges;
    NSDictionary *napBabyArgsInfo;
    
    NSNumber *napThemeNote;
    NSDictionary *napThemeInfo;
    
    NSNumber *napCost;
    NSDictionary *napCostInfo;
    
    NSDictionary *serviceNoticeInfo;
    
    NSDictionary *napAdressInfo;
    
//    NSDictionary *dic_device;
    NSNumber *napDeviceNote;
    NSString *customDeviceName;
    
    BOOL isEditModel;
    NSDictionary *service_info;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    titles = [NSMutableArray arrayWithObjects:@"添加图片", @"撰写标题", @"撰写描述", @"设置价格", @"制定《服务守则》", @"更多信息(选填)", nil];
    sub_titles = [NSMutableArray arrayWithObjects:
                  @"添加图片",
                  @"与众不同的标题可以展示您的魅力",
                  @"总结您的服务亮点",
                  @"一开始可以试试具有吸引力的价格",
                  @"预定前家长需要同意服务守则",
                  @"为孩子提供更友好的场地体验", nil];
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
- (id)changeQueryData:(id)args {
    
//    isEditModel = NO;
    
    NSDictionary *dic = (NSDictionary*)args;
    
    NSString *key = [dic objectForKey:@"key"];
    if ([key isEqualToString:kAYServiceArgsServiceCat]) {
        service_cat = ((NSNumber*)[dic objectForKey:kAYServiceArgsServiceCat]).intValue;
        napThemeNote = [dic objectForKey:kAYServiceArgsTheme];
    }
    else if ([key isEqualToString:@"nap_cover"]) {
        napPhoto = [[dic objectForKey:@"content"] objectAtIndex:0];
        
    } else if([key isEqualToString:kAYServiceArgsTitle]) {
        napTitle = [dic objectForKey:kAYServiceArgsTitle];
        napTitleInfo = [dic copy];
        
    } else if([key isEqualToString:@"nap_desc"]) {
        napDesc = [dic objectForKey:@"content"];
        
    } else if([key isEqualToString:@"nap_ages"]) {
        napAges = [dic objectForKey:@"age_boundary"];
        napBabyArgsInfo = [dic copy];
        
    } else if([key isEqualToString:@"nap_cost"]) {
        napCost = [dic objectForKey:@"price"];
        napCostInfo = [dic copy];
        
    } else if([key isEqualToString:@"nap_adress"]) {
        napAdressInfo = [dic copy];
        
    } else if([key isEqualToString:kAYServiceArgsFacility]) {
        napDeviceNote = [dic objectForKey:@"facility"];
        
    } else if ([key isEqualToString:@"nap_theme"]) {
        napThemeNote = [dic objectForKey:@"cans"];
        napThemeInfo = [dic copy];
    } else if ([key isEqualToString:kAYServiceArgsNotice]) {
        serviceNoticeInfo = [dic copy];
    }
    
    return nil;
}

- (id)changeQueryInfo:(NSDictionary*)info {
    
    isEditModel = YES;
    service_info = info;
    
    titles = [NSMutableArray arrayWithObjects:
                  @"编辑图片",
                  @"编辑标题",
                  @"编辑描述",
                  @"编辑价格",
                  @"编辑《服务守则》",
                  @"更多信息",  nil];
    
    napPhotoName = [[info objectForKey:@"images"] objectAtIndex:0];
    napTitle = [info objectForKey:kAYServiceArgsTitle];
    
    NSMutableDictionary *dic_title = [[NSMutableDictionary alloc]init];
    [dic_title setValue:[info objectForKey:kAYServiceArgsTitle] forKey:kAYServiceArgsTitle];
    [dic_title setValue:[info objectForKey:kAYServiceArgsCourseSign] forKey:kAYServiceArgsCourseSign];
    [dic_title setValue:[info objectForKey:kAYServiceArgsCourseCoustom] forKey:kAYServiceArgsCourseCoustom];
    napTitleInfo = [dic_title copy];
    
    napDesc = [info objectForKey:@"description"];
    
    NSMutableDictionary *dic_baby_args = [[NSMutableDictionary alloc]init];
    [dic_baby_args setValue:[info objectForKey:@"age_boundary"] forKey:@"age_boundary"];
    [dic_baby_args setValue:[info objectForKey:@"capacity"] forKey:@"capacity"];
    [dic_baby_args setValue:[info objectForKey:@"servant_no"] forKey:@"servant_no"];
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
    
    napDeviceNote = [info objectForKey:kAYServiceArgsFacility];
    
    NSMutableDictionary *dic_theme = [[NSMutableDictionary alloc]init];
    [dic_theme setValue:[info objectForKey:@"cans"] forKey:@"cans"];
    [dic_theme setValue:[info objectForKey:@"allow_leave"] forKey:@"allow_leave"];
    napThemeInfo = [dic_theme copy];
    napThemeNote = [info objectForKey:@"cans"];
    
    NSMutableDictionary *dic_notice = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic_notice setValue:[info objectForKey:kAYServiceArgsAllowLeave] forKey:kAYServiceArgsAllowLeave];
    [dic_notice setValue:[info objectForKey:kAYServiceArgsNotice] forKey:kAYServiceArgsNotice];
    serviceNoticeInfo = [dic_notice copy];
    
    {
        NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
        [dic_options setValue:[info objectForKey:kAYServiceArgsFacility] forKey:@"option_pow"];
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
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 5;
//    } else {
//        return 1;
//    }
    return 6;
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
        
    }  else if (indexPath.row == 5 ) {
        
        NSString* class_name = @"AYOptionalInfoCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSString *title = titles[indexPath.row];
        kAYViewSendMessage(cell, @"setCellInfo:", &title)
        
    }
    else {
        
        NSString* class_name = isEditModel? @"AYNapEditInfoCellView" : @"AYNapBabyAgeCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *cell_info = [[NSMutableDictionary alloc]init];
        [cell_info setValue:[titles objectAtIndex:indexPath.row] forKey:@"title"];
        [cell_info setValue:[sub_titles objectAtIndex:indexPath.row] forKey:@"sub_title"];
        [cell_info setValue:[NSNumber numberWithBool:NO] forKey:@"is_seted"];
        
        if (napTitle && ![napTitle isEqualToString:@""] && indexPath.row == 1) {
            [cell_info setValue:napTitle forKey:@"sub_title"];
            
            NSNumber *course_sign = [napTitleInfo objectForKey:kAYServiceArgsCourseSign];
            NSString *coustom = [napTitleInfo objectForKey:kAYServiceArgsCourseCoustom];
            
            //title constain and course_sign or coustom constain and or service_cat == 0
            if (coustom || course_sign || service_cat == ServiceTypeLookAfter) {
                
                [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
            }
        }
//        else if (napThemeNote.longValue != 0 && indexPath.row == 1) {
//            NSArray *options_title_cans = kAY_service_options_title_course;
//            NSString *theme = @"服务主题";
//            long options = napThemeNote.longValue;
//            for (int i = 0; i < options_title_cans.count; ++i) {
//                long note_pow = pow(2, i);
//                if ((options & note_pow)) {
//                    theme = [NSString stringWithFormat:@"%@",options_title_cans[i]];
//                    break;
//                }
//            }
//            [cell_info setValue:theme forKey:@"sub_title"];
//            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
//        }
        else if (napDesc && ![napDesc isEqualToString:@""] && indexPath.row == 2) {
            [cell_info setValue:napDesc forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
//        else if (napAges && indexPath.row == 4) {
//            NSNumber *usl = ((NSNumber *)[napAges objectForKey:@"usl"]);
//            NSNumber *lsl = ((NSNumber *)[napAges objectForKey:@"lsl"]);
//            NSString *ages = [NSString stringWithFormat:@"%d ~ %d 岁",lsl.intValue,usl.intValue];
//            [cell_info setValue:ages forKey:@"sub_title"];
//            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
//        }
        else if (napCost.floatValue != 0 && indexPath.row == 3) {
            NSString *price = [NSString stringWithFormat:@"￥ %@/小时",napCost];
            [cell_info setValue:price forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if (serviceNoticeInfo && indexPath.row == 4) {
//            NSNumber *isAllowLeave = [serviceNoticeInfo objectForKey:kAYServiceArgsAllowLeave];
            BOOL isAllowLeave = ((NSNumber*) [serviceNoticeInfo objectForKey:kAYServiceArgsAllowLeave]).boolValue;
            NSString *notice =  isAllowLeave ? @"需要家长陪伴" : @"不需要家长陪伴";
            [cell_info setValue:notice forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
//        else if (napDeviceNote.longValue != 0 && indexPath.row == 5) {
//            NSArray *options_title_facilities = kAY_service_options_title_facilities;
//            NSString *device = @"";
//            long options = napDeviceNote.longValue;
//            int noteCount = 0;
//            for (int i = 0; i < options_title_facilities.count; ++i) {
//                long note_pow = pow(2, i);
//                if ((options & note_pow)) {
//                    device = [[device stringByAppendingString:@"、"] stringByAppendingString:options_title_facilities[i]];
//                    noteCount ++;
//                    if (noteCount == 3) {
//                        device = [device stringByAppendingString:@"等"];
//                        break;
//                    }
//                }
//            }
//            device = [device substringFromIndex:1];
//            [cell_info setValue:device forKey:@"sub_title"];
//            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
//        }
        
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
    } else if (indexPath.row == 5) {
//        return isEditModel? 90 : 70;
        return 90 ;
    } else {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        kAYDelegateSendNotify(self, @"addPhotosAction", nil)
        return;
    }
    else if (indexPath.row == 1) {
//        [self setNapTheme];         //服务主题
        [self setNapTitle];
    }
    else if (indexPath.row == 2) {
        [self setServiceDesc];
        
    }
    else if (indexPath.row == 3) {
        [self setNapCost];
        
    } else if (indexPath.row == 4) {        //notice
//        [self setNapBabyAges];
        [self setServiceNotice];
    } else if (indexPath.row == 5) {
        [self setNapDevice];
        
    } else {
        
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [Tools garyBackgroundColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


#pragma mark -- notifies set service info
- (void)setNapTitle {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputNapTitle");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]initWithDictionary:napTitleInfo];
    [tmp setValue:[NSNumber numberWithInt:service_cat] forKey:kAYServiceArgsServiceCat];
    [tmp setValue:napThemeNote forKey:kAYServiceArgsTheme];
    [dic_push setValue:tmp forKey:kAYControllerChangeArgsKey];
    
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
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]initWithDictionary:napCostInfo];
    [tmp setValue:[NSNumber numberWithInt:service_cat] forKey:kAYServiceArgsServiceCat];
    [dic_push setValue:tmp forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setServiceNotice {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetServiceNotice");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
//    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    [dic_push setValue:[serviceNoticeInfo copy] forKey:kAYControllerChangeArgsKey];
    
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
    if (isEditModel) {
        
        id<AYCommand> dest = DEFAULTCONTROLLER(@"EditAdvanceInfo");
        
        NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
    else {
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
    
}

@end
