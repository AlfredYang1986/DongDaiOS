//
//  AYServicePageDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServicePageDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

//#import "AYServiceInfoCellView.h"
//#import "AYFouceCellView.h"

#define WIDTH               SCREEN_WIDTH - 15*2

@implementation AYServicePageDelegate {
    NSDictionary *querydata;
    NSString *personal_description;
    
    BOOL isExpend;
    CGFloat expendHeight;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    isExpend = NO;
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)changeQueryData:(NSDictionary*)args{
    querydata = args;
    
    return nil;
}

- (id)changeDescription:(id)args {
    personal_description = (NSString*)args;
    return nil;
}

- (id)TransfromExpend:(NSNumber*)args {
    isExpend = YES;
    expendHeight = args.floatValue;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name;
    id<AYViewBase> cell;
    
    if (indexPath.row == 0) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceTitleCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSDictionary *tmp = [querydata copy];
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    else if (indexPath.row ==1) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceOwnerInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *tmp = [querydata mutableCopy];
        [tmp setValue:personal_description forKey:@"personal_description"];
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    else if (indexPath.row == 2) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = [querydata  objectForKey:@"cans"];
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    else if (indexPath.row == 3) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceFacilityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = [querydata  objectForKey:@"facility"];
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    else if (indexPath.row == 4) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = [querydata objectForKey:@"location"];
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    else if (indexPath.row == 5) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceCalendarCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    }
    else if (indexPath.row == 6) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServiceCostCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 165;
    }
    else if (indexPath.row ==1) {
        
        NSString *descStr = personal_description;
        if (!descStr || [descStr isEqualToString:@""]) {
            return 85;
        }
        else {
            if (descStr.length > 60) {
                if (isExpend) {
                    return 85 + expendHeight + 30;
                } else
                    return 200;
            } else {
                CGSize filtSize = [Tools sizeWithString:descStr withFont:kAYFontLight(14.f) andMaxSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)];
                return 85 + filtSize.height + 20;
            }
//            return 85 + expendHeight + 25;
            
            //200
        }
    }
    else if (indexPath.row == 2) {
        return 60;
    }
    else if (indexPath.row == 3) {
        
        long options = ((NSNumber*)[querydata objectForKey:@"facility"]).longValue;
        return options == 0 ? 0.001 : 90;
    }
    else if (indexPath.row == 4) {
        return 225;
    }
    else
        return 70;
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat off_y = scrollView.contentOffset.y;
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollOffsetY:"];
    NSNumber *y = [NSNumber numberWithFloat:off_y];
    [cmd performWithResult:&y];
}

#pragma mark -- actions
- (void)onesPhotoIconTap:(UITapGestureRecognizer*)tap {
    
    AYViewController* des = DEFAULTCONTROLLER(@"OneProfile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[querydata objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}


-(void)didShowMoreClick:(UIButton*)btn{
    id<AYCommand> des = DEFAULTCONTROLLER(@"ContentList");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    //    [dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
}

//更多项目展示
- (void)didMoreOptionsBtnClick:(UIButton*)btn {
    if (btn.tag == 110) {   //cans
        id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapCost");
        
        NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        
            NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
            [dic_info setValue:[querydata objectForKey:@"cans"] forKey:@"option_pow"];
            [dic_info setValue:[NSString stringWithFormat:@"%@",[querydata objectForKey:@"price"]] forKey:@"cost"];
            [dic_info setValue:@"自填项" forKey:@"option_custom"];
            [dic_info setValue:[NSNumber numberWithBool:YES] forKey:@"show"];
        
        [dic_push setValue:dic_info forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }else {                 //facility
        
        id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
        
        NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        
            NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
            [dic_info setValue:[querydata objectForKey:@"facility"] forKey:@"option_pow"];
            [dic_info setValue:@"自填项" forKey:@"option_custom"];
            [dic_info setValue:[NSNumber numberWithBool:YES] forKey:@"show"];
        
        [dic_push setValue:dic_info forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

//* 1/1/1 *//
-(void)didDailyBtnClick:(UIButton*)btn {
    
}

-(void)didCostBtnClick:(UIButton*)btn {
    
}

//2
-(void)didSafePolicyClick:(UIButton*)btn {
    
}

-(void)didTDPolicyClick:(UIButton*)btn {
    
}

-(void)didXFriendImage:(UIGestureRecognizer*)tap {
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"共同好友" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
}

-(void)didPopImage:(UIButton*)tap {
    id<AYCommand> pop = [self.notifies objectForKey:@"sendPopMessage"];
    [pop performWithResult:nil];
}
@end
