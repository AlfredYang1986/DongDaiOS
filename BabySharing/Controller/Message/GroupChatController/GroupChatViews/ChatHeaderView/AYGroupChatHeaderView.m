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
    UIImageView *photoCover;
    UILabel *titleLabel;
    UILabel *timeLabel;
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
    stateLabel = [Tools setLabelWith:stateLabel andText:@"咨询中" andTextColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:0];
    [self addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
    
    UIView *rule = [[UIView alloc]init];
    rule.backgroundColor = [Tools garyColor];
    [self addSubview:rule];
    [rule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(stateLabel.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    
    photoCover = [[UIImageView alloc]init];
    photoCover.image = IMGRESOURCE(@"sample_image");
    [self addSubview:photoCover];
    [photoCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(rule.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel = [Tools setLabelWith:titleLabel andText:@"服务简介标题" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoCover);
        make.left.equalTo(photoCover.mas_right).offset(15);
    }];
    
    timeLabel = [[UILabel alloc]init];
    timeLabel = [Tools setLabelWith:timeLabel andText:@"12月01日 10:00-12:00" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(photoCover);
        make.left.equalTo(titleLabel);
    }];
    
    UIImageView *iconNext = [[UIImageView alloc]init];
    iconNext.image = IMGRESOURCE(@"chan_group_back");
    [self addSubview:iconNext];
    [iconNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, SELFHEIGHT - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [self.layer addSublayer:line];
    
    UIView *tapView = [[UIView alloc]init];
    tapView.backgroundColor = [UIColor clearColor];
    [self addSubview:tapView];
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    tapView.userInteractionEnabled = YES;
    [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChatOrderDetailClick:)]];
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
//    NSDictionary* dic = (NSDictionary*)args;
//    
//    stateLabel.text = [dic objectForKey:@"order_state"];
//    photoCover.image = [dic objectForKey:@"nap_cover"];
//    
//    titleLabel.text = [dic objectForKey:@"nap_title"];
//    timeLabel.text = [dic objectForKey:@"nap_time"];
    
    return nil;
}

- (id)querGroupChatViewHeight {
    return [NSNumber numberWithFloat:[self preferredHeight]];
}

#pragma mark -- functions
- (void)didChatOrderDetailClick:(UIGestureRecognizer*)tap{
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
