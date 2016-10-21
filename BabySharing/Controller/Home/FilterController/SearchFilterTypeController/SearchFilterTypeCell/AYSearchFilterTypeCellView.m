//
//  AYSearchFilterTypeCellView.m
//  BabySharing
//
//  Created by BM on 9/1/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterTypeCellView.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYSearchFilterTypeCellDefines.h"

#define LINE_MARGIN                         10.f
#define LINE_COLOR                          [Tools garyLineColor]
#define SEARCH_FILTER_CELL_HEIGHT           60.f
#define TITLE_TEXT_COLOR                    [Tools garyColor]

@interface AYSearchFilterTypeCellView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *isSeletced;

@end

@implementation AYSearchFilterTypeCellView

@synthesize titleLabel = _titleLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpReuseCell];
    
    [_isSeletced setImage:IMGRESOURCE(@"icon_pick") forState:UIControlStateNormal];
    [_isSeletced setImage:IMGRESOURCE(@"icon_pick_selected") forState:UIControlStateSelected];
    
    CALayer* line = [CALayer layer];
    line.frame = CGRectMake(LINE_MARGIN, SEARCH_FILTER_CELL_HEIGHT - 1, SCREEN_WIDTH - 2 * LINE_MARGIN, 1);
    line.borderColor = LINE_COLOR.CGColor;
    line.borderWidth = 1.f;
    [self.layer addSublayer:line];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYSearchFilterTypeCellName, kAYSearchFilterTypeCellName);
    
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

#pragma mark -- actins
- (IBAction)didSelectedBtnClick:(id)sender {
//    _isSeletced.selected = !_isSeletced.selected;
    id<AYCommand> cmd = [self.notifies objectForKey:@"didOptionBtnClick:"];
    [cmd performWithResult:&sender];
}


- (id)setCellInfo:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    AYSearchFilterTypeCellView* cell = [dic objectForKey:kAYSearchFilterTypeCellCellKey];
    NSString* title = [dic objectForKey:kAYSearchFilterTypeCellTitleKey];
    cell.titleLabel.text = title;
    cell.titleLabel.textColor = TITLE_TEXT_COLOR;
    [cell.titleLabel sizeToFit];
    
    NSInteger index = ((NSNumber*)[dic objectForKey:@"tag_index"]).integerValue;
    cell.isSeletced.tag = index;
    
    return nil;
}
@end
