//
//  AYTagContentController.m
//  BabySharing
//
//  Created by BM on 4/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagContentController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"
#import "AYHomeCellDefines.h"

#import "MJRefresh.h"

typedef void(^refreshFinishBlock)(void);

@implementation AYTagContentController {
    NSString* tag_name;
    NSNumber* tag_type;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        tag_name = [args objectForKey:@"tag_name"];
        tag_type = [args objectForKey:@"tag_type"];
        self.push_home_title = tag_name;
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    self.isPushed = YES;
    [super viewDidLoad];
   
    id<AYViewBase> view_content = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
    id<AYCommand> cmd_datasource = [view_content.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_content.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)del;
    [cmd_datasource performWithResult:&obj];
    obj = (id)del;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_cell = [view_content.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYHomeCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_cell performWithResult:&class_name];

    id<AYCommand> cmd_reg = [del.commands objectForKey:@"setCallBackTableView:"];
    [cmd_reg performWithResult:&view_content];
    
    [self setTagContentRefresh];
    
    [self queryTagContentData:^{
        id<AYViewBase> view = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_refresh = [view.commands objectForKey:@"refresh"];
        [cmd_refresh performWithResult:nil];
    }];
}

- (void)setTagContentRefresh {
    id<AYViewBase> view = [self.views objectForKey:@"Table"];
    __unsafe_unretained UITableView *tableView = (UITableView*)view;
    
    // 下拉刷新
    tableView.mj_header = [BSRefreshAnimationHeader headerWithRefreshingBlock:^{
        [self queryTagContentData:^{
            [tableView reloadData];
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [BSRefreshAnimationFooter footerWithRefreshingBlock:^{
        [self appendTagContentData:^{
            [tableView reloadData];
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

- (void)queryTagContentData:(refreshFinishBlock)block {
    id<AYFacadeBase> f = [self.facades objectForKey:@"ContentQueryRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"QueryContentsWithTag"];
    
    NSDictionary* user = nil;
    CURRENUSER(user)
    
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:tag_type forKey:@"tag_type"];
    [dic setValue:tag_name forKey:@"tag_name"];
    [dic setValue:[NSNumber numberWithInteger:0] forKey:@"skip"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"query content with tags %@", result);
       
        id<AYFacadeBase> f = TAGCONTENTMODEL;
        id<AYCommand> cmd = [f.commands objectForKey:@"RefrashTagContentData"];
        id args = result;
        [cmd performWithResult:&args];
        
        NSArray* data = [self enumLocalTagContent];

        id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
        id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
        [cmd_change performWithResult:&data];
        
        if (block) block();
    }];
}

- (void)appendTagContentData:(refreshFinishBlock)block {

    NSDictionary* user = nil;
    CURRENUSER(user);
    
    {
        NSArray* arr = [self enumLocalTagContent];
        
        id<AYFacadeBase> f_query_content = [self.facades objectForKey:@"ContentQueryRemote"];
        AYRemoteCallCommand* cmd_query_content = [f_query_content.commands objectForKey:@"QueryContentsWithTag"];
        
        NSMutableDictionary* dic = [user mutableCopy];
        [dic setValue:tag_type forKey:@"tag_type"];
        [dic setValue:tag_name forKey:@"tag_name"];
        [dic setValue:[NSNumber numberWithInteger:arr.count] forKey:@"skip"];
        
        id<AYCommand> cmd_time_span = [f_query_content.commands objectForKey:@"EnumTagContentTimeSpan"];
        NSDate* d = nil;
        [cmd_time_span performWithResult:&d];
        [dic setValue:d forKey:@"date"];
        
        [cmd_query_content performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"user post result %@", result);
            
            NSDictionary* args = [result copy];
            
            id<AYFacadeBase> f_owner_query = TAGCONTENTMODEL;
            id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"AppendHomeQueryData"];
            [cmd performWithResult:&args];
            
            id<AYDelegateBase> del = [self.delegates objectForKey:@"HomeContent"];
            id<AYCommand> cmd_change = [del.commands objectForKey:@"changeQueryData:"];
            NSArray* arr = [self enumLocalTagContent];
            [cmd_change performWithResult:&arr];
            
            block();
        }];
    }
}

- (NSArray*)enumLocalTagContent {
    id<AYFacadeBase> f = TAGCONTENTMODEL;
    id<AYCommand> cmd_enum = [f.commands objectForKey:@"EnumTagContentData"];
    NSArray* data = nil;
    [cmd_enum performWithResult:&data];
    return data;
}

@end
