//
//  AYUserPerviewController.m
//  BabySharing
//
//  Created by BM on 4/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserPerviewController.h"
#import "AYViewBase.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYUserTableCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "AYModelFacade.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

@implementation AYUserPerviewController {
    NSString* role_tag;
}
#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        role_tag = [dic objectForKey:kAYControllerChangeArgsKey];
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];

    {
        id<AYCommand> cmd_del = [view_table.commands objectForKey:@"registerDelegate:"];
        id<AYCommand> cmd_ds = [view_table.commands objectForKey:@"registerDatasource:"];
        
        id<AYDelegateBase> del = [self.delegates objectForKey:@"UserTablePreview"];
        
        id obj = del;
        [cmd_ds performWithResult:&obj];
        obj = del;
        [cmd_del performWithResult:&obj];
    }
    
    {
        id<AYCommand> cmd_reg = [view_table.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_reg performWithResult:&class_name];
    }
    
    [self refreshQueryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -- actions
- (void)refreshQueryData {
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"UserSearchRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"UserWithRoleTag"];
    
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:role_tag forKey:@"role_tag"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSArray* reVal = [result objectForKey:@"recommandUsers"];
        NSLog(@"search result: %@", reVal);
    
        id<AYDelegateBase> del = [self.delegates objectForKey:@"UserTablePreview"];
        id<AYCommand> cmd_data = [del.commands objectForKey:@"changeQueryData:"];
        [cmd_data performWithResult:&reVal];
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_refresh = [view_table.commands objectForKey:@"refresh"];
        [cmd_refresh performWithResult:nil];
    }];
}

#pragma mark -- layout
- (id)TableLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, 0, width, height - 64);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    id<AYViewBase> v = (id<AYViewBase>)view;
    id<AYCommand> cmd = [v.commands objectForKey:@"changeNevigationBarTitle:"];
    NSString* str = role_tag;
    [cmd performWithResult:&str];
    self.navigationItem.titleView = view;
    return nil;
}

#pragma mark -- notifies 
- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}


@end
