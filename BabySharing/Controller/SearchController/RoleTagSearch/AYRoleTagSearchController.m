//
//  AYRoleTagSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRoleTagSearchController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

static NSString* const RoleTagSearchHeader = @"AYFoundSearchHeaderView";

@interface AYRoleTagSearchController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AYRoleTagSearchController
#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        //        _login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        //        NSLog(@"init args are : %@", _login_attr);
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<AYViewBase> view = [self.views objectForKey:@"SearchBar"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeSearchBarPlaceHolder:"];
    NSString* str = @"请输入角色标签";
    [cmd performWithResult:&str];
    
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
    NSString* title = @"添加你的角色";
    [cmd_title performWithResult:&title];

    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
   
    id obj = (id)self;
    [cmd_datasource performWithResult:&obj];
    obj = (id)self;
    [cmd_delegate performWithResult:&obj];

    id<AYCommand> cmd_header = [view_table.commands objectForKey:@"registerHeaderAndFooterWithNib:"];
    NSString* nib_header_name = RoleTagSearchHeader;
    [cmd_header performWithResult:&nib_header_name];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = @"test";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id<AYViewBase> header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:RoleTagSearchHeader];
    if (header == nil) {
        header = VIEW(RoleTagSearchHeader, RoleTagSearchHeader);
    }
   
    header.controller = self;
   
    id<AYCommand> cmd = [header.commands objectForKey:@"changeHeaderTitle:"];
    NSString* str = @"选择或者添加一个你的角色";
    [cmd performWithResult:&str];
    
    return (UIView*)header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
@end
