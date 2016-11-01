//
//  MessageChatGroupHeader3.m
//  BabySharing
//
//  Created by Alfred Yang on 3/11/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "AYGroupChatHeaderView.h"
#import "AYCommandDefines.h"
#import "Tools.h"

#define LABEL_MARGIN_TOP    40 //64
#define LABEL_HEIGHT        32

#define PADDING_HER         10.5
#define PADDING_VER         9

#define MARGIN_HER          2 * PADDING_HER
#define SELFHEIGHT          60


@implementation AYGroupChatHeaderView {
    NSArray* tag_views;
    UILabel* theme_label;
    
    UILabel *stateLabel;
    UIButton *MoreBtn;
    
//    UIImageView *photoCover;
//    UILabel *titleLabel;
//    UILabel *timeLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize theme_label_text = _theme_label_text;
@synthesize theme_tags = _theme_tags;

#pragma mark -- commands
- (void)postPerform {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SELFHEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    stateLabel = [[UILabel alloc]init];
    stateLabel = [Tools setLabelWith:stateLabel andText:@"咨询中" andTextColor:[Tools garyColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
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
            stateLabel.text = @"待确认订单";
            break;
        case OrderStatusConfirm:
            stateLabel.text = @"已确认订单";
            break;
        case OrderStatusPaid:
            stateLabel.text = @"待确认订单";
            break;
        case OrderStatusDone:
            stateLabel.text = @"已完成订单";
            break;
        case OrderStatusUnpaid:
            stateLabel.text = @"未支付订单";
            break;
        case OrderStatusReject:
            stateLabel.text = @"已拒绝订单";
            break;
        default:
            stateLabel.text = @"异次元订单";
            break;
    }
    
    return nil;
}

- (id)querGroupChatViewHeight {
    return [NSNumber numberWithFloat:[self preferredHeight]];
}

#pragma mark -- functions
- (void)didChatOrderDetailClick {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didChatOrderDetailClick"];
    [cmd performWithResult:nil];
    
}

- (void)resizeLabel:(UILabel*)label {
    [label sizeToFit];
    CGSize sz = label.bounds.size;
    
//    label.bounds = CGRectMake(0, 0, sz.width + 2 * PADDING_HER, sz.height + 2 * PADDING_VER);
    label.bounds = CGRectMake(0, 0, sz.width + 2 * PADDING_HER, LABEL_HEIGHT);
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)setThemeTags:(NSArray *)theme_tags {
    _theme_tags = theme_tags;
    
    for (UILabel* iter in tag_views) {
        [iter removeFromSuperview];
    }
    
    NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:theme_tags.count];
    for (NSString* str in theme_tags) {
        UILabel* tmp = [[UILabel alloc]init];
        tmp.backgroundColor = [UIColor whiteColor];
        tmp.layer.cornerRadius = 4.f;
        tmp.clipsToBounds = YES;
        tmp.text = [@"#" stringByAppendingString:str];
//        [tmp sizeToFit];
        [self resizeLabel:tmp];
        [self addSubview:tmp];
        [arr addObject:tmp];
    }
    
    tag_views = [arr copy];
}

- (void)setThemeLabelText:(NSString *)theme_label_text {
    _theme_label_text = theme_label_text;
   
    if (theme_label == nil) {
        theme_label = [[UILabel alloc]init];
        theme_label.backgroundColor = [UIColor whiteColor];
        theme_label.layer.cornerRadius = 4.f;
        theme_label.clipsToBounds = YES;
        [self addSubview:theme_label];
    }
    
    theme_label.text = _theme_label_text;
//    [theme_label sizeToFit];
    [self resizeLabel:theme_label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (CGFloat)preferredHeight {
    CGFloat w = 0;
    for (UILabel* iter in tag_views) {
        w += iter.bounds.size.width;
    }
    return LABEL_MARGIN_TOP + LABEL_HEIGHT + LABEL_HEIGHT * (w == 0 ? 0 : w / ([UIScreen mainScreen].bounds.size.width - 42) + 1);
}

@end
