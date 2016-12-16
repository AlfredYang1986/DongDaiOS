//
//  AYServiceThemeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceThemeCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYPlayItemsView.h"

@implementation AYServiceThemeCellView {
    UILabel *themeLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CALayer *btm_seprtor = [CALayer layer];
        CGFloat margin = 0;
        btm_seprtor.frame = CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5);
        btm_seprtor.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:btm_seprtor];
        
        themeLabel = [Tools creatUILabelWithText:@"service topic" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:themeLabel];
        [themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
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

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServiceThemeCell", @"ServiceThemeCell");
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


#pragma mark -- notifies
- (id)setCellInfo:(id)args {
    
    NSDictionary *service_info = (NSDictionary*)args;
    
    // 看顾服务-日间看古
    // 课程-艺术-书法
    // service_cat  -->  cans_cat -->  cans
    
    NSString *catStr;
    NSArray *options_title_cans;
    NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
    NSNumber *cans_cat = [service_info objectForKey:kAYServiceArgsCourseCat];
    
    if (service_cat.intValue == ServiceTypeLookAfter) {
        catStr = @"看顾服务";
        options_title_cans = kAY_service_options_title_lookafter;
        //服务主题分类
        if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
            themeLabel.text = @"该服务主题待调整";
        } else {
            NSString *themeStr = options_title_cans[cans_cat.integerValue];
            themeLabel.text = [[catStr stringByAppendingString:@"-"] stringByAppendingString:themeStr];
        }
        
        
    }
    else if (service_cat.intValue == ServiceTypeCourse) {
        catStr = @"课程";
        options_title_cans = kAY_service_options_title_course;
        NSNumber *cans = [service_info objectForKey:kAYServiceArgsCourseSign];
        //服务主题分类
        if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
            themeLabel.text = @"该服务主题待调整";
        }
        else {
            NSString *themeStr = options_title_cans[cans_cat.integerValue];
            catStr = [[catStr stringByAppendingString:@"-"] stringByAppendingString:themeStr];
            
            NSString *costomStr = [service_info objectForKey:kAYServiceArgsCourseCoustom];
            if (costomStr && ![costomStr isEqualToString:@""]) {
                catStr = [[catStr stringByAppendingString:@"-"] stringByAppendingString:costomStr];
                themeLabel.text = catStr;
            } else {
                NSArray *courseTitleOfAll = kAY_service_course_title_ofall;
                NSArray *signTitleArr = [courseTitleOfAll objectAtIndex:cans_cat.integerValue];
                if (cans.integerValue < signTitleArr.count) {
                    catStr = [[catStr stringByAppendingString:@"-"] stringByAppendingString:[signTitleArr objectAtIndex:cans.integerValue]];
                    themeLabel.text = catStr;
                } else {
                    themeLabel.text = @"该服务主题待调整";
                }
            }
            
            
            
        }
    }
    
    
//    NSNumber *cans = (NSNumber*)args;
//    NSArray *options_title_cans = kAY_service_options_title_course;
//    
//    long options = cans.longValue;
//    for (int i = 0; i < options_title_cans.count; ++i) {
//        long note_pow = pow(2, i);
//        if ((options & note_pow)) {
//            themeLabel.text = [NSString stringWithFormat:@"%@",options_title_cans[i]];
//            break;
//        }
//    }
    
    return nil;
}

@end
