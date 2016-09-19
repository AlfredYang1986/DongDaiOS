//
//  AYProfileController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYProfileController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"

#import "AYModelFacade.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#define STATUS_BAR_HEIGHT       20
#define FAKE_BAR_HEIGHT        44

#define QUERY_VIEW_MARGIN_LEFT      10.5
#define QUERY_VIEW_MARGIN_RIGHT     QUERY_VIEW_MARGIN_LEFT
#define QUERY_VIEW_MARGIN_UP        STATUS_BAR_HEIGHT
#define QUERY_VIEW_MARGIN_BOTTOM    0

#define HEADER_VIEW_HEIGHT          183

#define MARGIN_LEFT                 10.5
#define MARGIN_RIGHT                10.5

#define SEG_CTR_HEIGHT              49

@interface AYProfileController ()
@property (nonatomic, setter=setCurrentStatus:) RemoteControllerStatus status;
@end

@implementation AYProfileController {
    BOOL isPushed;
    NSString* owner_id;
    NSString* screen_name;
    NSDictionary* profile_dic;
    
//    NSArray* post_content;
//    NSArray* push_content;
    
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        owner_id = [dic objectForKey:kAYControllerChangeArgsKey];
        isPushed = YES;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *info = [dic objectForKey:kAYControllerChangeArgsKey];
        
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Profile"];
        id<AYCommand> cmd = [cmd_notify.commands objectForKey:@"changeQueryData:"];
        NSDictionary *dic = [info copy];
        [cmd performWithResult:&dic];
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
        [refresh performWithResult:nil];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
    UIColor* c_nav = [UIColor whiteColor];
    [cmd_nav performWithResult:&c_nav];
    
    id<AYCommand> cmd_right_vis = [nav.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    if (!isPushed) {
        
        id<AYCommand> cmd_left_vis = [nav.commands objectForKey:@"setLeftBtnVisibility:"];
        NSNumber* left_hidden = [NSNumber numberWithBool:YES];
        [cmd_left_vis performWithResult:&left_hidden];
    }
    
    {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Profile"];
        
        id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = @"AYProfileHeadCellView";
        [cmd_cell performWithResult:&class_name];
    }
    
    id<AYFacadeBase> remote = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [remote.commands objectForKey:@"QueryUserProfile"];
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    NSMutableDictionary* dic = [user mutableCopy];
    if (owner_id) {
        [dic setValue:owner_id forKey:@"owner_user_id"];
    } else {
        [dic setValue:[user objectForKey:@"user_id"]  forKey:@"owner_user_id"];
    }
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Profile"];
            id<AYCommand> cmd = [cmd_notify.commands objectForKey:@"changeQueryData:"];
            NSDictionary *dic = [result copy];
            [cmd performWithResult:&dic];
            
            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
            id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
            [refresh performWithResult:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
//    ((UITableView*)view).style = UITableViewStyleGrouped;
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    id<AYViewBase> bar = (id<AYViewBase>)view;
    if (isPushed) {
        id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
        UIImage* left = IMGRESOURCE(@"bar_left_black");
        [cmd_left performWithResult:&left];
    }
    
//    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
//    NSString *title = @"沟通";
//    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    [cmd_bot performWithResult:nil];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"我的";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [Tools blackColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 44 / 2 + 20);
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view.hidden = YES;
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

- (id)queryIsGridSelected:(id)obj {
    //    NSInteger index = ((NSNumber*)obj).integerValue;
    return [NSNumber numberWithBool:NO];
}


- (id)SamePersonBtnSelected {
    NSLog(@"push to person setting");
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:profile_dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

- (id)queryTargetID {
    id result = owner_id;
    return result;
}

- (id)relationChanged:(id)args {
    NSNumber* new_relations = (NSNumber*)args;
    NSLog(@"new relations %@", new_relations);
    
    id<AYViewBase> view_header = [self.views objectForKey:@"ProfileHeader"];
    id<AYCommand> cmd = [view_header.commands objectForKey:@"changeRelations:"];
    [cmd performWithResult:&new_relations];
    
    return nil;
}


- (id)sendRegMessage:(NSNumber*)type {
    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
//    id<AYCommand> des = DEFAULTCONTROLLER(@"TabBarService");
    
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
//    [dic_show_module setValue:kAYControllerActionShowModuleValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
    [dic_show_module setValue:type forKey:kAYControllerChangeArgsKey];
    
//    id<AYCommand> cmd_show_module = SHOWMODULE;
//    [cmd_show_module performWithResult:&dic_show_module];

    id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
    [cmd_show_module performWithResult:&dic_show_module];
    
    return nil;
}
#pragma mark -- status

@end
