//
//  AYSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYSearchDefines.h"
#import "AYRemoteCallCommand.h"
#import "Tools.h"

#define SEARCH_BAR_HEIGHT   53

@implementation AYSearchController

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
   
    id<AYViewBase> view = [self.views objectForKey:@"SearchBar"];
    id<AYCommand> cmd_apperence = [view.commands objectForKey:@"TagSearchBar"];
    [cmd_apperence performWithResult:nil];
   
    id<AYCommand> cmd_app = [view.commands objectForKey:@"roleTagSearchBar"];
    [cmd_app performWithResult:nil];
    
    id<AYCommand> cmd_reg_search_delegate = [view.commands objectForKey:@"registerDelegate:"];
    id<AYDelegateBase> cmd_search_del = [self.delegates objectForKey:@"SearchBar"];
    id obj_del = (id)cmd_search_del;
    [cmd_reg_search_delegate performWithResult:&obj_del];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"TagRecommend"];
//    id<AYDelegateBase> cmd_add = [self.delegates objectForKey:@"TagAdd"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_header = [view_table.commands objectForKey:@"registerHeaderAndFooterWithNib:"];
    NSString* nib_header_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundSearchHeaderName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_header performWithResult:&nib_header_name];
    
    id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYFoundHotCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_hot_cell performWithResult:&class_name];
    
    AYRemoteCallCommand* cmd_query_role_tag = [self queryDataCommand];
    [cmd_query_role_tag performWithResult:[self queryDataArgs] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"recommand role tags are: %@", result);
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"TagRecommend"];
        id<AYDelegateBase> cmd_add = [self.delegates objectForKey:@"TagAdd"];
       
        NSArray* tmp = [self handleRecommandResult:[result copy]];
        
        id obj = tmp;
        id<AYCommand> cmd_reset_data = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
        [cmd_reset_data performWithResult:&obj];
        
        obj = tmp;
        id<AYCommand> cmd_reset_data_2 = [cmd_add.commands objectForKey:@"changeQueryData:"];
        [cmd_reset_data_2 performWithResult:&obj];
        
        id<AYCommand> cmd_reload = [view_table.commands objectForKey:@"refresh"];
        [cmd_reload performWithResult:nil];
    }];
    
//    CALayer* line = [CALayer layer];
//    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
//    line.borderWidth = 1.f;
//    line.frame = CGRectMake(0, 117, width, 1);
//    [self.view.layer addSublayer:line];
//    
//    CALayer* line_2 = [CALayer layer];
//    line_2.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.1].CGColor;
//    line_2.borderWidth = 1.f;
//    line_2.frame = CGRectMake(0, 127, width, 1);
//    [self.view.layer addSublayer:line_2];
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}

- (id<AYCommand>)queryDataCommand {
    return nil;
}

- (NSDictionary*)queryDataArgs {
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view resignFirstResponder];
}

#pragma mark -- layout
- (id)SearchBarLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat offset = 0; //self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
    view.frame = CGRectMake(0, offset, width, SEARCH_BAR_HEIGHT);
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    self.navigationItem.titleView = view;
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat offset = 0; //self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
    view.frame = CGRectMake(0, offset + SEARCH_BAR_HEIGHT, width, height - offset - SEARCH_BAR_HEIGHT);
    
    view.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f]; //[UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return nil;
}

#pragma mark -- notificaitons
- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
   
    UIView* sb = [self.views objectForKey:@"SearchBar"];
    [sb resignFirstResponder];
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)searchTextChanged:(id)obj {
    NSString* search_text = (NSString*)obj;
    NSLog(@"text %@", search_text);
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    if (search_text.length == 0) {
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"TagRecommend"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    } else {
        id<AYDelegateBase> cmd_add = [self.delegates objectForKey:@"TagAdd"];
        
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

- (NSArray*)handleRecommandResult:(id)result {
    return nil;
}

- (NSArray*)handleResultToString:(NSArray*)result {
    return result;
}

- (id)queryHeaderTitle {
    return @"";
}

- (id)queryHandleCommand {
    return nil;
}

- (id)queryNoResultTitle {
    return nil;
}
@end
