//
//  AYBabyInfoPickerDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 13/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBabyInfoPickerDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYSelfSettingCellDefines.h"
#import "SGActionView.h"
#import "AYViewController.h"
#import "AYSelfSettingCellView.h"

@implementation AYBabyInfoPickerDelegate{
    NSArray *years;
    NSArray *mouths;
    NSArray *days;
    
    NSString *brith_year;
    NSString *brith_mouth;
    NSString *brith_day;
}
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    NSString *dateArr = [dateString componentsSeparatedByString:@"-"].firstObject;
    CGFloat lastest = dateArr.floatValue;
    CGFloat limit = 20;
    NSMutableArray *tmp_year = [NSMutableArray array];
    
    for (int i = 0; i< limit; ++i) {
        int year = lastest - (limit - i);
        NSString *yearStr = [NSString stringWithFormat:@"%d年",year];
        [tmp_year addObject:yearStr];
    }
    years = [tmp_year copy];
    
    NSMutableArray *tmp_mouth = [NSMutableArray array];
    for (int i = 0; i < 12*5; ++i) {
        int mouth = i % 12 + 1;
        NSString *mouthStr = [NSString stringWithFormat:@"%d月", mouth];
        [tmp_mouth addObject:mouthStr];
    }
    mouths = [tmp_mouth copy];
    
    NSMutableArray *tmp_day = [NSMutableArray array];
    for (int i = 0; i < 31*3; ++i) {
        int day = i % 31 + 1;
        NSString *dayStr = [NSString stringWithFormat:@"%d日", day];
        [tmp_day addObject:dayStr];
    }
    days = [tmp_day copy];
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

#pragma mark -- picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0){
        return years.count;
    } else if(component == 1){
        return mouths.count;
    } else
        return days.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        return years[row];
    } else if(component == 1){
        return mouths[row];
    } else
        return days[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH / 3 - 20;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0){
        brith_year = years[row];
    } else if(component == 1){
        brith_mouth = mouths[row];
    } else
        brith_day = days[row];
}

-(id)queryBabyBirthday:(id)args{
    if (!brith_year || [brith_year isEqualToString:@""]) {
        brith_year = years[0];
    }
    if (!brith_mouth || [brith_mouth isEqualToString:@""]) {
        brith_mouth = mouths[0];
    }
    if (!brith_day || [brith_day isEqualToString:@""]) {
        brith_day = days[0];
    }
    
    NSString *birthday = [[brith_year stringByAppendingString:brith_mouth] stringByAppendingString:brith_day];
    
    return birthday;
}

@end
