//
//  AYSetServiceThemeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceThemeCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYSetServiceThemeCellView {
    NSString *title;
    NSString *content;
    
    UILabel *titleLabel;
    UILabel *subTitlelabel;
    UIButton *optionBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        UIImageView *access = [[UIImageView alloc]init];
        [self addSubview:access];
        access.image = IMGRESOURCE(@"plan_time_icon");
        [access mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(titleLabel);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        CALayer *separator = [CALayer layer];
        CGFloat margin = 0;
        separator.frame = CGRectMake(margin, 69.5, [UIScreen mainScreen].bounds.size.width - margin*2, 0.5);
        separator.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:separator];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"SetServiceThemeCell", @"SetServiceThemeCell");
    
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

- (id)setCellInfo:(NSDictionary*)args {
    
    titleLabel.text = [args objectForKey:@"title"];
    
    return nil;
}

@end
