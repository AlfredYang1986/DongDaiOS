//
//  AYFoundController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYAlbumDefines.h"
#import "AYFoundSearchResultCellDefines.h"

#define STATUS_HEIGHT       20
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

#define SEARCH_BOUNDS       CGFloat search_height = 44; \
CGRect rc_search = CGRectMake(0, 0, SCREEN_WIDTH, search_height);

#define FOUND_BOUNDS        CGFloat found_width = [UIScreen mainScreen].bounds.size.width; \
CGFloat found_height = [UIScreen mainScreen].bounds.size.height; \
CGRect rc1 = CGRectMake(0, search_height, found_width, found_height);

#define FOUND_VIEW_START    CGRectMake(0, STATUS_HEIGHT + search_height + 45, rc1.size.width, rc1.size.height - STATUS_HEIGHT - search_height - 49 - 12 - 35)
#define FOUND_VIEW_END      CGRectMake(0, 0, rc1.size.width, rc1.size.height - STATUS_HEIGHT - 49)

#define SEARCH_RECT         CGRectMake(0, STATUS_HEIGHT, rc_search.size.width, rc_search.size.height)

@interface AYFoundController () <UISearchBarDelegate>

@end

@implementation AYFoundController

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

    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"FoundGrid"];
        
        id obj = (id)cmd_pubish;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_pubish;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYAlbumTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];

        id<AYCommand> cmd_change = [cmd_pubish.commands objectForKey:@"changeQueryData:"];
        NSArray* arr = [self enumLocalHomeContent];
        [cmd_change performWithResult:&arr];
    }
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, 40)];
    [self.view addSubview:headview];
    headview.backgroundColor = [UIColor whiteColor];
    UILabel *headLabel = [[UILabel alloc]init];
    [headview addSubview:headLabel];
    headLabel.text = @"发现更多";
    headLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    headLabel.font = [UIFont systemFontOfSize:14.f];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headview);
        make.left.equalTo(headview).offset(10);
    }];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, 64, SCREEN_WIDTH, 1);
    [self.view.layer addSublayer:line];
    
    CALayer* line1 = [CALayer layer];
    line1.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line1.borderWidth = 1.f;
    line1.frame = CGRectMake(0, 69, SCREEN_WIDTH, 1);
    [self.view.layer addSublayer:line1];
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    CGFloat search_height = 44;
    FOUND_BOUNDS
    view.frame = FOUND_VIEW_START;
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {
    SEARCH_BOUNDS
    view.frame = SEARCH_RECT;
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"搜索标签和角色";
    [cmd_place_hold performWithResult:&place_holder];
   
    id<AYCommand> cmd_apperence = [((id<AYViewBase>)view).commands objectForKey:@"foundTitleSearchBar"];
    [cmd_apperence performWithResult:nil];
    return nil;
}

- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat found_width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, found_width, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

#pragma mark -- searh bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    AYViewController* des = DEFAULTCONTROLLER(@"FoundSearch");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [self performWithResult:&dic];
    return NO;
}

#pragma mark -- controller actions
- (NSArray*)enumLocalHomeContent {
    id<AYFacadeBase> f_owner_query = HOMECONTENTMODEL;
    id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"EnumHomeQueryData"];
    NSArray* arr = nil;
    [cmd performWithResult:&arr];
    return arr;
}

#pragma mark -- notifies
- (id)queryIsGridSelected:(id)obj {
//    NSInteger index = ((NSNumber*)obj).integerValue;
//    if (index == current_select_index) {
//        return [NSNumber numberWithBool:YES];
//    } else return [NSNumber numberWithBool:NO];
    return [NSNumber numberWithBool:NO];
}

- (id)selectedValueChanged:(id)obj {
    NSNumber* new_current = [NSNumber numberWithInteger:((NSNumber*)obj).integerValue];
    NSLog(@"%@ is selected", new_current);
    
    AYViewController* des = DEFAULTCONTROLLER(@"Home");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:@"发现详情" forKey:@"home_title"];
    
    id<AYViewBase> seg = [self.views objectForKey:@"DongDaSeg"];
    id<AYCommand> cmd_seg = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd_seg performWithResult:&index];
    
    NSArray* arr = [self enumLocalHomeContent];
    [args setValue:arr forKey:@"content"];
    
    [args setValue:new_current forKey:@"start_index"];
    
    [dic_push setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}
@end
