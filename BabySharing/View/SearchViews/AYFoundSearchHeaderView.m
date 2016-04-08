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
    id<AYViewBase> header = VIEW(@"FoundSearchHeader", @"FoundSearchHeader");
    self.commands = [[header commands] copy];
    self.notifies = [[header notifies] copy];
    
    for (AYViewCommand* cmd in self.commands.allValues) {
        cmd.view = self;
    }

    for (AYViewNotifyCommand* nty in self.notifies.allValues) {
        nty.view = self;
    }
    
    [self layoutSubviews];
    
    NSLog(@"reuser view with commands : %@", self.commands);
    NSLog(@"reuser view with notifications: %@", self.notifies);
}

+ (CGFloat)prefferredHeight {
    return 44;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (_headImg.image == nil) {
        _headLabell.frame = CGRectMake(14.5 + 14 + 10.5, _headLabell.frame.origin.y + 3, width - (14.5 + 14 + 10.5) * 2, _headLabell.frame.size.height + 7);
        _headLabell.font = [UIFont systemFontOfSize:14];
        _headLabell.center = CGPointMake(_headLabell.center.x, 44 / 2);
//        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2 - (CGRectGetWidth(self.frame) / 2 + 2 - (_headLabell.frame.size.width + 20) / 2), CGRectGetHeight(self.frame) / 2);
        //        _headLabell.textColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.0];
        _headLabell.textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0];
        _headLabell.textAlignment = NSTextAlignmentCenter;
    } else {
        _headImg.frame = CGRectMake(14.5, _headLabell.frame.origin.y, 14, 14);
        _headImg.center = CGPointMake(_headImg.center.x, 44 / 2);
        _headLabell.font = [UIFont systemFontOfSize:14];
        _headLabell.frame = CGRectMake(14.5 + 14 + 10.5, _headLabell.frame.origin.y, _headLabell.frame.size.width + 20, _headLabell.frame.size.height + 10);
        //        _headLabell.center = CGPointMake(_headLabell.center.x, 44 / 2);
        //        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 7);
        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2 - (CGRectGetWidth(self.frame) / 2 + 2 -(_headLabell.frame.size.width + 20) / 2), CGRectGetHeight(self.frame) / 2);
    }
    
    //    if (self.line == nil) {
    //        self.line = [[UIView alloc] init];
    //        self.line.backgroundColor = UpLineColor;
    //        [self addSubview:self.line];
    //    }
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 1);
    
    if (self.line1 == nil) {
        self.line1 = [[UIView alloc] init];
        self.line1.backgroundColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.10];
        [self addSubview:self.line1];
    }
    self.line1.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
}

#pragma mark -- message commands
- (id)changeHeaderTitle:(id)obj {
    NSString* title = (NSString*)obj;
    _headLabell.text = title;
    return nil;
}
@end
