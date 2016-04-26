//
//  AYFoundNickCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFoundNickCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "FoundHotTagBtn.h"
#import "Tools.h"

@implementation AYFoundNickCellView
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
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)setUpReuseCell {
    //    id<AYViewBase> header = VIEW([self getViewName], [self getViewName]);
    id<AYViewBase> cell = VIEW(@"FoundHotTagsCell", @"FoundHotTagsCell");
    
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

+ (CGFloat)preferredHeight {
    return 70;
}

- (id)setHotTagsText:(id)obj{
    NSArray* arr = (NSArray*)obj;
    
    [self clearAllTags];
    
    return nil;
}

- (void)setHotTagsTest:(NSArray*)arr {
    
    [self clearAllTags];
    
}

- (void)clearAllTags {
    while (self.subviews.count > 0) {
        [self.subviews.firstObject removeFromSuperview];
    }
    
    [self addButtomLine];
}

- (void)tagBtnSelected:(UITapGestureRecognizer*)tap {
    //    FoundHotTagBtn* tmp = (FoundHotTagBtn*)tap.view;
    //    [_delegate recommandTagBtnSelected:tmp.tag_name adnType:tmp.tag_type];
}

- (void)roleTagBtnSelected:(UITapGestureRecognizer*)tap {
    //    FoundHotTagBtn* tmp = (FoundHotTagBtn*)tap.view;
    //    [_delegate recommandRoleTagBtnSelected:tmp.tag_name];
}

- (void)addButtomLine{
    
    CALayer *lineup = [CALayer layer];
    lineup.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    lineup.borderWidth = 1.f;
    lineup.frame = CGRectMake(0, 61 - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [self.layer addSublayer:lineup];
    
}

- (id)queryCellHeight {
    return [NSNumber numberWithFloat:70];
}
@end
