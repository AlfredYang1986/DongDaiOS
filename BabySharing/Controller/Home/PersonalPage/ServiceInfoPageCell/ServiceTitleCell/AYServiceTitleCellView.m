//
//  AYServiceTitleCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceTitleCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYServiceTitleCellView {
    UILabel *titleLabel;
    UIImageView *pointsImageView;
    
    UILabel *filtBabyArgsLabel;
    UILabel *capacityLabel;
    
    UIImageView *allowLeaveSign;
    UILabel *allowLeave;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLabel = [Tools creatUILabelWithText:@"Service title is not set" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(15);
        }];
        
        pointsImageView = [UIImageView new];
        pointsImageView.image = IMGRESOURCE(@"star_rang_0");
        [pointsImageView sizeToFit];
        [self addSubview:pointsImageView];
        [pointsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(pointsImageView.bounds.size);
        }];
        
//        capacity_icon
        UIImageView *signCapacity = [[UIImageView alloc]init];
        signCapacity.image = IMGRESOURCE(@"capacity_icon");
        [self addSubview:signCapacity];
        [signCapacity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-45);
            make.size.mas_equalTo(CGSizeMake(27, 27));
        }];
        
        capacityLabel = [Tools creatUILabelWithText:@"0 Children" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:capacityLabel];
        [capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signCapacity);
            make.top.equalTo(signCapacity.mas_bottom).offset(10);
        }];
        
        //        age_boundary_icon
        UIImageView *signBabyAges = [[UIImageView alloc]init];
        signBabyAges.image = IMGRESOURCE(@"age_boundary_icon");
        [self addSubview:signBabyAges];
        [signBabyAges mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signCapacity).offset(-SCREEN_WIDTH * 0.3f);
            make.centerY.equalTo(signCapacity);
            make.size.equalTo(signCapacity);
        }];
        
        filtBabyArgsLabel = [Tools creatUILabelWithText:@"0-0 years old" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:filtBabyArgsLabel];
        [filtBabyArgsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signBabyAges);
            make.centerY.equalTo(capacityLabel);
        }];
        
        //        allow_leave_icon
        allowLeaveSign = [[UIImageView alloc]init];
        allowLeaveSign.image = IMGRESOURCE(@"allow_leave_icon");
        [self addSubview:allowLeaveSign];
        [allowLeaveSign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signCapacity).offset(SCREEN_WIDTH * 0.3f);
            make.centerY.equalTo(signCapacity);
            make.size.equalTo(signCapacity);
        }];
        
        allowLeave = [Tools creatUILabelWithText:@"需要家长陪伴" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:allowLeave];
        [allowLeave mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(allowLeaveSign);
            make.centerY.equalTo(capacityLabel);
        }];
        
        CALayer *btm_seprtor = [CALayer layer];
        CGFloat margin = 0;
        btm_seprtor.frame = CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5);
        btm_seprtor.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:btm_seprtor];
        
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
    id<AYViewBase> cell = VIEW(@"ServiceTitleCell", @"ServiceTitleCell");
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
    
    NSString *titleStr = [service_info objectForKey:@"title"];
    if (titleStr) {
        titleLabel.text = titleStr;
    }
    
    //重置cell复用数据
    //    _starRangImage.hidden = NO;
    NSArray *points = [service_info objectForKey:@"points"];
    if (points.count == 0) {
            pointsImageView.hidden = YES;
//            pointsImageView.image = IMGRESOURCE(@"star_rang_0");
    } else {
        CGFloat sumPoint  = 0;
        for (NSNumber *point in points) {
            sumPoint += point.floatValue;
        }
        CGFloat average = sumPoint / points.count;
        
        int mainRang = (int)average;
        NSString *rangImageName = [NSString stringWithFormat:@"star_rang_%d",mainRang];
        CGFloat tmpCompare = average + 0.5f;
        if ((int)tmpCompare > mainRang) {
            rangImageName = [rangImageName stringByAppendingString:@"_"];
        }
        pointsImageView.image = IMGRESOURCE(rangImageName);
    }
    
    NSDictionary *age_boundary = [service_info objectForKey:@"age_boundary"];
    NSNumber *usl = ((NSNumber *)[age_boundary objectForKey:@"usl"]);
    NSNumber *lsl = ((NSNumber *)[age_boundary objectForKey:@"lsl"]);
    NSString *ages = [NSString stringWithFormat:@"%d-%d岁",lsl.intValue,usl.intValue];
    filtBabyArgsLabel.text = [NSString stringWithFormat:@"%@",ages];
    
    NSNumber *capacity = [service_info objectForKey:@"capacity"];
    capacityLabel.text = [NSString stringWithFormat:@"%d个孩子",capacity.intValue];
    
    NSNumber *allow = [service_info objectForKey:@"allow_leave"];
    BOOL isAllow = allow.boolValue;
    allowLeaveSign.hidden = allowLeave.hidden = !isAllow;
    
    return nil;
}

@end
