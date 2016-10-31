//
//  AYOrderHeadCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderHeadCellView.h"
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

@implementation AYOrderHeadCellView {
    UILabel *orderNo_;
    UILabel *titleLabel;
    
    NSDictionary *service;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        
        orderNo_ = [[UILabel alloc]init];
        [self addSubview:orderNo_];
        orderNo_ = [Tools setLabelWith:orderNo_ andText:@"ASDASDASDASDASFDFS" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
        [orderNo_ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(15);
        }];
        
        titleLabel = [[UILabel alloc]init];
        [self addSubview:titleLabel];
        titleLabel = [Tools setLabelWith:titleLabel andText:@"服务标题" andTextColor:[Tools blackColor] andFontSize:20.f andBackgroundColor:nil andTextAlignment:0];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderNo_.mas_bottom).offset(20);
            make.left.equalTo(orderNo_);
            make.right.lessThanOrEqualTo(self).offset(-80);
        }];
        
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = IMGRESOURCE(@"chan_group_back");
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(titleLabel);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didServiceDetailClick:)]];
        
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
    id<AYViewBase> cell = VIEW(@"OrderHeadCell", @"OrderHeadCell");
    
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

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args{
    NSDictionary *args = [dic_args objectForKey:@"service"];
    
    titleLabel.text = [args objectForKey:@"title"];
    
    return nil;
}

@end
