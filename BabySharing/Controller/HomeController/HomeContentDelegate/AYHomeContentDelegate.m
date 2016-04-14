//
//  AYHomeContentDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYHomeContentDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYUserDisplayDefines.h"

#import "QueryContent.h"

@implementation AYHomeContentDelegate {
    NSArray* querydata;
}
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
    return querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"]; //forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
   
    QueryContent* tmp = [querydata objectAtIndex:indexPath.row];
    cell.textLabel.text = tmp.content_description;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -- messages
- (id)changeQueryData:(id)obj {
    querydata = (NSArray*)obj;
    return nil;
}
@end
