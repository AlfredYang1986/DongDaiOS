//
//  AYPersonalDescCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 27/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalDescCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

#define WIDTH               SCREEN_WIDTH - 15*2

@implementation AYPersonalDescCellView {
    UILabel *titleLabel;
    UILabel *descLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLabel = [[UILabel alloc]init];
        titleLabel = [Tools setLabelWith:titleLabel andText:@"关于我" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(15);
        }];
        
        descLabel = [[UILabel alloc]init];
        descLabel = [Tools setLabelWith:descLabel andText:@"暂无描述!" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        descLabel.numberOfLines = 0;
        [self addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(12.5);
            make.left.equalTo(titleLabel);
            make.right.equalTo(self).offset(-15);
        }];
        
//        CALayer *separtor = [CALayer layer];
//        separtor.frame = CGRectMake(15, 79.5, SCREEN_WIDTH - 30, 0.5);
//        separtor.backgroundColor = [Tools garyLineColor].CGColor;
//        [self.layer addSublayer:separtor];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"PersonalDescCell", @"PersonalDescCell");
    
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
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
}

-(void)didPushInfo {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didPushInfo"];
    [cmd performWithResult:nil];
}

-(void)foundBtnClick {
    id<AYCommand> cmd = [self.notifies objectForKey:@"foundBtnClick"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
    
    NSDictionary *info = nil;
    CURRENUSER(info);
    NSString *user_id = [args objectForKey:@"user_id"];
    
    if (![user_id isEqualToString:[info objectForKey:@"user_id"]]) {
        NSString *nameStr = [args objectForKey:@"screen_name"];
        titleLabel.text = [NSString stringWithFormat:@"关于%@",nameStr];
    }
    
    NSString *descStr = [args objectForKey:@"personal_description"];
    if (descStr && ![descStr isEqualToString:@""]) {
        descLabel.text = descStr;
    }
    
    return nil;
}

@end