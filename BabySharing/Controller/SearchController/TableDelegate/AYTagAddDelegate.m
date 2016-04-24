//
//  AYRoleTagAddDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagAddDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYSearchDefines.h"
#import "Tools.h"

@implementation AYTagAddDelegate

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize showing_tags = _showing_tags;
@synthesize recommand_tags = _recommand_tags;
@synthesize searchText = _searchText;

- (void)postPerform {
    
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
//    return 1;
    return 1 + _showing_tags.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width - 10, 43)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [Tools colorWithRED:74.0 GREEN:74.0 BLUE:74.0 ALPHA:1.0];
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 + 10, 21);
        [cell.contentView addSubview:label];
        label.tag = -1;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 1)];
        line.backgroundColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.0];
        [cell.contentView addSubview:line];
    }
    
    UILabel *label = [cell.contentView viewWithTag:-1];
    
    if (indexPath.row == 0) {
        
        id<AYCommand> cmd = [self.notifies objectForKey:@"queryNoResultTitle"];
        NSString* str = nil;
        [cmd performWithResult:&str];
        
        label.text =  [NSString stringWithFormat:str, _searchText];
    } else {
        label.text = [_showing_tags objectAtIndex:indexPath.row - 1];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    id<AYCommand> n = nil;
    NSString* role_tag = nil;
    n = [self.notifies objectForKey:@"TagSeleted:"];
    if (indexPath.row == 0) {
//        n = [self.notifies objectForKey:@"TagSeleted:"];
        role_tag = _searchText;
    } else {
//        n = [self.notifies objectForKey:@"TagAdded:"];
        role_tag = [_showing_tags objectAtIndex:indexPath.row - 1];
    }
    [n performWithResult:&role_tag];
}

#pragma mark -- command
- (id)changeQueryData:(id)obj {
    _recommand_tags = (NSArray*)obj;
    _showing_tags = [_recommand_tags copy];
    return nil;
}

- (id)changeSearchText:(id)obj {
    _searchText = (NSString*)obj;
    
    NSArray* tmp = [_recommand_tags copy];
    id<AYCommand> cmd = [self.notifies objectForKey:@"handleResultToString:"];
    [cmd performWithResult:&tmp];
    
    _showing_tags = [[Tools sortWithArr:tmp headStr:_searchText] copy];
    return nil;
}
@end
