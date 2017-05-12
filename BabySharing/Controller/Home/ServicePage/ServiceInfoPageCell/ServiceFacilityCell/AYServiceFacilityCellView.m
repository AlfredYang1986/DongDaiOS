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
    UIButton *facalityBtn;
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
        
        facalityBtn = [Tools creatUIButtonWithTitle:nil andTitleColor:[Tools themeColor] andFontSize:20.f andBackgroundColor:nil];
        [facalityBtn addTarget:self action:@selector(didFacalityBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:facalityBtn];
        [facalityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.clipsToBounds = YES;
        
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
    
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[AYPlayItemsView class]]) {
            [sub removeFromSuperview];
        }
    }
    
    NSNumber *facility = (NSNumber*)args;
    NSArray *options_title_facility = kAY_service_options_title_facilities;
    
    long options = facility.longValue;
    CGFloat offsetX = 15;
    int noteCount = 0;
    int limitNumb =0;
    if (SCREEN_WIDTH < 375) {
        limitNumb = 3;
    } else
        limitNumb = 4;
    
    for (int i = 0; i < options_title_facility.count; ++i) {
        
        long note_pow = pow(2, i);
        if ((options & note_pow)) {
            
            if (noteCount < limitNumb) {
                
                NSString *imageName = [NSString stringWithFormat:@"facility_%d",i];
                AYPlayItemsView *item = [[AYPlayItemsView alloc]initWithTitle:options_title_facility[i] andIconName:imageName];
                [self addSubview:item];
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self).offset(offsetX);
                    make.centerY.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(50, 55));
                }];
                offsetX += 80;
            }
            
            noteCount ++;
        }
    }
    
    [facalityBtn setTitle:[NSString stringWithFormat:@"+%d",noteCount] forState:UIControlStateNormal];
    return nil;
}

@end
