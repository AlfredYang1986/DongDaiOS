//
//  AYSetNapAgesDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapAgesDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYSelfSettingCellDefines.h"
#import "SGActionView.h"
#import "AYViewController.h"
#import "AYSelfSettingCellView.h"

@implementation AYSetNapAgesDelegate{
    UIPickerView *picker;
    
    NSArray *baby_ages;
    
    NSString *fromAge;
    NSString *toAge;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    baby_ages = @[@"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    picker = pickerView;
    if(component == 1){
        return 1;
    } else
        return 9;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0){
        return baby_ages[row];
    } else if(component == 2){
        return baby_ages[row];
    } else {
        return @"-";
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return [UIScreen mainScreen].bounds.size.width / 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0){
        fromAge = baby_ages[row];
    } else if (component == 2) {
        toAge = baby_ages[row];
    } else {
        
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] init] ;
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor clearColor];
    
    if (component == 0) {
        myView.text = [baby_ages objectAtIndex:row];
    }
    else if (component == 2) {
        myView.text = [baby_ages objectAtIndex:row];
    }
    else myView.text = @"-";
    
    return myView;
}

#pragma mark -- commands
-(id)queryCurrentSelected:(id)args{
    
    NSInteger fromIndex = [picker selectedRowInComponent: 0];
    NSInteger toIndex = [picker selectedRowInComponent: 2];
    
    fromAge = [baby_ages objectAtIndex: fromIndex];
    toAge = [baby_ages objectAtIndex: toIndex];
    
    NSNumber *lsl = [NSNumber numberWithInt:fromAge.intValue];
    NSNumber *usl = [NSNumber numberWithInt:toAge.intValue];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:lsl forKey:@"lsl"];
    [dic setValue:usl forKey:@"usl"];
    
    return dic;
}
@end
