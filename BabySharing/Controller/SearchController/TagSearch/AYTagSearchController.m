//
//  AYTagSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagSearchController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYSearchDefines.h"

#import "PhotoTagEnumDefines.h"

@interface AYTagSearchController ()
@property (nonatomic, setter=setCurrentStatus:) TagType status;
@end

@implementation AYTagSearchController {
    TagType current_type;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        current_type = ((NSNumber*)[dic objectForKey:kAYControllerChangeArgsKey]).integerValue;
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.status = current_type;
    
    UIView* view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    UIView* view_bar = [self.views objectForKey:@"FakeNavBar"];
    [view_title sizeToFit];
    view_title.center = CGPointMake(view_bar.frame.size.width / 2, view_bar.frame.size.height / 2);
    [view_bar addSubview:view_title];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (id<AYCommand>)queryDataCommand {
    id<AYFacadeBase> facade_search_remote = [self.facades objectForKey:@"SearchRemote"];
    AYRemoteCallCommand* cmd_query_role_tag = [facade_search_remote.commands objectForKey:@"QueryRecommandTags"];
    return cmd_query_role_tag;
}

- (NSDictionary*)queryDataArgs {
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:[NSNumber numberWithInteger:current_type] forKey:@"tag_type"];
    return [dic copy];
}

- (void)setCurrentStatus:(TagType)status {
    _status = status;
  
    NSString* place_holder = nil;
    NSString* title = nil;
    
    switch (_status) {
        case TagTypeBrand: {
            place_holder = @"请输入品牌";
            title = @"添加品牌";
            }
            break;
        case TagTypeLocation: {
            place_holder = @"请输入地址";
            title = @"添加地址";
            }
            break;
        case TagTypeTime: {
            place_holder = @"请输入时刻";
            title = @"添加时刻";
            }
            break;
            
        default:
            return;
    }
    
    id<AYViewBase> view = [self.views objectForKey:@"SearchBar"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeSearchBarPlaceHolder:"];
    [cmd performWithResult:&place_holder];
    
    
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
    [cmd_title performWithResult:&title];
}

#pragma mark -- layout
- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 64);
    view.backgroundColor = [UIColor whiteColor];
   
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    id right = [NSNumber numberWithBool:YES];
    [cmd_right performWithResult:&right];
    
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {
    [super SearchBarLayout:view];
//    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + 64, view.frame.size.width, view.frame.size.height);
    view.frame = CGRectMake(5, view.frame.origin.y + 64, view.frame.size.width, view.frame.size.height);
    return nil;
}

- (id)TableLayout:(UIView *)view {
    [super TableLayout:view];
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + 64, view.frame.size.width, view.frame.size.height - 64);
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    return nil;
}

#pragma mark -- life cycle
- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

#pragma mark -- notifications
- (id)TagAdded:(id)obj {
    return nil;
}

- (id)TagSeleted:(id)obj {
   
    NSDictionary* dic = (NSDictionary*)obj;
    NSString* tag = [dic objectForKey:@"tag_name"];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:[NSNumber numberWithInteger:current_type] forKey:@"tag_type"];
    [args setValue:tag forKey:@"tag_text"];
   
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_pop setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    
    return nil;
}

- (id)leftBtnSelected {
    id<AYCommand> cmd = POP;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [cmd performWithResult:&dic];
    return nil;
}

- (NSArray*)handleRecommandResult:(id)result {
    return [result objectForKey:@"recommands"];
}

- (id)handleResultToString:(id)args {
    NSArray* result = (NSArray*)args;
    NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:result.count];
    for (NSDictionary* tmp in result) {
        [arr addObject:[tmp objectForKey:@"tag_name"]];
    }
    return [arr copy];
}

- (id)queryHeaderTitle {
    return @"选择或者添加一个标签";
}

- (id)queryHandleCommand {
    return @"setHotTags:";
}

- (id)queryNoResultTitle {
    return @"解锁新标签：%@";
}
@end
