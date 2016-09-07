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
    
    NSNumber *napThemeNote;
    
    NSString *napCost;
    
    NSString *napAdress;
    
//    NSDictionary *dic_device;
    NSNumber *napDeviceNote;
    
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
        napTitle = [dic objectForKey:@"title"];
        
    } else if([key isEqualToString:@"nap_desc"]){
        napDesc = [dic objectForKey:@"content"];
        
    } else if([key isEqualToString:@"nap_ages"]){
        napAges = [dic objectForKey:@"age_boundary"];
        
    } else if([key isEqualToString:@"nap_cost"]){
        napCost = [dic objectForKey:@"price"];
        
    } else if([key isEqualToString:@"nap_adress"]){
        napAdress = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"address"], [dic objectForKey:@"adjust_address"]];
        
    } else if([key isEqualToString:@"nap_device"]){
        napDeviceNote = [dic objectForKey:@"facility"];
        
    } else if ([key isEqualToString:@"nap_theme"]) {
        napThemeNote = [dic objectForKey:@"cans"];
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
//        dic_device = dic_options;
    }
    
    {
        NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
        [dic_options setValue:[info objectForKey:@"cans"] forKey:@"option_pow"];
        [dic_options setValue:@"自填" forKey:@"option_custom"];
        [dic_options setValue:[info objectForKey:@"price"] forKey:@"price"];
//        dic_cost = dic_options;
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
        if (napThemeNote && indexPath.row == 3) {
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
            [cell_info setValue:theme forKey:@"args"];
        }
        if (napCost && indexPath.row == 4) {
            NSString *price = [NSString stringWithFormat:@"￥ %@/小时",napCost];
            [cell_info setValue:price forKey:@"args"];
        }
        if (napAdress && indexPath.row == 5) {
            [cell_info setValue:napAdress forKey:@"args"];
        }
        if (napDeviceNote && indexPath.row == 6) {
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
            [cell_info setValue:device forKey:@"args"];
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
        [self setNapTheme];         //服务主题
    } else if (indexPath.row == 4){
        [self setNapCost];
    } else if (indexPath.row == 5){
        [self setNapAdress];
    } else {
        [self setNapDevice];
    }
}


#pragma mark -- notifies set service info
- (void)setNapTitle {
    id<AYCommand> cmd = [self.notifies objectForKey:@"inputNapTitleAction"];
    [cmd performWithResult:nil];
}

- (void)setNapBabyAges {
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapBabyAges"];
    [cmd performWithResult:nil];
}

- (void)setNapTheme {
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapTheme"];
    [cmd performWithResult:nil];
}

- (void)setNapCost {
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapCost"];
    [cmd performWithResult:nil];
}

- (void)setNapAdress {
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapAdress"];
    [cmd performWithResult:nil];
}

- (void)setNapDevice {
    id<AYCommand> cmd = [self.notifies objectForKey:@"setNapDevice"];
    [cmd performWithResult:nil];
}

@end
