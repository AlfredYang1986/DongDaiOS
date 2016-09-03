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
#import "LoginToken.h"
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
    years = [NSArray arrayWithObjects:@"2008年",@"2009年",@"2010年",@"2011年",@"2012年",@"2013年",@"2014年",@"2015年",@"2016年", nil];
    
    mouths = [NSArray arrayWithObjects:@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月", @"11月", @"12月", nil];
    
    days = [NSArray arrayWithObjects:@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日", nil];
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
