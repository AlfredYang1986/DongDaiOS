//
//  AYOrderStateCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderStateCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"

#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@interface AYOrderStateCellView ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *QRCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *planTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *planCostLabel;

@end

@implementation AYOrderStateCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpReuseCell];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderStateCell", @"OrderStateCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (IBAction)didQRCodeBtnClick:(id)sender {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didQRCodeBtnClick"];
    [cmd performWithResult:nil];
}

- (id)setCellInfo:(NSDictionary*)args{
    
    int status = ((NSNumber*)[args objectForKey:@"status"]).intValue;
    switch (status) {
        case 0:
            _stateLabel.text = @"待确认订单";
            break;
        case 1:
            _stateLabel.text = @"已确认订单";
            break;
        case 2:
            _stateLabel.text = @"已完成订单";
            break;
        default:
            break;
    }
    
    /*******************/
    NSDictionary *order_date = [args objectForKey:@"order_date"];
    NSTimeInterval start = ((NSNumber*)[order_date objectForKey:@"start"]).longValue;
    NSTimeInterval end = ((NSNumber*)[order_date objectForKey:@"end"]).longValue;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
    
    NSDateFormatter *formatterDay = [[NSDateFormatter alloc]init];
    [formatterDay setDateFormat:@"MM月dd日"];
    NSString *dayStr = [formatterDay stringFromDate:startDate];
    
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc]init];
    [formatterTime setDateFormat:@"HH:mm"];
    NSString *startStr = [formatterTime stringFromDate:startDate];
    NSString *endStr = [formatterTime stringFromDate:endDate];
    
    _planTimeLabel.text = [NSString stringWithFormat:@"%@, %@-%@",dayStr,startStr,endStr];
    
//    NSString *str = [args objectForKey:@"price"];
    _planCostLabel.text = [NSString stringWithFormat:@"%f",((NSNumber*)[args objectForKey:@"price"]).floatValue];
    
    return nil;
}
@end
