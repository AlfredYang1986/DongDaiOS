//
//  PhotoTagEditView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/22/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "AYTagEditView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYPhotoTagView.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFactoryManager.h"

#import "AYPhotoTagView.h"

@implementation AYTagEditView

#define EDIT_VIEW_WIDTH         94
#define EDIT_VIEW_HEIGHT        45

//@synthesize delegate = _delegate;
@synthesize tag_type = _tag_type;
@synthesize effect_view = _effect_view;

- (void)setUpView {
    
    [self setBackgroundImage:PNGRESOURCE(@"post_edit_tag_bg") forState:UIControlStateNormal];
    self.bounds = CGRectMake(0, 0, EDIT_VIEW_WIDTH, EDIT_VIEW_HEIGHT);
    
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, EDIT_VIEW_WIDTH / 2 , EDIT_VIEW_HEIGHT)];
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn];
    
    UIButton* delBtn = [[UIButton alloc]initWithFrame:CGRectMake(EDIT_VIEW_WIDTH / 2, 0, EDIT_VIEW_WIDTH / 2, EDIT_VIEW_HEIGHT)];
    delBtn.backgroundColor = [UIColor clearColor];
    [delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
}

- (void)editBtnClick {
    id<AYCommand> cmd = [self.notifies objectForKey:@"EditBtnSelected:"];
    AYPhotoTagView* tmp = self.effect_view;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSNumber numberWithInteger:tmp.type] forKey:@"tag_type"];
    [dic setValue:tmp.content forKey:@"tag_name"];
    [cmd performWithResult:&dic];
}

- (void)delBtnClick {
    [self.effect_view removeFromSuperview];
    [self removeFromSuperview];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    [self setUpView];
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
- (void)setUpReuseCommands {
    id<AYViewBase> cell = VIEW(@"TagEdit", @"TagEdit");
    
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
@end
