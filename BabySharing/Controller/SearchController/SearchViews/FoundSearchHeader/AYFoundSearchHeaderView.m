//
//  AYFoundSearchHeaderView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundSearchHeaderView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"

@implementation AYFoundSearchHeaderView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize isLeftAlign = _isLeftAlign;
@synthesize headLabell = _headLabell;

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

#pragma mark -- life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    _headLabell.textColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.0];
    
//    id<AYViewBase> header = VIEW([self getViewName], [self getViewName]);
    id<AYViewBase> cell = VIEW(@"FoundSearchHeader", @"FoundSearchHeader");
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

+ (CGFloat)prefferredHeight {
    return 44;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _headLabell.font = [UIFont systemFontOfSize:14];
//    _headLabell.textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0];
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    if (_headImg.image == nil) {
//        _headLabell.font = [UIFont systemFontOfSize:14];
//        _headLabell.textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0];
//        
//    } else {
//        _headImg.frame = CGRectMake(14.5, _headLabell.frame.origin.y, 14, 14);
//        _headImg.center = CGPointMake(_headImg.center.x, 44 / 2);
//        _headLabell.font = [UIFont systemFontOfSize:14];
//        _headLabell.frame = CGRectMake(14.5 + 14 + 10.5, _headLabell.frame.origin.y, _headLabell.frame.size.width + 20, _headLabell.frame.size.height + 10);
//        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2 - (CGRectGetWidth(self.frame) / 2 + 2 -(_headLabell.frame.size.width + 20) / 2), CGRectGetHeight(self.frame) / 2);
//    }

}

#pragma mark -- message commands
- (id)changeHeaderTitle:(id)obj {
    NSString* title = (NSString*)obj;
    _headLabell.text = title;
    return nil;
}

- (id)queryHeaderHeight {
    return [NSNumber numberWithFloat:44.f];
}

- (id)isLeftAlignment:(id)obj {
    _isLeftAlign = ((NSNumber*)obj).boolValue;
    if (_isLeftAlign) {
        _headLabell.textAlignment = NSTextAlignmentLeft;
    } else {
        _headLabell.textAlignment = NSTextAlignmentCenter;
    }
    return obj;
}
@end
