//
//  AYServiceThemeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceCapacityCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYPlayItemsView.h"

@implementation AYServiceCapacityCellView {
	
	UILabel *filtBabyArgsLabel;
	UILabel *capacityLabel;
	UILabel *servantLabel;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
//        capacity_icon
		UILabel *capacitySignLabel = [Tools creatUILabelWithText:@"Children" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:capacitySignLabel];
		[capacitySignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self).offset(-23);
			make.top.equalTo(self).offset(58);
		}];
		
		capacityLabel = [Tools creatUILabelWithText:@"0" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:capacityLabel];
		[capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(capacitySignLabel);
			make.bottom.equalTo(capacitySignLabel.mas_top).offset(-13);
		}];

//        age_boundary_icon
		UILabel *filtBabySignLabel = [Tools creatUILabelWithText:@"Children" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:filtBabySignLabel];
		[filtBabySignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(capacitySignLabel).offset(-SCREEN_WIDTH/3);
			make.bottom.equalTo(capacitySignLabel);
		}];
		
		filtBabyArgsLabel = [Tools creatUILabelWithText:@"0-0 years old" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:filtBabyArgsLabel];
		[filtBabyArgsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(filtBabySignLabel);
			make.centerY.equalTo(capacityLabel);
		}];

//        allow_leave_icon
		UILabel *servantSignLabel = [Tools creatUILabelWithText:@"Children" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:servantSignLabel];
		[servantSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(capacitySignLabel).offset(SCREEN_WIDTH/3);
			make.bottom.equalTo(capacitySignLabel);
		}];
		servantLabel = [Tools creatUILabelWithText:@"Numb of servant" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:servantLabel];
		[servantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(servantSignLabel);
			make.centerY.equalTo(capacityLabel);
		}];
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServiceCapacityCell", @"ServiceCapacityCell");
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
