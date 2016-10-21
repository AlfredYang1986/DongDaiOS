//
//  AYOneProfileContentCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 16/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOneProfileContentCellView.h"
#import "Notifications.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@interface AYOneProfileContentCellView ()

@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AYOneProfileContentCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _userPhotoImage.layer.cornerRadius = 30.f;
    _userPhotoImage.clipsToBounds = YES;
    _userPhotoImage.layer.borderColor = [UIColor colorWithWhite:0.25 alpha:1.f].CGColor;
    _userPhotoImage.layer.borderWidth = 2.f;
    
    // Initialization code
    [self setUpReuseCell];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OneProfileContentCell", @"OneProfileContentCell");
    
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
- (IBAction)didAllContentBtnClick:(id)sender {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didAllContent"];
    [cmd performWithResult:nil];
}


- (id)setCellInfo:(NSString*)args{
    
    
    return nil;
}
@end
