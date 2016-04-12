//
//  AYAppSettingDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAppSettingDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"

@interface SettingCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc]init];
        self.label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        self.label.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:self.label];
    }
    return self;
}

@end

@implementation AYAppSettingDelegate {
    NSArray* title;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    title = @[@"去评分", @"关于咚哒", @"清除缓存"];
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
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        CALayer* line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.20].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(8, 44 - 1, tableView.frame.size.width, 1);
        [cell.layer addSublayer:line];
    }
    
    cell.label.text = [title objectAtIndex:indexPath.row];
    [cell.label sizeToFit];
    cell.label.frame = CGRectMake(10, (44 - CGRectGetHeight(cell.label.frame)) / 2, cell.label.frame.size.width, cell.label.frame.size.height);
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cell.label.text isEqualToString:@"退出登录"]) {
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"退出登录"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,str.length)];
        cell.textLabel.attributedText = str;
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    } else if ([cell.label.text isEqualToString:@""]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
   
    } else if ([cell.label.text isEqualToString:@"清除缓存"]) {
        cell.label.text = [cell.label.text stringByAppendingString:[NSString stringWithFormat:@"(%.2fM)", [TmpFileStorageModel tmpFileStorageSize]]];
        [cell.label sizeToFit];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
