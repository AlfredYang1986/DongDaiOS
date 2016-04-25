//
//  AYFoundSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundSearchController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"
#import "AYFoundSearchResultCellDefines.h"

#define STATUS_HEIGHT   20

#define SEARCH_BAR_HEIGHT               44
#define SEG_BAR_HEIGHT                  44
#define MARGIN                          8

#define CANCEL_BTN_WIDTH                70
#define CANCEL_BTN_WIDTH_WITH_MARGIN    70
#define STATUS_BAR_HEIGHT               20
#define TAB_BAR_HEIGHT                  0 //49

@interface AYFoundSearchController () <UISearchBarDelegate>

@end

@implementation AYFoundSearchController {
    NSMutableArray* loading_status;
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

#pragma mark -- life cycle
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
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"FoundTags"];
//        id<AYDelegateBase> cmd_add = [self.delegates objectForKey:@"FoundRoleTag"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_header = [view_table.commands objectForKey:@"registerHeaderAndFooterWithNib:"];
        NSString* nib_header_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundSearchHeaderName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_header performWithResult:&nib_header_name];
        
        id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
        NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundSearchResultCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_search performWithResult:&nib_search_name];
        
        id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundHotCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];
    }
    
    [self queryRecommandData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view resignFirstResponder];
}

- (void)queryRecommandData {
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    id<AYFacadeBase> f_search = [self.facades objectForKey:@"SearchRemote"];
    AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"QueryRecommandTags"];
    AYRemoteCallCommand* cmd_role_tags = [f_search.commands objectForKey:@"QueryRecommandRoleTags"];
    
    [cmd_tags performWithResult:[user copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand tags result %@", result);
            id<AYDelegateBase> del = [self.delegates objectForKey:@"FoundTags"];
            id<AYCommand> cmd = [del.commands objectForKey:@"changeQueryData:"];
            id obj = result;
            [cmd performWithResult:&obj];
        }
    }];
    
    [cmd_role_tags performWithResult:[user copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand role tags result %@", result);
            id<AYDelegateBase> del = [self.delegates objectForKey:@"FoundRoleTag"];
            id<AYCommand> cmd = [del.commands objectForKey:@"changeQueryData:"];
            id obj = result;
            [cmd performWithResult:&obj];
        }
    }];
}

- (void)querySearchDataWithInput:(NSString*)searchText {
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    id<AYFacadeBase> f_search = [self.facades objectForKey:@"SearchRemote"];
    AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchTagWithPreviews"];
    AYRemoteCallCommand* cmd_role_tags = [f_search.commands objectForKey:@"SearchRoleTagWithPreviews"];
   
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:searchText forKey:@"tag_name"];
    [dic setValue:searchText forKey:@"role_tag"];
    
    [cmd_tags performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand tags result %@", result);
            id<AYDelegateBase> del = [self.delegates objectForKey:@"FoundTags"];
            id<AYCommand> cmd = [del.commands objectForKey:@"changePreviewData:"];
            id obj = [result objectForKey:@"preview"];
            [cmd performWithResult:&obj];
        }
    }];
    
    [cmd_role_tags performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand role tags result %@", result);
            id<AYDelegateBase> del = [self.delegates objectForKey:@"FoundRoleTag"];
            id<AYCommand> cmd = [del.commands objectForKey:@"changePreviewData:"];
            id obj = [result objectForKey:@"preview"];
            [cmd performWithResult:&obj];
        }
    }];
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
    
    offset_y += SEARCH_BAR_HEIGHT;
    offset_y += SEG_BAR_HEIGHT + MARGIN;
    view.frame = CGRectMake(0, offset_y, width, height - offset_y - TAB_BAR_HEIGHT);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
    
    view.frame = CGRectMake(0, offset_y, width, SEARCH_BAR_HEIGHT);
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"搜索标签和角色";
    [cmd_place_hold performWithResult:&place_holder];
    
    id<AYCommand> cmd_apperence = [((id<AYViewBase>)view).commands objectForKey:@"foundSearchBar"];
    [cmd_apperence performWithResult:nil];
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
    
    offset_y += SEARCH_BAR_HEIGHT;
    view.frame = CGRectMake(0, offset_y, width, SEG_BAR_HEIGHT);
    
//    view.frame = CGRectMake(0, 0, 100, 200);
    view.backgroundColor = [UIColor whiteColor];
   
    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
    NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
    [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_0 setValue:@"标签" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_0];
    
    NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
    [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_1 setValue:@"角色" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_1];
    
    NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
    [dic_user_info setValue:[NSNumber numberWithFloat:4.f] forKey:kAYSegViewCornerRadiusKey];
    [dic_user_info setValue:[UIColor whiteColor] forKey:kAYSegViewBackgroundColorKey];
    [dic_user_info setValue:[NSNumber numberWithBool:NO] forKey:kAYSegViewLineHiddenKey];
    [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:0.15f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat found_width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, found_width, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, 0, width, height);
    return nil;
}

#pragma mark -- notifications
- (id)segValueChanged:(id)args {
    
    id<AYViewBase> seg = (id<AYViewBase>)args;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    switch (index.intValue) {
        case 1: {
            id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"FoundRoleTag"];
            
            id obj = (id)cmd_pubish;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_pubish;
            [cmd_delegate performWithResult:&obj];
        }
            break;
        case 0: {
            id<AYDelegateBase> cmd_push = [self.delegates objectForKey:@"FoundTags"];
            
            id obj = (id)cmd_push;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_push;
            [cmd_delegate performWithResult:&obj];
        }
            break;
        default:
            break;
    }
    
    id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
    [refresh performWithResult:nil];
    
    return nil;
}

- (id)scrollToHideKeyBoard {
    UIView* view = [self.views objectForKey:@"SearchBar"];
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
    }
    return nil;
}

- (id)startRemoteCall:(id)obj {
   
    NSString* method = (NSString*)obj;
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF=%@", method];
    NSArray* tmp = [loading_status filteredArrayUsingPredicate:p];
    if (tmp.count > 0) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"重复调用接口" userInfo:nil];
    }

    [loading_status addObject:method];
   
    if (loading_status.count == 1) {
        UIView* loading_view = [self.views objectForKey:@"Loading"];
        loading_view.hidden = NO;
        [[((id<AYViewBase>)loading_view).commands objectForKey:@"startGif"] performWithResult:nil];
    }
    return nil;
}

- (id)endRemoteCall:(id)obj {
    
    NSString* method = (NSString*)obj;
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF=%@", method];
    NSArray* tmp = [loading_status filteredArrayUsingPredicate:p];
    if (tmp.count == 0) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"接口调用错误" userInfo:nil];
    }

    NSPredicate* p_not = [NSPredicate predicateWithFormat:@"SELF!=%@", method];
    [loading_status filterUsingPredicate:p_not];
   
    if (loading_status.count == 0) {
        UIView* loading_view = [self.views objectForKey:@"Loading"];
        loading_view.hidden = YES;
        [[((id<AYViewBase>)loading_view).commands objectForKey:@"stopGif"] performWithResult:nil];
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd = [view_table.commands objectForKey:@"refresh"];
        [cmd performWithResult:nil];
    }
    return nil;
}

- (id)TagSeleted:(id)obj {
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)obj;
       
        AYViewController* des = DEFAULTCONTROLLER(@"TagContent");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
        
        [dic_push setValue:dic forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSLog(@"role tag notify");
//        NSString* role_tag = (NSString*)obj;
    }
    
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
        
    } else {
        [self querySearchDataWithInput:searchText];
    }
}
@end
