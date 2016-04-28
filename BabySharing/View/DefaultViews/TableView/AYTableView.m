//
//  AYTableView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTableView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"

@implementation AYTableView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- view commands
- (id)registerDatasource:(id)obj {
    id<UITableViewDataSource> d = (id<UITableViewDataSource>)obj;
    self.dataSource = d;
    return nil;
}

- (id)registerDelegate:(id)obj {
    id<UITableViewDelegate> d = (id<UITableViewDelegate>)obj;
    self.delegate = d;
    return nil;
}

- (id)registerCellWithClass:(id)obj {
    NSString* class_name = (NSString*)obj;
    Class c = NSClassFromString(class_name);
    [self registerClass:c forCellReuseIdentifier:class_name];
    return nil;
}

- (id)registerCellWithNib:(id)obj {
    NSString* nib_name = (NSString*)obj;
    [self registerNib:[UINib nibWithNibName:nib_name bundle:[NSBundle mainBundle]] forCellReuseIdentifier:nib_name];
    return nil;
}

- (id)registerHeaderAndFooterWithClass:(id)obj {
    NSString* class_name = (NSString*)obj;
    Class c = NSClassFromString(class_name);
    [self registerClass:c forHeaderFooterViewReuseIdentifier:class_name];
    return nil;
}

- (id)registerHeaderAndFooterWithNib:(id)obj {
    NSString* nib_name = (NSString*)obj;
    [self registerNib:[UINib nibWithNibName:nib_name bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:nib_name];
    return nil;
}

- (id)refresh {
    [self reloadData];
    return nil;
}

- (id)scrollToPostion:(id)obj {
    NSDictionary* dic = (NSDictionary*)obj;
    NSInteger row = ((NSNumber*)[dic objectForKey:@"row"]).integerValue;
    NSInteger section = ((NSNumber*)[dic objectForKey:@"section"]).integerValue;
   
    NSIndexPath* index = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return nil;
}
@end

@implementation AYTable2View

@end
