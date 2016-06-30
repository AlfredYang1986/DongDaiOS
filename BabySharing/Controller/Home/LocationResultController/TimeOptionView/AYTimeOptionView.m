//
//  AYTimeOptionView.m
//  BabySharing
//
//  Created by Alfred Yang on 7/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYTimeOptionView.h"
#import "AYCommandDefines.h"
#import "Tools.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"

#define WIDTH  self.frame.size.width
#define HEIGHT self.frame.size.height
#define MARGIN 10.f

@implementation AYTimeOptionView {
    NSString *dayDate;
    NSString *post_time;
    NSString *get_time;
    
    UILabel *didStarPlanTime;
    UILabel *dateLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2* 15, 75);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.25;
    self.layer.shadowRadius = 2;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.userInteractionEnabled  = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didStarPlanTime:)]];
    
    dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont systemFontOfSize:14.f];
    dateLabel.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1];
    [self addSubview:dateLabel];
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日,  EEEE"];
    NSString *today = [formatter stringFromDate:todayDate];
    dateLabel.text = today;
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.left.equalTo(self).offset(15);
    }];
    
    didStarPlanTime = [[UILabel alloc]init];
    didStarPlanTime.text = @"选择时间";
    didStarPlanTime.font = [UIFont systemFontOfSize:24.f];
    didStarPlanTime.textColor = [Tools themeColor];
    didStarPlanTime.textAlignment = NSTextAlignmentCenter;
    [self addSubview:didStarPlanTime];
    [didStarPlanTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(8);
        make.left.equalTo(dateLabel);
    }];
    //plan_time_icon
    
    UIImageView *planTimeIcon = [[UIImageView alloc]init];
    planTimeIcon.image = IMGRESOURCE(@"plan_time_icon");
    [self addSubview:planTimeIcon];
    [planTimeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(didStarPlanTime);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

-(id)sendFiterArgs:(NSDictionary*)args{
    
    NSNumber *startNumb = [args objectForKey:@"plan_time_post"];
    NSTimeInterval start = startNumb.doubleValue;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
    NSDateFormatter *formatterDay = [[NSDateFormatter alloc]init];
    [formatterDay setDateFormat:@"yyyy年MM月dd日,  EEEE"];
    dayDate = [formatterDay stringFromDate:startDate];
    if (dayDate && ![dayDate isEqualToString:@""]) {
        dateLabel.text = dayDate;
    }
    
    
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc]init];
    [formatterTime setDateFormat:@"HH:mm"];
    post_time = [formatterTime stringFromDate:startDate];
    
    NSNumber *endNumb = [args objectForKey:@"plan_time_get"];
    NSTimeInterval end = endNumb.doubleValue;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
    get_time = [formatterTime stringFromDate:endDate];
    if (post_time && ![post_time isEqualToString:@""]) {
        didStarPlanTime.text = [NSString stringWithFormat:@"%@ - %@",post_time,get_time];
    }
    return nil;
}

#pragma mark -- commands
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
- (void)didStarPlanTime:(UIGestureRecognizer*)tap{
    AYViewController* des = DEFAULTCONTROLLER(@"Fiter");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:dateLabel.text forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
-(id)queryDateSetAlready{
    
    return dateLabel.text;
}

@end
