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
#import "Tools.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"

static NSString* const RoleTagSearchHeader = @"FoundSearchHeader";
static NSString* const RoleTagHotCell = @"FoundHotTagsCell";

@interface AYRoleTagSearchController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AYRoleTagSearchController {
    NSArray* recommands_role_tags;
}
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
    NSString* nib_header_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:RoleTagSearchHeader] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_header performWithResult:&nib_header_name];
    
    id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:RoleTagHotCell] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_hot_cell performWithResult:&class_name];
   
    id<AYFacadeBase> facade_search_remote = [self.facades objectForKey:@"SearchRemote"];
    AYRemoteCallCommand* cmd_query_role_tag = [facade_search_remote.commands objectForKey:@"QueryRecommandRoleTags"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSNumber numberWithInteger:0] forKey:@"skip"];
    [dic setValue:[NSNumber numberWithInteger:10] forKey:@"take"];
    
    [cmd_query_role_tag performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"recommand role tags are: %@", result);
        recommands_role_tags = (NSArray*)result;
       
        id<AYCommand> cmd_reload = [view_table.commands objectForKey:@"refresh"];
        [cmd_reload performWithResult:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell= [tableView dequeueReusableCellWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:RoleTagHotCell] stringByAppendingString:kAYFactoryManagerViewsuffix] forIndexPath:indexPath];
    if (cell == nil) {
        cell = VIEW(RoleTagHotCell, RoleTagHotCell);
    }
    
    cell.controller = self;
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"setHotTagsText:"];
    NSArray* arr = [recommands_role_tags copy];
    [cmd performWithResult:&arr];
    
    return (UITableViewCell*)cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id<AYViewBase> header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:RoleTagSearchHeader] stringByAppendingString:kAYFactoryManagerViewsuffix]];
    if (header == nil) {
        header = VIEW(RoleTagSearchHeader, RoleTagSearchHeader);
    }
   
    header.controller = self;
   
    id<AYCommand> cmd = [header.commands objectForKey:@"changeHeaderTitle:"];
    NSString* str = @"选择或者添加一个你的角色";
    [cmd performWithResult:&str];
   
    UITableViewHeaderFooterView* v = (UITableViewHeaderFooterView*)header;
    v.backgroundView = [[UIImageView alloc] initWithImage:[Tools imageWithColor:[UIColor whiteColor] size:v.bounds.size]];
    return (UIView*)header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> header = VIEW(RoleTagHotCell, RoleTagHotCell);
    id<AYCommand> cmd = [header.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<AYViewBase> header = VIEW(RoleTagSearchHeader, RoleTagSearchHeader);
    id<AYCommand> cmd = [header.commands objectForKey:@"queryHeaderHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}
@end
