//
//  AYOrderCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderCellView.h"
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

@interface AYOrderCellView ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbsImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;

@end

@implementation AYOrderCellView

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
    id<AYViewBase> cell = VIEW(@"OrderCell", @"OrderCell");
    
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

- (id)setCellInfo:(NSDictionary*)args{
    
    NSString* photo_name = [args objectForKey:@"order_thumbs"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_thum" forKey:@"expect_size"];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            _thumbsImage.image = img;
        }else{
            [_thumbsImage setImage:IMGRESOURCE(@"sample_image")];
        }
    }];
    
    NSTimeInterval book = ((NSNumber*)[args objectForKey:@"date"]).longValue * 0.001;
    NSDate *bookDate = [NSDate dateWithTimeIntervalSince1970:book];
    NSDateFormatter *formatterBookDay = [[NSDateFormatter alloc]init];
    [formatterBookDay setDateFormat:@"yyyy年MM月dd日"];
    NSString *bookStr = [formatterBookDay stringFromDate:bookDate];
    _dateLabel.text = bookStr;
    
    int status = ((NSNumber*)[args objectForKey:@"status"]).intValue;
    switch (status) {
        case 0:
            _statusLabel.text = @"待确认订单";
            break;
        case 1:
            _statusLabel.text = @"已确认订单";
            break;
        case 2:
            _statusLabel.text = @"已完成订单";
            break;
        default:
            break;
    }
    
    /*******************/
    _titleLabel.text = [[args objectForKey:@"service"] objectForKey:@"title"];
    
    NSDictionary *order_date = [args objectForKey:@"order_date"];
    NSTimeInterval start = ((NSNumber*)[order_date objectForKey:@"start"]).longValue;
    NSTimeInterval end = ((NSNumber*)[order_date objectForKey:@"end"]).longValue;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
    
    NSDateFormatter *formatterDay = [[NSDateFormatter alloc]init];
    [formatterDay setDateFormat:@"MM月dd日 EEEE"];
    NSString *dayStr = [formatterDay stringFromDate:startDate];
    
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc]init];
    [formatterTime setDateFormat:@"HH:mm"];
    NSString *startStr = [formatterTime stringFromDate:startDate];
    NSString *endStr = [formatterTime stringFromDate:endDate];
    
    _orderDateLabel.text = [NSString stringWithFormat:@"%@, %@ - %@",dayStr,startStr,endStr];
    
    NSNumber *isRead = [args objectForKey:@"is_read"];
    if (isRead.intValue == 0) {
        UIView *icon = [[UIView alloc]init];
        icon.backgroundColor = [Tools themeColor];
        icon.layer.cornerRadius = 4.f;
        icon.clipsToBounds = YES;
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_thumbsImage);
            make.right.equalTo(self).offset(-25);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    
    return nil;
}
@end
