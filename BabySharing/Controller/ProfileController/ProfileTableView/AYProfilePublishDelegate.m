//
//  AYProfilePublishDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYProfilePublishDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

@implementation AYProfilePublishDelegate
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = @"alfred test publish";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
@end
