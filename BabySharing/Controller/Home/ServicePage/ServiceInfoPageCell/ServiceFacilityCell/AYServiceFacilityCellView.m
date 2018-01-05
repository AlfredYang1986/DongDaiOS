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
	UIScrollView *ScrollView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *titleLabel = [UILabel creatLabelWithText:@"场地安全友好性" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30);
			make.bottom.equalTo(self).offset(-100);
		}];
		
		ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 80)];
		ScrollView.showsVerticalScrollIndicator = NO;
		ScrollView.showsHorizontalScrollIndicator = NO;
		[self addSubview:ScrollView];
		
		UIImageView *mask = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"mask_detail_facility")];
		[self addSubview:mask];
		[mask mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(ScrollView);
			make.centerY.equalTo(ScrollView);
			make.size.mas_equalTo(CGSizeMake(20, 76));
		}];
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			//			make.top.equalTo(userPhoto.mas_bottom).offset(30);
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
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
	
	NSArray *facilities = [[service_info objectForKey:kAYServiceArgsLocationInfo] objectForKey:@"friendliness"];;
	
	CGFloat itemHeight = 64;
	CGFloat lineSpacing = 25;
	CGFloat preMaxX = 0;
	
	for (int i = 0; i < facilities.count; ++i) {
		
		NSString *title = [facilities objectAtIndex:i];
		AYPlayItemsView *facilityItem = [[AYPlayItemsView alloc] initWithTitle:title andIconName:[NSString stringWithFormat:@"details_icon_facility_%d", i]];
		[ScrollView addSubview:facilityItem];
		CGSize labelSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
		facilityItem.frame = CGRectMake(SCREEN_MARGIN_LR + i==0? 0 : lineSpacing + preMaxX, 8, labelSize.width, itemHeight);
		
		preMaxX = facilityItem.frame.origin.x + labelSize.width;
	}
	ScrollView.contentSize = CGSizeMake(preMaxX+25, 80);
	
    return nil;
}

@end
