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
#import "Tools.h"

@implementation AYRoleTagSearchController
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
}

- (id<AYCommand>)queryDataCommand {
    id<AYFacadeBase> facade_search_remote = [self.facades objectForKey:@"SearchRemote"];
    AYRemoteCallCommand* cmd_query_role_tag = [facade_search_remote.commands objectForKey:@"QueryAllRoleTags"];
    return cmd_query_role_tag;
}

- (NSDictionary*)queryDataArgs {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSNumber numberWithInteger:0] forKey:@"skip"];
    [dic setValue:[NSNumber numberWithInteger:10] forKey:@"take"];
    return [dic copy];
}

- (NSArray*)handleRecommandResult:(id)result {
    return result;
}

#pragma mark -- notifications
- (id)TagAdded:(id)obj {
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

- (id)TagSeleted:(id)obj {
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

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}

- (id)queryHeaderTitle {
    return @"选择或者添加一个你的角色";
}

- (id)queryHandleCommand {
    return @"setHotTagsText:";
}

- (id)queryNoResultTitle {
    return @"解锁新角色：%@";
}
@end
