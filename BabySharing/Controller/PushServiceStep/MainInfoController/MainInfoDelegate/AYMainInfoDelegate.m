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
    
//    NSNumber *napCost;
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
    
    titles = [NSMutableArray arrayWithObjects:@"添加图片", @"撰写标题", @"撰写描述", @"设置价格", @"制定《服务守则》", @"场地友好性(选填)", nil];
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
    
    NSDictionary *dic = (NSDictionary*)args;
    
    NSString *key = [dic objectForKey:@"key"];
    
    
    if ([key isEqualToString:kAYServiceArgsServiceInfo]) {
        service_info = [dic objectForKey:kAYServiceArgsServiceInfo];
        napThemeNote = [[dic objectForKey:kAYServiceArgsServiceInfo] objectForKey:kAYServiceArgsCourseCat];
    }
    else if ([key isEqualToString:kAYServiceArgsServiceCat]) {
        service_cat = ((NSNumber*)[dic objectForKey:kAYServiceArgsServiceCat]).intValue;
        napThemeNote = [dic objectForKey:kAYServiceArgsCourseCat];
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
//        napCost = [dic objectForKey:@"price"];
        napCostInfo = [dic copy];
        
    } else if([key isEqualToString:@"nap_adress"]) {
        napAdressInfo = [dic copy];
        
    } else if([key isEqualToString:kAYServiceArgsFacility]) {
        napDeviceNote = [dic objectForKey:@"facility"];
        
    }
    else if ([key isEqualToString:kAYServiceArgsNotice]) {
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
    service_cat = ((NSNumber*)[info objectForKey:kAYServiceArgsServiceCat]).intValue;
    napPhotoName = [[info objectForKey:kAYServiceArgsImages] objectAtIndex:0];
    napTitle = [info objectForKey:kAYServiceArgsTitle];
    
    NSMutableDictionary *dic_title = [[NSMutableDictionary alloc]init];
    [dic_title setValue:[info objectForKey:kAYServiceArgsTitle] forKey:kAYServiceArgsTitle];
    [dic_title setValue:[info objectForKey:kAYServiceArgsCourseSign] forKey:kAYServiceArgsCourseSign];
    [dic_title setValue:[info objectForKey:kAYServiceArgsCourseCoustom] forKey:kAYServiceArgsCourseCoustom];
    napThemeNote = [info objectForKey:kAYServiceArgsTheme];
    napTitleInfo = [dic_title copy];
    
    napDesc = [info objectForKey:kAYServiceArgsDescription];
    
    NSMutableDictionary *dic_baby_args = [[NSMutableDictionary alloc]init];
    [dic_baby_args setValue:[info objectForKey:kAYServiceArgsAgeBoundary] forKey:kAYServiceArgsAgeBoundary];
    [dic_baby_args setValue:[info objectForKey:kAYServiceArgsCapacity] forKey:kAYServiceArgsCapacity];
    [dic_baby_args setValue:[info objectForKey:kAYServiceArgsServantNumb] forKey:kAYServiceArgsServantNumb];
    napBabyArgsInfo = [dic_baby_args copy];
    napAges = [info objectForKey:kAYServiceArgsAgeBoundary];
    
    NSMutableDictionary *dic_cost = [[NSMutableDictionary alloc]init];
    [dic_cost setValue:[info objectForKey:kAYServiceArgsPrice] forKey:kAYServiceArgsPrice];
    [dic_cost setValue:[info objectForKey:kAYServiceArgsLeastHours] forKey:kAYServiceArgsLeastHours];
    [dic_cost setValue:[info objectForKey:kAYServiceArgsLeastTimes] forKey:kAYServiceArgsLeastTimes];
    [dic_cost setValue:[info objectForKey:kAYServiceArgsCourseduration] forKey:kAYServiceArgsCourseduration];
    napCostInfo = [dic_cost copy];
    
    NSMutableDictionary *dic_address = [[NSMutableDictionary alloc]init];
    [dic_address setValue:[info objectForKey:kAYServiceArgsLocation] forKey:kAYServiceArgsLocation];
    [dic_address setValue:[info objectForKey:kAYServiceArgsAddress] forKey:kAYServiceArgsAddress];
    [dic_address setValue:[info objectForKey:kAYServiceArgsAdjustAddress] forKey:kAYServiceArgsAdjustAddress];
    napAdressInfo = [dic_address copy];
    
    napDeviceNote = [info objectForKey:kAYServiceArgsFacility];
    
    NSMutableDictionary *dic_notice = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic_notice setValue:[info objectForKey:kAYServiceArgsAllowLeave] forKey:kAYServiceArgsAllowLeave];
    [dic_notice setValue:[info objectForKey:kAYServiceArgsNotice] forKey:kAYServiceArgsNotice];
    serviceNoticeInfo = [dic_notice copy];
    
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
            
            //constain of title and course_sign or coustom and or service_cat == 0
            if (coustom || course_sign.intValue != 0 || service_cat == ServiceTypeLookAfter) {
                [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
            }
        }
        else if (napDesc && ![napDesc isEqualToString:@""] && indexPath.row == 2) {
            [cell_info setValue:napDesc forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if ( indexPath.row == 3) {
            
            NSNumber *price = [napCostInfo objectForKey:kAYServiceArgsPrice];
            NSNumber *leastHours = [napCostInfo objectForKey:kAYServiceArgsLeastHours];
            NSNumber *duration = [napCostInfo objectForKey:kAYServiceArgsCourseduration];
            NSNumber *leastTimes = [napCostInfo objectForKey:kAYServiceArgsLeastTimes];
            
            if (price && price.floatValue != 0) {
                NSString *priceTitleStr ;
                
                if (service_cat == ServiceTypeLookAfter) {
					priceTitleStr = [NSString stringWithFormat:@"￥ %@/小时",price];
                    if ( leastHours && leastHours.floatValue != 0) {
                        [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
                    }
                } else {
					priceTitleStr = [NSString stringWithFormat:@"￥ %@/次",price];
                    if (duration && duration.floatValue != 0 && leastTimes && leastTimes.floatValue != 0) {
                        [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
                    }
                }//
				
				[cell_info setValue:priceTitleStr forKey:@"sub_title"];
				
            }
            
            
        }
        else if (serviceNoticeInfo && indexPath.row == 4) {
//            NSNumber *isAllowLeave = [serviceNoticeInfo objectForKey:kAYServiceArgsAllowLeave];
            BOOL isAllowLeave = ((NSNumber*) [serviceNoticeInfo objectForKey:kAYServiceArgsAllowLeave]).boolValue;
            NSString *notice =  isAllowLeave ? @"需要家长陪伴" : @"不需要家长陪伴";
            [cell_info setValue:notice forKey:@"sub_title"];
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
    [tmp setValue:napThemeNote forKey:kAYServiceArgsCourseCat];
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
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]initWithDictionary:service_info];
        [tmp setValue:[NSNumber numberWithInt:service_cat] forKey:kAYServiceArgsServiceCat];
        [tmp setValue:napThemeNote forKey:kAYServiceArgsCourseCat];
        [dic_push setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
        
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
        [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
    
}

@end
