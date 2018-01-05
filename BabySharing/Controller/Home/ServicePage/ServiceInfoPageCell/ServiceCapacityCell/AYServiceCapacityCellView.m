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
	
	AYCapacityUnitView *classView;
	AYCapacityUnitView *ageView;
	AYCapacityUnitView *teacherView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
//        capacity_icon
		classView = [[AYCapacityUnitView alloc] initWithIcon:@"details_icon_classmax" title:@"班级人数" info:@"0"];
		[self addSubview:classView];
		[classView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self).offset(30);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 80));
		}];

//        age_boundary_icon
		ageView = [[AYCapacityUnitView alloc] initWithIcon:@"details_icon_ages" title:@"适合年龄" info:@"0"];
		[self addSubview:ageView];
		[ageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self);
			make.top.equalTo(classView);
			make.size.equalTo(classView);
		}];
		

//        allow_leave_icon
		teacherView = [[AYCapacityUnitView alloc] initWithIcon:@"details_icon_teacher" title:@"师生配比" info:@"0"];
		[self addSubview:teacherView];
		[teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self);
			make.top.equalTo(classView);
			make.size.equalTo(classView);
		}];
		
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(classView.mas_bottom).offset(30);
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
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
	
	[classView info:args atIndex:1];
    [ageView info:args atIndex:0];
	[teacherView info:args atIndex:2];
    return nil;
}

@end
