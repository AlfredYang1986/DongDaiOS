//
//  MessageChatGroupHeader3.m
//  BabySharing
//
//  Created by Alfred Yang on 3/11/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "AYSingleChatHeadView.h"
#import "AYCommandDefines.h"
#import "Tools.h"

#define LABEL_MARGIN_TOP    40 //64
#define LABEL_HEIGHT        32

#define PADDING_HER         10.5
#define PADDING_VER         9

#define MARGIN_HER          2 * PADDING_HER
#define SELFHEIGHT          60


@implementation AYSingleChatHeadView {
    NSArray* tag_views;
    UILabel* theme_label;
    
    UILabel *stateLabel;
    UIButton *MoreBtn;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
    self.clipsToBounds = YES;
    
    stateLabel = [Tools creatUILabelWithText:@"咨询中" andTextColor:[Tools garyColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
    [self addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
    
    MoreBtn = [Tools creatUIButtonWithTitle:@"详情" andTitleColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil];
    [self addSubview:MoreBtn];
    [MoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(stateLabel);
        make.size.mas_equalTo(CGSizeMake(36, 50));
    }];
    [MoreBtn addTarget:self action:@selector(didChatOrderDetailClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [Tools garyLineColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,0.5));
    }];
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

#pragma mark -- messages
- (id)setGroupChatViewInfo:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    
    OrderStatus OrderStatus = ((NSNumber*)[dic objectForKey:@"order_state"]).intValue;
    switch (OrderStatus) {
        case OrderStatusReady:
            stateLabel.text = @"待确认";
            break;
        case OrderStatusConfirm:
            stateLabel.text = @"已确认";
            break;
        case OrderStatusPaid:
            stateLabel.text = @"待确认";
            break;
        case OrderStatusDone:
            stateLabel.text = @"已完成";
            break;
        case OrderStatusReject:
            stateLabel.text = @"已拒绝";
            break;
        default:
            stateLabel.text = @"咨询中";
            break;
    }
    
    return nil;
}

#pragma mark -- functions
- (void)didChatOrderDetailClick {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didChatOrderDetailClick"];
    [cmd performWithResult:nil];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
