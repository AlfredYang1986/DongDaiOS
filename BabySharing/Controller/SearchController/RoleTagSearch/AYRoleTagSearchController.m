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
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRoleTagSearchControllerDefines.h"

@implementation AYRoleTagSearchController {
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
    
    id<AYCommand> cmd_apperence = [view.commands objectForKey:@"roleTagSearchBar"];
    [cmd_apperence performWithResult:nil];
    
    id<AYCommand> cmd_reg_search_delegate = [view.commands objectForKey:@"registerDelegate:"];
    id<AYDelegateBase> cmd_search_del = [self.delegates objectForKey:@"RoleTagSearchBar"];
    id obj_del = (id)cmd_search_del;
    [cmd_reg_search_delegate performWithResult:&obj_del];
    
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
    NSString* title = @"添加你的角色";
    [cmd_title performWithResult:&title];

    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
  
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"RoleTagRecommend"];
    id<AYDelegateBase> cmd_add = [self.delegates objectForKey:@"RoleTagAdd"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
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
       
        id obj = [result copy];
        id<AYCommand> cmd_reset_data = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
        [cmd_reset_data performWithResult:&obj];

        obj = [result copy];
        id<AYCommand> cmd_reset_data_2 = [cmd_add.commands objectForKey:@"changeQueryData:"];
        [cmd_reset_data_2 performWithResult:&obj];
        
        id<AYCommand> cmd_reload = [view_table.commands objectForKey:@"refresh"];
        [cmd_reload performWithResult:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- notifications
- (id)searchTextChanged:(id)obj {
    NSString* search_text = (NSString*)obj;
    NSLog(@"text %@", search_text);
  
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    if (search_text.length == 0) {
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"RoleTagRecommend"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    } else {
        id<AYDelegateBase> cmd_add = [self.delegates objectForKey:@"RoleTagAdd"];
        
        id obj = (id)cmd_add;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_add;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_reset_search_text = [cmd_add.commands objectForKey:@"changeSearchText:"];
        [cmd_reset_search_text performWithResult:&search_text];
    }

    id<AYCommand> cmd_reload = [view_table.commands objectForKey:@"refresh"];
    [cmd_reload performWithResult:nil];
    
    return nil;
}

- (id)RoleTagSeleted:(id)obj {
    NSString* role_tag = (NSString*)obj;
    NSLog(@"selected role tag : %@", role_tag);
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_pop setValue:role_tag forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)RoleTagAdded:(id)obj {
    NSString* role_tag = (NSString*)obj;
    NSLog(@"selected role tag : %@", role_tag);
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_pop setValue:role_tag forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}
@end
