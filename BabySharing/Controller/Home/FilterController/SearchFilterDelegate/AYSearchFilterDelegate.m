//
//  AYSearchFilterDelegate.m
//  BabySharing
//
//  Created by BM on 9/1/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterDelegate.h"
#import "AYSearchFilterCellDefines.h"

#define SECTION_HEAD_FONT_SIZE              24.f
#define SECTION_TEXT_LEFT_MARGIN            10.f
#define SECTION_HEAD_HEIGHT                 50.f

#define LINE_MARGIN                         10.f
#define LINE_COLOR                          [Tools garyLineColor]


#define SEARCH_FILTER_CELL_HEIGHT           90.f

@interface AYSearchFilterDelegate ()
//@property (nonatomic, strong) NSDictionary* querydata;
@end

@implementation AYSearchFilterDelegate {
    NSArray* title_arr;
    NSMutableArray *sub_title_arr;
}

//@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    title_arr = @[@"您孩子的年龄", @"日期", @"类型", @"您期望的价格范围"];
    sub_title_arr = [NSMutableArray arrayWithObjects:@"添加", @"添加", @"添加", @"添加", nil];
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

- (id)changeQueryData:(id)args {
    NSDictionary *dic = (NSDictionary*)args;
    if ([dic objectForKey:@"dob"]) {
        NSTimeInterval dob = ((NSNumber*)[dic objectForKey:@"dob"]).longValue;
        NSTimeInterval now = [NSDate date].timeIntervalSince1970;
        NSTimeInterval howLong = now - dob;
        
        long years = (long)howLong / (86400 * 365);
        long mouths = (long)howLong % (86400 * 365) / (86400 * 30);
        NSString *agesStr = [NSString stringWithFormat:@"%ld岁%ld个月",years,mouths];
        [sub_title_arr replaceObjectAtIndex:0 withObject:agesStr];
        
    } else if ([dic objectForKey:@"filter_date"]) {
        NSTimeInterval filter_data = ((NSNumber*)[dic objectForKey:@"filter_date"]).doubleValue;
        NSDate *filter_date = [NSDate dateWithTimeIntervalSince1970:filter_data];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM月dd日"];
        NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
        [format setTimeZone:timeZone];
        NSString *dateStr = [format stringFromDate:filter_date];
        [sub_title_arr replaceObjectAtIndex:1 withObject:dateStr];
        
    } else if ([dic objectForKey:@"service_type"]) {
        NSArray *options_title_cans = kAY_service_options_title_cans;
        NSString *serviceTypeStr = @"";
        int noteCount = 0;
        long options = ((NSNumber*)[dic objectForKey:@"service_type"]).longValue;
        for (int i = 0; i < options_title_cans.count; ++i) {
            long note_pow = pow(2, i);
            if ((options & note_pow)) {
                serviceTypeStr = [[serviceTypeStr stringByAppendingString:@"、"] stringByAppendingString:options_title_cans[i]];
//                serviceTypeStr = [NSString stringWithFormat:@"%@ ",options_title_cans[i]];
                noteCount ++;
                if (noteCount == 2) {
                    serviceTypeStr = [serviceTypeStr substringFromIndex:1];
                    serviceTypeStr = [serviceTypeStr stringByAppendingString:@"等"];
                    break;
                }
            }
        }
        [sub_title_arr replaceObjectAtIndex:2 withObject:serviceTypeStr];
    } else if ([dic objectForKey:@"lsl"]) {
        NSNumber* usl = ((NSNumber *)[dic objectForKey:@"usl"]);
        NSNumber* lsl = ((NSNumber *)[dic objectForKey:@"lsl"]);
        
        NSString *priceRangeStr = [NSString stringWithFormat:@"%d元-%d元/小时",lsl.intValue,usl.intValue];
        [sub_title_arr replaceObjectAtIndex:3 withObject:priceRangeStr];
    }
    
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return title_arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SEARCH_FILTER_CELL_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYSearchFilterCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
    cell.controller = self.controller;
    
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cell forKey:kAYSearchFilterCellCellKey];
    [dic setValue:[title_arr objectAtIndex:indexPath.row] forKey:kAYSearchFilterCellTitleKey];
    [dic setValue:[sub_title_arr objectAtIndex:indexPath.row] forKey:kAYSearchFilterCellSubTitleKey];
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
        header_text.string = @"筛选";
        header_text.contentsScale = 2.f;
        UIFont* font = [UIFont fontWithName:@"STHeitiSC-Light" size:SECTION_HEAD_FONT_SIZE];
        header_text.fontSize = SECTION_HEAD_FONT_SIZE;
        header_text.font = (__bridge CFTypeRef _Nullable)(font);
//        CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
        CGSize sz = [Tools sizeWithString:@"筛选" withFont:font andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        header_text.frame = CGRectMake(SECTION_TEXT_LEFT_MARGIN, (SECTION_HEAD_HEIGHT - sz.height) / 2 - 2, sz.width, sz.height + 4);
        header_text.foregroundColor = [Tools garyColor].CGColor;
        [header.layer addSublayer:header_text];
        
        
        /**
         * line
         */
        CALayer* line = [CALayer layer];
        line.frame = CGRectMake(LINE_MARGIN, SECTION_HEAD_HEIGHT - 0.5, SCREEN_WIDTH - 2 * LINE_MARGIN, 0.5);
        line.borderColor = LINE_COLOR.CGColor;
        line.borderWidth = 1.f;
        [header.layer addSublayer:line];
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<AYViewBase> cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        id<AYCommand> cmd = [cell.notifies objectForKey:@"filterType:"];
        [cmd performWithResult:&cell];
    } else if (indexPath.row == 0) {
        id<AYCommand> cmd = [cell.notifies objectForKey:@"filterKidsAges:"];
        [cmd performWithResult:&cell];
    } else if (indexPath.row == 3) {
        id<AYCommand> cmd = [cell.notifies objectForKey:@"filterPriceRange:"];
        [cmd performWithResult:&cell];
    } else {
        id<AYCommand> cmd = [cell.notifies objectForKey:@"filterDate:"];
        [cmd performWithResult:&cell];
    }
}
@end
