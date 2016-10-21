//
//  AYSearchFilterPriceRangeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 3/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterPriceRangeDelegate.h"
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

@implementation AYSearchFilterPriceRangeDelegate {
    UIPickerView *picker;
    UIButton *button;
    
    NSArray *priceRange;
    NSString *selectedProvince;
    
    NSString *from;
    NSString *to;
}
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    priceRange = [NSArray arrayWithObjects:@"0", @"50", @"100", @"150", @"200", @"250", @"300", nil];
    
    selectedProvince = [priceRange objectAtIndex: 0];
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

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1) {
        return 1;
    } else {
        return [priceRange count];
    }
}


#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 1) {
        return @"-";
    } else {
        return [priceRange objectAtIndex: row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return COMPLENTWIDTH;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0){
        from = priceRange[row];
    } else if (component == 2) {
        to = priceRange[row];
    } else {
        
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, COMPLENTWIDTH, 30)] ;
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor clearColor];
    
    if (component == 1) {
        myView.text = @"-";
    } else myView.text = [priceRange objectAtIndex:row];
    
    return myView;
}

#pragma mark -- messages
- (id)queryCurrentSelected:(id)args{
    NSInteger fromIndex = [picker selectedRowInComponent: 0];
    NSInteger toIndex = [picker selectedRowInComponent: 2];
    
    from = [priceRange objectAtIndex: fromIndex];
    to = [priceRange objectAtIndex: toIndex];
    
    NSNumber *lsl = [NSNumber numberWithInt:from.intValue];
    NSNumber *usl = [NSNumber numberWithInt:to.intValue];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:lsl forKey:@"lsl"];
    [dic setValue:usl forKey:@"usl"];
    
    return dic;
}

@end
