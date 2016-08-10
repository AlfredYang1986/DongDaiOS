//
//  AYNapBabyAgeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapBabyAgeCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "Tools.h"

@interface AYNapBabyAgeCellView ()
@property (weak, nonatomic) IBOutlet UILabel *unSetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *setedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation AYNapBabyAgeCellView {
    NSString *title;
    NSString *content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpReuseCell];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    _setedTitleLabel.hidden = YES;
//    _ageLabel.hidden = YES;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"NapBabyAgeCell", @"NapBabyAgeCell");
    
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
    _unSetTitleLabel.hidden = YES;
    _subTitleLabel.hidden = YES;
    
    _setedTitleLabel.hidden = NO;
    _ageLabel.hidden = NO;
//    _ageLabel.text = args;
    
    NSNumber *usl = ((NSNumber *)[args objectForKey:@"usl"]);
    NSNumber *lsl = ((NSNumber *)[args objectForKey:@"lsl"]);
    NSString *ages = [NSString stringWithFormat:@"%d  —  %d 岁",lsl.intValue,usl.intValue];
    _ageLabel.text = ages;
    
    return nil;
}
@end
