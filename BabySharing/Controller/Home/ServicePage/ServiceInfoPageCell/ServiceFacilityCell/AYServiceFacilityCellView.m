//
//  AYServiceFacilityCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceFacilityCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYPlayItemsView.h"

@implementation AYServiceFacilityCellView {
	
	NSMutableArray *facilityArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		UILabel *titleLabel = [Tools creatUILabelWithText:@"友好性设施" andTextColor:[Tools lightGaryColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30);
			make.bottom.equalTo(self).offset(-250);
		}];
		
		CGFloat margin = 20.f;
		CGFloat itemHeight = 80.f;
		CGFloat itemWidth = 70.f;
		CGFloat lineSpacing = 30.f;
		CGFloat InteritemSpacing = (SCREEN_WIDTH - margin*2 - itemWidth*4)/3;
		
		facilityArr = [NSMutableArray array];
		NSArray *facilityTitlesArr = kAY_service_options_title_facilities;
		for (int i = 0; i < 8; ++i) {
			AYPlayItemsView *facilityItem = [[AYPlayItemsView alloc] initWithTitle:[facilityTitlesArr objectAtIndex:i] andIconName:[NSString stringWithFormat:@"details_icon_facility_%d", i]];
			[self addSubview:facilityItem];
			[facilityItem mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(titleLabel.mas_bottom).offset(i/4 * (itemHeight+lineSpacing) + lineSpacing);
				make.left.equalTo(self).offset(i%4 * (InteritemSpacing+itemWidth) + margin);
				make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
			}];
			
			[facilityArr addObject:facilityItem];
		}
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [Tools garyBackgroundColor];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
		}];
		
		UIView *shadow_view = [[UIView alloc]init];
		shadow_view.backgroundColor = [Tools whiteColor];
		shadow_view.layer.shadowColor = [Tools garyColor].CGColor;
		shadow_view.layer.shadowOffset = CGSizeMake(0, 2.f);
		shadow_view.layer.shadowOpacity = 0.05f;
		shadow_view.layer.shadowRadius =1.f;
		[self addSubview:shadow_view];
		[shadow_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self).offset(-10);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
		}];
		
		[self sendSubviewToBack:shadow_view];
		[self sendSubviewToBack:bottom_view];
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServiceFacilityCell", @"ServiceFacilityCell");
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
- (void)didFacalityBtnClick {
    kAYViewSendNotify(self, @"showCansOrFacility", nil)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	NSDictionary *service_info = args;
	
    NSNumber *facility = [service_info objectForKey:kAYServiceArgsFacility];
	long options = facility.longValue;

	NSArray *options_title_facility = kAY_service_options_title_facilities;		//仅用于取数组数量
    for (int i = 0; i < options_title_facility.count; ++i) {
        long note_pow = pow(2, i);
		AYPlayItemsView *item = [facilityArr objectAtIndex:i];
		[item setEnableStatusWith:options & note_pow];
			
    }
	
    return nil;
}

@end
