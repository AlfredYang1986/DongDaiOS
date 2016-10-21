//
//  AYSearchFilterCellView.m
//  BabySharing
//
//  Created by BM on 9/1/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterCellView.h"
#import "Notifications.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYSearchFilterCellDefines.h"

#define LINE_MARGIN                         15.f


#define SEARCH_FILTER_CELL_HEIGHT           90.f

#define TITLE_TEXT_COLOR                    [UIColor redColor]

@interface AYSearchFilterCellView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addSign;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@end

@implementation AYSearchFilterCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpReuseCell];
    
    _addSign.textColor = [Tools themeColor];
    CALayer* line = [CALayer layer];
    line.frame = CGRectMake(LINE_MARGIN, SEARCH_FILTER_CELL_HEIGHT - 0.5, SCREEN_WIDTH - 2 * LINE_MARGIN, 0.5);
    line.borderColor = [Tools garyLineColor].CGColor;
    line.borderWidth = 1.f;
    [self.layer addSublayer:line];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYSearchFilterCellName, kAYSearchFilterCellName);
    
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

- (id)setCellInfo:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
    AYSearchFilterCellView* cell = [dic objectForKey:kAYSearchFilterCellCellKey];
    NSString* title = [dic objectForKey:kAYSearchFilterCellTitleKey];
    cell.titleLabel.text = title;
    cell.titleLabel.textColor = [Tools blackColor];
    [cell.titleLabel sizeToFit];
    
    NSString *sub_title = [dic objectForKey:kAYSearchFilterCellSubTitleKey];
    cell.addSign.text = sub_title;
    
    return nil;
}
@end
