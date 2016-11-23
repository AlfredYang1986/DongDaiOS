//
//  AYServiceTimesCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceTimesCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYServiceTimesCellView {

    UILabel *titleLabel;
    UILabel *subTitlelabel;
    UIButton *optionBtn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        titleLabel = [Tools creatUILabelWithText:@"00:00 - 00:00" andTextColor:[Tools blackColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        CALayer *separator = [CALayer layer];
        CGFloat margin = 0;
        separator.frame = CGRectMake(margin, 89.5, [UIScreen mainScreen].bounds.size.width - margin*2, 0.5);
        separator.backgroundColor = [Tools whiteColor].CGColor;
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

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServiceTimesCell", @"ServiceTimesCell");
    
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
    
    NSNumber *startNumb = [args objectForKey:@"start"];
    NSString *startStr = [NSString stringWithFormat:@"%.4d",startNumb.intValue];
    
    NSNumber *endNumb = [args objectForKey:@"end"];
    NSString *endStr = [NSString stringWithFormat:@"%.4d",endNumb.intValue];
    
    startStr = [[[startStr substringToIndex:2] stringByAppendingString:@":"] stringByAppendingString:[startStr substringFromIndex:2]];
    endStr = [[[endStr substringToIndex:2] stringByAppendingString:@":"] stringByAppendingString:[endStr substringFromIndex:2]];
    
    if (startStr && endStr) {
        titleLabel.text = [NSString stringWithFormat:@"%@-%@",startStr, endStr];
    }
    
    return nil;
}

@end
