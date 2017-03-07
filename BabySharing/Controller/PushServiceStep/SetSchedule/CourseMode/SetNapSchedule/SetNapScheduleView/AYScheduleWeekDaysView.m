//
//  AYScheduleWeekDaysView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYScheduleWeekDaysView.h"
#define btnSpaceW               (SCREEN_WIDTH - 20) / 7
#define btnWH                       30
@implementation AYScheduleWeekDaysView {
    AYWeekDayBtn *noteBtn;
    UIImageView *currentSign;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
    currentSign = [[UIImageView alloc]init];
    currentSign.image = IMGRESOURCE(@"triangle");
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
    [currentSign setTransform:rotate];
    
    [self addSubview:currentSign];
    [currentSign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_left).offset(btnSpaceW - btnWH * 0.5);
        make.size.mas_equalTo(CGSizeMake(18, 7));
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

#pragma mark -- notifies
- (id)setViewInfo:(NSArray*)args {
    
    NSMutableArray *tmp = [NSMutableArray array];
    [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmp addObject:[obj objectForKey:@"day"]];
    }];
    
    NSArray *weekdays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
    for (int i = 0; i < weekdays.count; ++i) {
        AYWeekDayBtn *dayBtn = [[AYWeekDayBtn alloc] initWithTitle:weekdays[i]];
        dayBtn.tag = i;
        dayBtn.states = WeekDayBtnStateNormal;
        [dayBtn addTarget:self action:@selector(didDayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dayBtn];
        [dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (i+1) - btnWH * 0.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
        }];
        
        if([tmp containsObject:[NSNumber numberWithInt:i]]) {
            dayBtn.states = WeekDayBtnStateSeted;
        }
        
        if (i == 0) {
            dayBtn.states = WeekDayBtnStateSelected;
            noteBtn = dayBtn;
        }
        
    }
    return nil;
}

#pragma mark -- actions
- (void)didDayBtnClick:(AYWeekDayBtn*)btn {
    if (noteBtn == btn) {
        return;
    }
    
    //notifies
    NSNumber *index = [NSNumber numberWithInteger:btn.tag];
    kAYViewSendNotify(self, @"changeCurrentIndex:", &index)
    //此处index返回值是有意义的：是否有值（是否切换）／NSNumber封装int(0/2)（是否已设置标志）
    
    if(!index) {
        return;
    }
    
    btn.states = WeekDayBtnStateSelected;
    noteBtn.states = index.intValue;
    noteBtn = btn;
    
    [currentSign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (btn.tag + 1) - btnWH * 0.5);
        make.size.mas_equalTo(CGSizeMake(18, 7));
    }];
}

@end
