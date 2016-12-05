//
//  AYSearchFilterTypeDelegate.m
//  BabySharing
//
//  Created by BM on 9/1/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterTypeDelegate.h"
#import "AYSearchFilterTypeCellDefines.h"

#define SECTION_HEAD_FONT_SIZE              24.f
#define SECTION_TEXT_LEFT_MARGIN            10.f
#define SECTION_HEAD_HEIGHT                 50.f

#define LINE_MARGIN                         10.f
#define LINE_COLOR                          [Tools blackColor]


#define SEARCH_FILTER_CELL_HEIGHT           60.f

@implementation AYSearchFilterTypeDelegate {
    NSArray* title_arr;
}

//@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    title_arr = kAY_service_options_title_course;
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return title_arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SEARCH_FILTER_CELL_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYSearchFilterTypeCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
    cell.controller = self.controller;
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cell forKey:kAYSearchFilterTypeCellCellKey];
    [dic setValue:[title_arr objectAtIndex:indexPath.row] forKey:kAYSearchFilterTypeCellTitleKey];
    [dic setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"tag_index"];
    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEAD_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"default"];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"default"];
        header.backgroundView = [[UIImageView alloc] initWithImage:[Tools imageWithColor:[UIColor whiteColor] size:header.bounds.size]];
        
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTION_HEAD_HEIGHT)];
        v.backgroundColor = [UIColor whiteColor];
        [header addSubview:v];
        
        /**
         * title
         */
        CATextLayer* header_text = [CATextLayer layer];
        header_text.string = @"服务类型";
        header_text.contentsScale = 2.f;
        UIFont* font = [UIFont systemFontOfSize:SECTION_HEAD_FONT_SIZE];
        header_text.fontSize = SECTION_HEAD_FONT_SIZE;
        CGSize sz = [Tools sizeWithString:@"服务类型" withFont:font andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        header_text.frame = CGRectMake(SECTION_TEXT_LEFT_MARGIN, (SECTION_HEAD_HEIGHT - sz.height) / 2 - 2, sz.width, sz.height + 4);
        header_text.foregroundColor = [Tools blackColor].CGColor;
        [header.layer addSublayer:header_text];
        
        /**
         * line
         */
        CALayer* line = [CALayer layer];
        line.frame = CGRectMake(LINE_MARGIN, SECTION_HEAD_HEIGHT - 1, SCREEN_WIDTH - 2 * LINE_MARGIN, 1);
        line.borderColor = LINE_COLOR.CGColor;
        line.borderWidth = 1.f;
        [header.layer addSublayer:line];
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
