//
//  AYSearchFilterKidsAgesDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 3/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterKidsAgesDelegate.h"
#import "AYNotificationCellDefines.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#define COMPLENTWIDTH           [UIScreen mainScreen].bounds.size.width / 3

@implementation AYSearchFilterKidsAgesDelegate {
    UIPickerView *picker;
    UIButton *button;
    
    NSDictionary *areaDic;
    NSArray *years;
    NSArray *mouths;
    NSArray *days;
    
    NSString *selectedProvince;
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

#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    picker = pickerView;
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [years count];
    }
    else if (component == 1) {
        return [mouths count];
    }
    else {
        return [days count];
    }
}

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [years objectAtIndex: row];
    }
    else if (component == 1) {
        return [mouths objectAtIndex: row];
    }
    else {
        return [days objectAtIndex: row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    //    if (component == 0) {
    //        return 80;
    //    }
    //    else if (component == 1) {
    //        return 100;
    //    }
    //    else {
    //        return 115;
    //    }
    return COMPLENTWIDTH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, COMPLENTWIDTH, 30)] ;
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor clearColor];
    
    if (component == 0) {
        myView.text = [years objectAtIndex:row];
    }
    else if (component == 1) {
        myView.text = [mouths objectAtIndex:row];
    } else myView.text = [days objectAtIndex:row];
    
    return myView;
}

#pragma mark -- messages
- (id)queryCurrentSelected:(id)args{
    NSInteger provinceIndex = [picker selectedRowInComponent: 0];
    NSInteger cityIndex = [picker selectedRowInComponent: 1];
    NSInteger districtIndex = [picker selectedRowInComponent: 2];
    
    NSString *provinceStr = [years objectAtIndex: provinceIndex];
    NSString *cityStr = [mouths objectAtIndex: cityIndex];
    NSString *districtStr = [days objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    NSString *showMsg = [NSString stringWithFormat: @"%@%@%@", provinceStr, cityStr, districtStr];
    NSLog(@"%@",showMsg);
    return showMsg;
}

@end
