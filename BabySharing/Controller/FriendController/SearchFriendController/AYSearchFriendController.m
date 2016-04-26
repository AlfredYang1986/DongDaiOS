//
//  AYSearchFriendController.m
//  BabySharing
//
//  Created by Alfred Yang on 17/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSearchFriendController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

@interface AYSearchFriendController ()<UISearchBarDelegate>

@end

@implementation AYSearchFriendController{
    NSMutableArray* loading_status;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    {
        id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"UserRelations"];
        
        id<AYCommand> cmd_datasource = [view_friend.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_friend.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_relations;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_relations;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_hot_cell = [view_friend.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"UserDisplay"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];
    }
    
    UIView* titleSearch = [self.views objectForKey:@"SearchBar"];
    self.navigationItem.titleView = titleSearch;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view resignFirstResponder];
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, height - 64);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, 44);
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"搜索昵称";
    [cmd_place_hold performWithResult:&place_holder];
    
    id<AYCommand> cmd_apperence = [((id<AYViewBase>)view).commands objectForKey:@"foundSearchBar"];
    [cmd_apperence performWithResult:nil];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, 0, width, height);
    return nil;
}

#pragma mark -- search bar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEqualToString:@""]) {
        {
            id<AYDelegateBase> del = [self.delegates objectForKey:@"FoundTags"];
            id<AYCommand> cmd = [del.commands objectForKey:@"changePreviewData:"];
            id obj = nil;
            [cmd performWithResult:&obj];
        }
        
        {
            id<AYDelegateBase> del = [self.delegates objectForKey:@"FoundRoleTag"];
            id<AYCommand> cmd = [del.commands objectForKey:@"changePreviewData:"];
            id obj = nil;
            [cmd performWithResult:&obj];
        }
        
        id<AYViewBase> view = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd = [view.commands objectForKey:@"refresh"];
        [cmd performWithResult:nil];
        
    }
}

//- (id)searchTextChanged:(id)obj {
//    NSString* search_text = (NSString*)obj;
//    NSLog(@"text %@", search_text);
//    
//    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
//    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
//    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
//    
//    if (search_text.length == 0) {
//        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"TagRecommend"];
//        
//        id obj = (id)cmd_recommend;
//        [cmd_datasource performWithResult:&obj];
//        obj = (id)cmd_recommend;
//        [cmd_delegate performWithResult:&obj];
//    } else {
//        id<AYDelegateBase> cmd_add = [self.delegates objectForKey:@"TagAdd"];
//        
//        id obj = (id)cmd_add;
//        [cmd_datasource performWithResult:&obj];
//        obj = (id)cmd_add;
//        [cmd_delegate performWithResult:&obj];
//        
//        id<AYCommand> cmd_reset_search_text = [cmd_add.commands objectForKey:@"changeSearchText:"];
//        [cmd_reset_search_text performWithResult:&search_text];
//    }
//    
//    id<AYCommand> cmd_reload = [view_table.commands objectForKey:@"refresh"];
//    [cmd_reload performWithResult:nil];
//    
//    return nil;
//}

@end
