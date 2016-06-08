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
    NSString *post_time;
    NSString *get_time;
    
    UILabel *didStarPlanTime;
    UILabel *chooceGetTime;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.frame = CGRectMake(20, 64 + 10, [UIScreen mainScreen].bounds.size.width - 2* 20, 70);
    
    CALayer *line_separator = [CALayer layer];
    line_separator.borderColor = [UIColor colorWithWhite:0.5922 alpha:1.f].CGColor;
    line_separator.borderWidth = 1.f;
    line_separator.frame = CGRectMake(WIDTH *0.5, 10, 1, 50);
    [self.layer addSublayer:line_separator];
    
    UIView *PostTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, WIDTH *0.5, 60)];
    [self addSubview:PostTimeView];
    
    CATextLayer *postTitle = [CATextLayer layer];
    postTitle.frame = CGRectMake(0, 10, WIDTH * 0.5, 20);
    postTitle.string = @"预计送娃时间";
    postTitle.fontSize = 14.f;
    postTitle.foregroundColor = [UIColor blackColor].CGColor;
    postTitle.alignmentMode = @"center";
    postTitle.contentsScale = 2.f;
    [PostTimeView.layer addSublayer:postTitle];
    
    didStarPlanTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, WIDTH * 0.5, 16)];
    didStarPlanTime.text = @"选择时间";
    didStarPlanTime.font = [UIFont systemFontOfSize:14.f];
    didStarPlanTime.textColor = [Tools themeColor];
    didStarPlanTime.textAlignment = NSTextAlignmentCenter;
    [PostTimeView addSubview:didStarPlanTime];
    didStarPlanTime.userInteractionEnabled = YES;
    [didStarPlanTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didStarPlanTime:)]];
    
    
    /* get */
    UIView *GetTimeView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH *0.5, 5, WIDTH *0.5, 60)];
    [self addSubview:GetTimeView];
    CATextLayer *getTitle = [CATextLayer layer];
    getTitle.frame = CGRectMake(0, 10, WIDTH * 0.5, 20);
    getTitle.string = @"预计接娃时间";
    getTitle.fontSize = 14.f;
    getTitle.foregroundColor = [UIColor blackColor].CGColor;
    getTitle.alignmentMode = @"center";
    getTitle.contentsScale = 2.f;
    [GetTimeView.layer addSublayer:getTitle];
    
    chooceGetTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, WIDTH * 0.5, 16)];
    chooceGetTime.text = @"——";
    chooceGetTime.font = [UIFont systemFontOfSize:14.f];
    chooceGetTime.textColor = [UIColor blackColor];
    chooceGetTime.textAlignment = NSTextAlignmentCenter;
    [GetTimeView addSubview:chooceGetTime];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

-(id)sendFiterArgs:(NSDictionary*)args{
    get_time = [NSString stringWithFormat:@"%@ %@",[args objectForKey:@"plan_date"],[args objectForKey:@"plan_time_get"]];
    post_time = [NSString stringWithFormat:@"%@ %@",[args objectForKey:@"plan_date"],[args objectForKey:@"plan_time_post"]];
    if (post_time && ![post_time isEqualToString:@""]) {
        didStarPlanTime.text = post_time;
    }
    if (get_time && ![get_time isEqualToString:@""]) {
        chooceGetTime.text = get_time;
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
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies

@end
