//
//  AYOrderInfoDateCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoDateCellView.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "GPUImage.h"
#import "Define.h"
#import "PhotoTagEnumDefines.h"
#import "QueryContentTag.h"
#import "QueryContentChaters.h"
#import "QueryContent+ContextOpt.h"
#import "AppDelegate.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYHomeCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "AYThumbsAndPushDefines.h"

#import "InsetsLabel.h"
#import "OBShapedButton.h"

@implementation AYOrderInfoDateCellView {
    
    UILabel *dateLabel;
    UIButton *editDateBtn;
    
    UIView *setTimeView;
    UILabel *fromeLabel;
    UILabel *toLabel;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CALayer *line_separator = [CALayer layer];
        line_separator.backgroundColor = [Tools garyLineColor].CGColor;
        line_separator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
        [self.layer addSublayer:line_separator];
        
        
        dateLabel = [[UILabel alloc]init];
        [self addSubview:dateLabel];
        dateLabel = [Tools setLabelWith:dateLabel andText:@"服务时间" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        
        editDateBtn = [[UIButton alloc]init];
        [editDateBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        editDateBtn.titleLabel.font = kAYFontLight(14.f);
        [self addSubview:editDateBtn];
        [editDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dateLabel);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(40, 16));
        }];
        [editDateBtn addTarget:self action:@selector(didEditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        setTimeView = [[UIView alloc]init];
        [self addSubview:setTimeView];
        [setTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(50);
        }];
        setTimeView.userInteractionEnabled = YES;
        [setTimeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didEditTimes)]];
        
        CALayer *shpear = [CALayer layer];
        shpear.backgroundColor = [Tools themeColor].CGColor;
        shpear.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5, 50);
        [setTimeView.layer addSublayer:shpear];
        
        CGFloat offsetX = [UIScreen mainScreen].bounds.size.width * 0.25;
        UILabel *fromTitleLabel = [UILabel new];
        fromTitleLabel = [Tools setLabelWith:fromTitleLabel andText:@"开始时间" andTextColor:[UIColor whiteColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [setTimeView addSubview:fromTitleLabel];
        [fromTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(setTimeView).offset(5);
            make.centerX.equalTo(setTimeView).offset(-offsetX);
        }];
        
        fromeLabel = [UILabel new];
        fromeLabel = [Tools setLabelWith:fromeLabel andText:@"10:00" andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [setTimeView addSubview:fromeLabel];
        [fromeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(fromTitleLabel);
            make.top.equalTo(fromTitleLabel.mas_bottom).offset(0);
        }];
        
        UILabel *endTitleLabel = [UILabel new];
        endTitleLabel = [Tools setLabelWith:endTitleLabel andText:@"结束时间" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [setTimeView addSubview:endTitleLabel];
        [endTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(setTimeView).offset(5);
            make.centerX.equalTo(setTimeView).offset(offsetX);
        }];
        
        toLabel = [UILabel new];
        toLabel = [Tools setLabelWith:toLabel andText:@"12:00" andTextColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [setTimeView addSubview:toLabel];
        [toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(endTitleLabel);
            make.centerY.equalTo(fromeLabel);
        }];
        
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderInfoDateCell", @"OrderInfoDateCell");
    
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

#pragma mark -- actions
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
    
}

- (void)didEditBtnClick:(UIButton*)btn {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didEditDate"];
    [cmd performWithResult:nil];
    
}

- (void)didEditTimes {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didEditTimes"];
    [cmd performWithResult:nil];
    
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
    
//    BOOL isSetedDate = ((NSNumber*)[dic_args objectForKey:@"be_setedDate"]).boolValue;
    
    
    
    NSNumber *date = [dic_args objectForKey:@"order_date"];
    if (date) {
        
        [dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self).offset(15);
        }];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
        NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
        [format setTimeZone:timeZone];
        NSDate *today = [NSDate dateWithTimeIntervalSince1970:date.doubleValue];
        NSString *dateStr = [format stringFromDate:today];
        dateLabel.text = dateStr;
        
        [editDateBtn setTitle:@"编辑" forState:UIControlStateNormal];
        setTimeView.hidden = NO;
        
        NSDictionary *times = [dic_args objectForKey:@"order_times"];
        NSString *start = [times objectForKey:@"start"];
        NSString *end = [times objectForKey:@"end"];
        if (start) {
            fromeLabel.text = start;
        }
        if (end) {
            toLabel.text = end;
        }
        
    } else {
        
        [dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        
        [editDateBtn setTitle:@"添加" forState:UIControlStateNormal];
        setTimeView.hidden = YES;
    }
    
    return nil;
}

@end
