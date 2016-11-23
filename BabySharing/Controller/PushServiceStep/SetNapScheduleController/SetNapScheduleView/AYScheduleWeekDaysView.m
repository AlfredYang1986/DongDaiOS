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
    UIButton *noteBtn;
    UIImageView *currentSign;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
    NSArray *weekdays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
    for (int i = 0; i < weekdays.count; ++i) {
        UIButton *dayBtn = [Tools creatUIButtonWithTitle:weekdays[i] andTitleColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil];
        [dayBtn setTitleColor:[Tools whiteColor] forState:UIControlStateSelected];
//        [dayBtn setImage:IMGRESOURCE(@"date_seted_sign") forState:UIControlStateSelected];
//        dayBtn.backgroundColor = [UIColor colorWithPatternImage:IMGRESOURCE(@"date_today_sign")];
        dayBtn.tag = i;
        [dayBtn addTarget:self action:@selector(didDayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:dayBtn];
        [dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (i+1) - btnWH * 0.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
        }];
        
        if (i == 0) {
            dayBtn.selected = YES;
//            dayBtn.layer.contents = (id)IMGRESOURCE(@"date_seted_sign").CGImage;
            dayBtn.layer.backgroundColor = [Tools themeColor].CGColor;
            dayBtn.layer.cornerRadius = btnWH * 0.5;
            dayBtn.clipsToBounds = YES;
            noteBtn = dayBtn;
        }
    }
    
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

#pragma mark -- actions
- (void)didDayBtnClick:(UIButton*)btn {
    if (noteBtn == btn) {
        return;
    }
    
    btn.selected = YES;
//    btn.layer.contents = (id)IMGRESOURCE(@"date_seted_sign").CGImage;
    btn.layer.backgroundColor = [Tools themeColor].CGColor;
    btn.layer.cornerRadius = btnWH * 0.5;
    btn.clipsToBounds = YES;
    [btn setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
    
    //notifies
    NSNumber *index = [NSNumber numberWithInteger:btn.tag];
    kAYViewSendNotify(self, @"changeCurrentIndex:", &index)
    
    //此处index有返回值，NSNumber封装的BOOL类，
    
    if (noteBtn) {
        noteBtn.selected = NO;
        noteBtn.layer.backgroundColor = [Tools whiteColor].CGColor;
        if (index.boolValue) {
//            noteBtn.layer.contents = (id)IMGRESOURCE(@"date_today_sign").CGImage;
            noteBtn.layer.borderColor = [Tools themeColor].CGColor;
            noteBtn.layer.borderWidth = 1.f;
            noteBtn.layer.cornerRadius = btnWH * 0.5;
            noteBtn.clipsToBounds = YES;
            [noteBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        } else {
            noteBtn.layer.contents = nil;
//            noteBtn.layer.borderColor = [UIColor clearColor].CGColor;
            noteBtn.layer.borderWidth = 0.f;
            [noteBtn setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
        }
    }
    noteBtn = btn;
    
    [currentSign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (btn.tag + 1) - btnWH * 0.5);
        make.size.mas_equalTo(CGSizeMake(18, 7));
    }];
}

@end
