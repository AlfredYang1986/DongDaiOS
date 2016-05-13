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
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#import "Tools.h"

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
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
//    CALayer* line1 = [CALayer layer];
//    line1.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
//    line1.borderWidth = 1.f;
//    line1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
//    [headView.layer addSublayer:line1];
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 9, [UIScreen mainScreen].bounds.size.width, 1);
    [headView.layer addSublayer:line2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIView* nava = [self.views objectForKey:@"SetNevigationBarTitle"];
    [self.navigationController.navigationBar addSubview:nava];
    
    UIView* left = [self.views objectForKey:@"SetNevigationBarLeftBtn"];
    [self.navigationController.navigationBar addSubview:left];
    
    UIView* view = [self.views objectForKey:@"SearchBar"];
    if (![view isFirstResponder]) {
        [view becomeFirstResponder];
    }
    
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    UIView* view = [self.views objectForKey:@"SearchBar"];
//    if (![view isFirstResponder]) {
//        [view becomeFirstResponder];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIView* nava = [self.views objectForKey:@"SetNevigationBarTitle"];
    [nava removeFromSuperview];
    
    UIView* left =[self.views objectForKey:@"SetNevigationBarLeftBtn"];
    [left removeFromSuperview];
    
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view resignFirstResponder];
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 10, width, height - 74);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
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
    if (![searchText isEqualToString:@""]) {
        
        id<AYFacadeBase> f_search = [self.facades objectForKey:@"UserSearchRemote"];
        AYRemoteCallCommand* cmd_screen_name = [f_search.commands objectForKey:@"UserWithScreenName"];
        NSDictionary* obj = nil;
        CURRENUSER(obj)
        NSMutableDictionary* dic = [obj mutableCopy];
        [dic setValue:searchText forKey:@"screen_name"];
        
        [cmd_screen_name performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
                NSLog(@"query recommand tags result %@", result);
                
                id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
                id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"UserRelations"];
                
                id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"changeFriendsData:"];
                NSArray* tmp = (NSArray*)result;
                [cmd performWithResult:&tmp];
                
                id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
                [cmd_refresh performWithResult:nil];
            }else {
                NSLog(@"UserSearchRemote remote faild");
            }
        }];
    }

}

- (id)searchTextChanged:(id)obj {
    NSString* search_text = (NSString*)obj;
    NSLog(@"text %@", search_text);
    
    return nil;
}

- (id)scrollToHideKeyBoard {
    UIView* view = [self.views objectForKey:@"SearchBar"];
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
    }
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}

@end
